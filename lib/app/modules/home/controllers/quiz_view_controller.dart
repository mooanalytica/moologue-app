import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:moo_logue/app/core/constants/app_const.dart';
import 'package:moo_logue/app/core/storage/get_storage.dart';
import 'package:moo_logue/app/core/storage/quiz_storage.dart';
import 'package:moo_logue/app/model/quiz_model.dart';
import 'package:moo_logue/app/utils/quiz_generate_screen.dart';
import 'package:moo_logue/app/widgets/my_loader.dart';
import 'package:path_provider/path_provider.dart';

class QuizViewController extends GetxController {
  QuizViewController(); // Remove audioId

  final QuizStorage _quizStorage = QuizStorage();
  QuizSession? _session;

  var isCorrect = false.obs;
  RxBool isZoomedOut = false.obs;
  RxInt currentPage = 0.obs;
  RxInt selectQuiz = (-1).obs;
  RxBool isButtonEnabled = false.obs;
  final RxBool showFeedback = false.obs;

  final ja.AudioPlayer audioPlayer = ja.AudioPlayer();
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  bool isRepeating = false;
  bool isMuted = false;
  bool isPlaying = false;
  bool isReady = false;
  bool isAudioPlay = false;
  var currentQuestionIndex = 0.obs;

  // waveform/audio loading flag
  RxBool isAudioLoading = false.obs;

  // indices locked after user taps Check Answer
  final RxSet<int> lockedIndices = <int>{}.obs;

  bool isQuizComplete() => lockedIndices.length >= maxValue;

  bool _completionAwarded = false;
  bool _attemptAwarded = false; // +1 once per quiz on first attempt

  // ========================= CORE QUIZ FUNCTIONS =========================

  Future<void> clearSessionAndExit(BuildContext context) async {
    try {
      if (isQuizComplete() && !_completionAwarded) {
        final correct = answerAttempts.where((a) => a.isCorrect).length;
        await _awardCompletionBonus(correctCount: correct, totalQuestions: answerAttempts.length);
        _completionAwarded = true;
      }
      await audioPlayer.stop();
      await audioPlayer.dispose();

      for (var w in waveformControllers) {
        w.dispose();
      }

      await _quizStorage.clearSession(); // Use global session
    } catch (_) {}
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> nextQuestionAndPlay() async {
    if (quizQuestions != null && currentQuestionIndex.value < quizQuestions!.length - 1) {
      await _changeQuestion(currentQuestionIndex.value + 1);
    }
  }

  Future<void> previousQuestionAndPlay() async {
    if (quizQuestions != null && currentQuestionIndex.value > 0) {
      await _changeQuestion(currentQuestionIndex.value - 1);
    }
  }

  Future<void> _changeQuestion(int newIndex) async {
    await audioPlayer.stop();
    await waveformControllers[currentQuestionIndex.value].seekTo(0);
    await waveformControllers[currentQuestionIndex.value].stopPlayer();
    if (waveformControllers.isNotEmpty && currentQuestionIndex.value < waveformControllers.length) {
      await waveformControllers[currentQuestionIndex.value].stopPlayer();
    }

    currentQuestionIndex.value = newIndex;
    currentPage.value = newIndex;
    currentValue = newIndex + 1;
    selectQuiz.value = -1;
    await audioPlayer.seek(Duration.zero);

    if (waveformControllers.isNotEmpty && newIndex < waveformControllers.length) {
      if (localPaths[newIndex] == null) {
        final audioFileUrl = audioUrls[newIndex];
        if (audioFileUrl != null && audioFileUrl.isNotEmpty) {
          await _prepareAudio(newIndex, audioFileUrl);
        }
      }

      final localPath = localPaths[newIndex];
      if (localPath != null) {
        await waveformControllers[newIndex].seekTo(0);
        await waveformControllers[newIndex].stopPlayer();
        await waveformControllers[newIndex].preparePlayer(path: localPath, shouldExtractWaveform: true, volume: 1.0, noOfSamples: 200);
        await audioPlayer.setFilePath(localPath);
      }
    }

    _persistSession();
    update();
  }

  // ========================= QUIZ STATE =========================

  List<QuizQuestion>? quizQuestions;
  final Map<int, String> _selectedAnswers = {};
  final Map<int, String> audioUrls = {};
  final Map<int, String> localPaths = {};
  List<PlayerController> waveformControllers = [];
  String? _audioFilePath;
  var isAnswerCorrect = RxnBool();
  int currentValue = 0;
  int maxValue = 10;
  RxList<AnswerAttempt> answerAttempts = <AnswerAttempt>[].obs;

  void lockCurrentAnswer() {
    final idx = currentQuestionIndex.value;
    final bool added = lockedIndices.add(idx);
    if (added) {
      _awardAttemptOnce();
      final attempt = (answerAttempts.length > idx) ? answerAttempts[idx] : null;
      if (attempt?.isCorrect ?? false) _awardCorrect();
      _persistSession();
      update();
    }
  }

  bool isCurrentLocked() => lockedIndices.contains(currentQuestionIndex.value);

  void checkAnswer(String selectedOption) {
    if (quizQuestions == null || quizQuestions!.isEmpty) return;
    final idx = currentQuestionIndex.value;

    if (lockedIndices.contains(idx)) return;

    final currentQuestion = quizQuestions![idx];
    final correctAnswer = (currentQuestion.mainCategoryOptions.isNotEmpty)
        ? currentQuestion.correctMainCategory
        : currentQuestion.correctSubCategory;

    final isCorrect = selectedOption.trim().toLowerCase() == correctAnswer.trim().toLowerCase();
    isAnswerCorrect.value = isCorrect;

    _selectedAnswers[idx] = selectedOption;

    if (answerAttempts.length > idx) {
      answerAttempts[idx] = AnswerAttempt(
        question: currentQuestion.audioFile,
        selectedAnswer: selectedOption,
        correctAnswer: correctAnswer,
        isCorrect: isCorrect,
      );
    } else {
      while (answerAttempts.length < idx) {
        answerAttempts.add(AnswerAttempt(question: '', selectedAnswer: '', correctAnswer: '', isCorrect: false));
      }
      answerAttempts.add(
        AnswerAttempt(
          question: currentQuestion.audioFile,
          selectedAnswer: selectedOption,
          correctAnswer: correctAnswer,
          isCorrect: isCorrect,
        ),
      );
    }

    _persistSession();
    update();
  }

  void checkForButtonEnabled(String value) {
    isButtonEnabled.value = value.isNotEmpty;
    update();
  }

  void applyPersistedSelectionForCurrentIndex(List<String> options) {
    final idx = currentQuestionIndex.value;
    final saved = _selectedAnswers[idx];
    selectQuiz.value = saved == null ? -1 : options.indexWhere((o) => o.trim().toLowerCase() == saved.trim().toLowerCase());
  }

  // ========================= POINTS =========================

  Future<void> _awardAttemptOnce() async {
    if (_attemptAwarded) return;
    String? userId = AppStorage.getString(AppStorage.userId);
    if (userId == null) return;
    try {
      await FirebaseFirestore.instance.collection(usersCollection).doc(userId).set({
        'totalPoints': FieldValue.increment(1),
        'endDate': Timestamp.now(),
      }, SetOptions(merge: true));
      _attemptAwarded = true;
    } catch (e) {
      debugPrint('award attempt failed: $e');
    }
  }

  Future<void> _awardCorrect() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      await FirebaseFirestore.instance.collection(usersCollection).doc(user.uid).set({
        'totalPoints': FieldValue.increment(3),
        'endDate': Timestamp.now(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('award correct failed: $e');
    }
  }

  Future<void> _awardCompletionBonus({required int correctCount, required int totalQuestions}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      await FirebaseFirestore.instance.collection(usersCollection).doc(user.uid).set({
        'totalPoints': FieldValue.increment(5),
        'endDate': Timestamp.now(),
      }, SetOptions(merge: true));
      await FirebaseFirestore.instance.collection(usersCollection).doc(user.uid).collection('quizHistory').add({
        'sessionType': 'global', // No audioId, use global
        'timestamp': FieldValue.serverTimestamp(),
        'totalQuestions': totalQuestions,
        'correct': correctCount,
        'note': 'Took a quiz ($totalQuestions questions, $correctCount correct)',
      });
    } catch (e) {
      debugPrint('award completion failed: $e');
    }
  }

  // ========================= START QUIZ =========================

  var isLoading = false.obs;
  void setLoading(bool value) => isLoading.value = value;

  Future<void> startQuiz(BuildContext context) async {
    // Do NOT generate or fetch anything here. Only load from local storage.
    Loader.show(context);
    try {
      final loaded = _quizStorage.loadSession(); // Use global session
      if (loaded != null && !loaded.completed) {
        _session = loaded;
        quizQuestions = loaded.questions;
        currentQuestionIndex.value = loaded.currentIndex;
        currentPage.value = loaded.currentIndex;
        currentValue = loaded.currentIndex + 1;
        _selectedAnswers
          ..clear()
          ..addAll(loaded.selectedAnswers);
        answerAttempts.assignAll(loaded.attempts);
        lockedIndices
          ..clear()
          ..addAll(loaded.lockedIndices);
        audioUrls.clear();
        for (int i = 0; i < quizQuestions!.length; i++) {
          final rel = quizQuestions![i].audioFile;
          audioUrls[i] = rel.isNotEmpty ? "$awsFilesUrl$rel" : rel;
        }
        // Set maxValue to total number of questions
        maxValue = quizQuestions!.length;

        Loader.hide(context);
        return;
      }
      // If not found, show error and return
      Loader.hide(context);
      Get.snackbar('Quiz Error', 'No quiz session found. Please return to Home.');
      return;
    } catch (e, stackTrace) {
      debugPrint("Error: $e");
      debugPrint("StackTrace: $stackTrace");
    } finally {
      Loader.hide(context);
      update();
    }
  }

  void _persistSession({bool completed = false}) {
    if (quizQuestions == null) return;
    _session = QuizSession(
      questions: quizQuestions!,
      currentIndex: currentQuestionIndex.value,
      selectedAnswers: Map<int, String>.from(_selectedAnswers),
      attempts: answerAttempts.toList(),
      completed: completed,
      lockedIndices: lockedIndices.toList(),
    );
    _quizStorage.saveSession(_session!);
  }

  // ========================= AUDIO =========================

  /// Preload audio and waveform for quiz questions.
  /// If onlyFirst is true, only preload the current question's audio for fast UI.
  /// If onlyFirst is false, preload all remaining audio in the background.
  Future<void> preloadAllAudio(int index, {bool onlyFirst = false}) async {
    if (quizQuestions == null || quizQuestions!.isEmpty) return;
    if (onlyFirst) {
      // Only prepare the current question's audio and waveform
      if (waveformControllers.length < quizQuestions!.length) {
        waveformControllers = List.generate(quizQuestions!.length, (_) => PlayerController());
      }
      final audioFileUrl = audioUrls[index];
      if (audioFileUrl != null && audioFileUrl.isNotEmpty) {
        await _prepareAudio(index, audioFileUrl);
        await waveformControllers[index].preparePlayer(
          path: localPaths[index]!,
          shouldExtractWaveform: true,
          volume: 1.0,
          noOfSamples: 200,
        );
      }
      update();
      return;
    }
    for (int i = 0; i < quizQuestions!.length; i++) {
      if (i == index) continue; // Skip the already loaded one
      final audioFileUrl = audioUrls[i];
      if (audioFileUrl == null || audioFileUrl.isEmpty) continue;
      // Prepare audio and waveform in the background
      _prepareAudio(i, audioFileUrl).then((_) async {
        await waveformControllers[i].preparePlayer(path: localPaths[i]!, shouldExtractWaveform: true, volume: 1.0, noOfSamples: 200);
        update();
      });
    }
  }

  Future<void> _prepareAudio(int index, String audioFileUrl) async {
    final uri = Uri.parse(audioFileUrl);
    final safeFilename = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : "audio_$index.mp3";
    final localPath = await downloadAudio(audioFileUrl, safeFilename);
    audioUrls[index] = audioFileUrl;
    localPaths[index] = localPath;
  }

  Future<String> downloadAudio(String url, String filename) async {
    final dio = Dio();
    final dir = await getApplicationDocumentsDirectory();
    String safeName = filename.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    if (safeName.endsWith(".mpeg")) safeName = safeName.replaceAll(".mpeg", ".mp3");
    final savePath = "${dir.path}/$safeName";
    await dio.download(url, savePath);
    return savePath;
  }

  /// Play audio at index, but only if the file exists locally. If not, show a message and do not block UI.
  Future<void> playAudioAtIndex(int index) async {
    try {
      currentPage.value = index;
      isAudioLoading.value = true;
      update();

      if (waveformControllers.length < quizQuestions!.length) {
        waveformControllers = List.generate(quizQuestions!.length, (_) => PlayerController());
      }

      if (isPlaying) {
        await audioPlayer.stop();
        await waveformControllers[index].stopPlayer();
        isPlaying = false;
      }

      final audioFileUrl = audioUrls[index];
      if (audioFileUrl == null || audioFileUrl.isEmpty) {
        isAudioLoading.value = false;
        return;
      }

      final uri = Uri.parse(audioFileUrl);
      final safeFilename = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : "audio_$index.mp3";
      final dir = await getApplicationDocumentsDirectory();
      String safeName = safeFilename.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
      if (safeName.endsWith(".mpeg")) safeName = safeName.replaceAll(".mpeg", ".mp3");
      final localPath = "${dir.path}/$safeName";

      final file = File(localPath);
      if (!file.existsSync()) {
        await downloadAudio(audioFileUrl, safeName);
      }
      localPaths[index] = localPath;
      _audioFilePath = localPath;

      await audioPlayer.setFilePath(localPath);
      await waveformControllers[index].preparePlayer(path: localPath, shouldExtractWaveform: true, noOfSamples: 200, volume: 1.0);

      await audioPlayer.seek(Duration.zero);
      await waveformControllers[index].seekTo(0);
      // await waveformControllers[index].startPlayer();

      isReady = true;
      isPlaying = true;
      isAudioLoading.value = false;
      update();
    } catch (e) {
      debugPrint("playAudioAtIndex error: $e");
      isAudioLoading.value = false;
      isPlaying = false;
      isReady = false;
      update();
    }
  }

  // ========================= Remaining audio controls =========================
  DateTime? _lastWaveUpdate;
  // void listenAudioStreams() {
  //   audioPlayer.positionStream.listen((pos) {
  //     position = pos;
  //     if (isReady && waveformControllers.isNotEmpty && currentQuestionIndex.value < waveformControllers.length) {
  //       // Let waveform FOLLOW audioPlayer
  //       waveformControllers[currentQuestionIndex.value].seekTo(pos.inMilliseconds);
  //     }
  //     update();
  //   });
  //
  //   audioPlayer.durationStream.listen((dur) {
  //     if (dur != null) {
  //       duration = dur;
  //       update();
  //     }
  //   });
  //
  //   audioPlayer.playerStateStream.listen((state) async {
  //     if (state.processingState == ja.ProcessingState.completed) {
  //       final index = currentQuestionIndex.value;
  //       await waveformControllers[index].seekTo(0);
  //       await waveformControllers[index].stopPlayer();
  //       isPlaying = false;
  //       update();
  //     }
  //   });
  // }
  void listenAudioStreams() {
    audioPlayer.positionStream.listen((pos) {
      position = pos;

      if (isReady && waveformControllers.isNotEmpty && currentQuestionIndex.value < waveformControllers.length) {
        final now = DateTime.now();

        if (_lastWaveUpdate == null || now.difference(_lastWaveUpdate!).inMilliseconds > 100) {
          waveformControllers[currentQuestionIndex.value].seekTo(pos.inMilliseconds);
          _lastWaveUpdate = now;
        }
      }

      update();
    });

    audioPlayer.durationStream.listen((dur) {
      if (dur != null) {
        duration = dur;
        update();
      }
    });

    audioPlayer.playerStateStream.listen((state) async {
      if (state.processingState == ja.ProcessingState.completed) {
        final index = currentQuestionIndex.value;
        await waveformControllers[index].seekTo(0);
        await waveformControllers[index].stopPlayer();
        isPlaying = false;
        update();
      }
    });
  }

  Future<void> togglePlayPause() async {
    try {
      if (_audioFilePath == null || !isReady) {
        debugPrint("togglePlayPause: No audio file ready");
        return;
      }

      final state = audioPlayer.playerState;
      final playing = state.playing;
      final completed = state.processingState == ja.ProcessingState.completed;
      final index = currentQuestionIndex.value;

      debugPrint("togglePlayPause: index=$index, playing=$playing, completed=$completed");

      if (completed) {
        // Restart
        await audioPlayer.seek(Duration.zero);
        await waveformControllers[index].seekTo(0);
        await waveformControllers[index].preparePlayer(
          path: localPaths[index]!,
          shouldExtractWaveform: true,
          volume: 1.0,
          noOfSamples: 200,
        );
        await waveformControllers[index].startPlayer();
        await audioPlayer.play();
        isPlaying = true;
      } else if (playing) {
        // Pause
        await audioPlayer.pause();
        await waveformControllers[index].pausePlayer();
        isPlaying = false;
      } else {
        // Resume
        await audioPlayer.play();
        await waveformControllers[index].startPlayer();
        isPlaying = true;
      }

      update();
    } catch (e, st) {
      debugPrint("togglePlayPause error: $e");
      debugPrint("StackTrace: $st");
    }
  }

  Future<void> skipForward() async {
    final pos = audioPlayer.position;
    final newPos = pos + const Duration(seconds: 5);
    await audioPlayer.seek(newPos);
    await waveformControllers[currentQuestionIndex.value].seekTo(newPos.inMilliseconds);
  }

  Future<void> skipBackward() async {
    final pos = audioPlayer.position;
    final newPos = pos - const Duration(seconds: 5);
    final validPos = newPos < Duration.zero ? Duration.zero : newPos;
    await audioPlayer.seek(validPos);
    await waveformControllers[currentQuestionIndex.value].seekTo(validPos.inMilliseconds);
  }

  Future<void> toggleMute() async {
    isMuted = !isMuted;
    await audioPlayer.setVolume(isMuted ? 0.0 : 1.0);
    update();
  }

  Future<void> toggleRepeat() async {
    await audioPlayer.seek(Duration.zero);
    await waveformControllers[currentQuestionIndex.value].seekTo(0);
    update();
  }

  String formatDuration(Duration d) {
    twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds % 60)}';
  }

  QuizSession? globalSession;
  bool sessionLoading = true;

  Future<void> generateGlobalQuizSession() async {
    print("🚀 Starting generateGlobalQuizSession...");

    final futures = await Future.wait([
      FirebaseFirestore.instance.collection(adminCategoryAudio).get(),
      FirebaseFirestore.instance.collection(adminSubcategory).get(),
    ]);

    final audioSnapshot = futures[0];
    final subCatSnapshot = futures[1];

    print("📂 Audio Docs Fetched: ${audioSnapshot.docs.length}");
    print("📂 SubCategory Docs Fetched: ${subCatSnapshot.docs.length}");

    List<AudioData> audioListRaw = [];
    for (var doc in audioSnapshot.docs) {
      final data = doc.data();
      print("📑 Audio Doc: ${doc.id} => $data");

      if (data['audioData'] != null && data['audioData'] is List) {
        final parsedList = (data['audioData'] as List)
            .map((item) {
          final audioMap = Map<String, dynamic>.from(item);
          // merge parent sub_category into each audio item
          audioMap['sub_category'] = data['sub_category'] ?? '';
          return AudioData.fromMap(audioMap);
        })
            .toList();

        print("🎵 Parsed AudioData from ${doc.id}: ${parsedList.length} items");
        for (var audio in parsedList) {
          print("   ▶ ${audio.toString()}");
        }

        audioListRaw.addAll(parsedList); // ✅ only AudioData objects
      }
    }


    final subCatList = subCatSnapshot.docs
        .map((doc) {
      print("📑 SubCategory Doc: ${doc.id} => ${doc.data()}");
      return SubCategory.fromMap(doc.data());
    })
        .toList();

    print("✅ SubCategory List created: ${subCatList.length}");

    final audioList = audioListRaw.where((audio) => audio.audioFile.isNotEmpty).toList();
    print("🎧 Filtered Audio List: ${audioList.length} valid items");

    if (audioList.isEmpty) {
      print("⚠️ No valid audio found. Exiting...");
      return;
    }
   
    final quizQuestions = generateQuizQuestions(audioList, subCatList);
    print("❓ Quiz Questions Generated: ${quizQuestions.length}");

    for (var q in quizQuestions) {
      print("   ➡ Question: ${q.toString()}");
    }

    final session = QuizSession(
      questions: quizQuestions,
      currentIndex: 0,
      selectedAnswers: {},
      attempts: [],
      completed: false,
      lockedIndices: [],
    );

    print("📝 QuizSession Created: ${session.toString()}");

    await _quizStorage.saveSession(session);
    print("💾 QuizSession Saved Successfully!");
  }

}
