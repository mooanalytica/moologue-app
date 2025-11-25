import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:path_provider/path_provider.dart';

class FenceInteractionCallController extends GetxController {
  final ja.AudioPlayer audioPlayer = ja.AudioPlayer();
  PlayerController? waveformController;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  bool isRepeating = false;
  bool isMuted = false;
  bool isPlaying = false;
  bool isReady = false;

  String? _audioFilePath;

  RxList<String> fenceCallList = [AppString.excitement, AppString.socialization, AppString.confidence].obs;

  @override
  void onInit() {
    super.onInit();
  }

  void listenAudioStreams() {
    audioPlayer.positionStream.listen((pos) {
      position = pos;
      if (isReady) {
        waveformController?.seekTo(pos.inMilliseconds);
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
        if (isRepeating) {
          await audioPlayer.seek(Duration.zero);
          await audioPlayer.play();
          await waveformController?.seekTo(0);
          await waveformController?.startPlayer(forceRefresh: true);
        } else {
          await waveformController?.seekTo(0);
          await waveformController?.pausePlayer();
          isPlaying = false;
          update();
        }
      }
    });
  }

  Future<void> setup(String? audioFileUrl) async {
    debugPrint('audioFileUrl==========>>>>>$audioFileUrl');
    try {
      isReady = false;
      update();
      waveformController?.dispose();
      waveformController = PlayerController();
      update();
      if (audioFileUrl == null) throw Exception("Audio URL is null");

      final uri = Uri.parse(audioFileUrl);
      final safeFilename = uri.pathSegments.last;
      final localPath = await downloadAudio(audioFileUrl, safeFilename);

      _audioFilePath = localPath;

      await waveformController?.preparePlayer(
        path: _audioFilePath!,
        shouldExtractWaveform: true,
        noOfSamples: 200,
        volume: 1.0,
      );
      update();
      await waveformController?.seekTo(0);

      // just_audio setup
      await audioPlayer.setFilePath(_audioFilePath!);
      update();
      isReady = true;
      update();
    } catch (e) {
      debugPrint('Error preparing player: $e');
    }
  }

  Future<String> downloadAudio(String url, String filename) async {
    final dio = Dio();
    final dir = await getApplicationDocumentsDirectory();

    // Sanitize filename (remove spaces and special chars)
    String safeName = filename.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');

    // Force .mp3 extension if .mpeg comes
    if (safeName.endsWith(".mpeg")) {
      safeName = safeName.replaceAll(".mpeg", ".mp3");
    }

    final savePath = "${dir.path}/$safeName";

    await dio.download(url, savePath);
    return savePath;
  }

  Future<void> togglePlayPause() async {
    final state = audioPlayer.playerState;
    final playing = state.playing;
    final completed = state.processingState == ja.ProcessingState.completed;
    log('playing==========>>>>>${playing}');

    if (completed) {
      await audioPlayer.seek(Duration.zero);
      await waveformController?.stopPlayer();
      await waveformController?.seekTo(0);
      await waveformController?.preparePlayer(path: _audioFilePath!, shouldExtractWaveform: false);

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await waveformController?.startPlayer();
      });

      await audioPlayer.play();
      update();
    } else if (playing) {
      await audioPlayer.pause();
      await waveformController?.pausePlayer();
      update();
    } else {
      log('enter==========>>>>>}');

      await audioPlayer.play();
      await waveformController?.startPlayer();
      update();
    }

    isPlaying = !playing || completed;
    update();
  }

  Future<void> skipForward() async {
    await waveformController?.pausePlayer();
    final position = await audioPlayer.position;
    final newPos = position + const Duration(seconds: 5);
    await audioPlayer.seek(newPos);
    await waveformController?.seekTo(newPos.inMilliseconds);
  }

  Future<void> skipBackward() async {
    await waveformController?.pausePlayer();
    final position = await audioPlayer.position;
    final newPos = position - const Duration(seconds: 5);
    final validPos = newPos < Duration.zero ? Duration.zero : newPos;
    await audioPlayer.seek(validPos);
    await waveformController?.seekTo(validPos.inMilliseconds);
  }

  Future<void> toggleMute() async {
    isMuted = !isMuted;
    await audioPlayer.setVolume(isMuted ? 0.0 : 1.0);
    update();
  }

  Future<void> toggleRepeat() async {
    if (_audioFilePath == null) return;

    await audioPlayer.seek(Duration.zero);
    await audioPlayer.play();

    await waveformController?.stopPlayer();
    await waveformController?.seekTo(0);
    await waveformController?.preparePlayer(path: _audioFilePath!, shouldExtractWaveform: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await waveformController?.startPlayer();
      isPlaying = true;
      update();
    });
  }

  String formatDuration(Duration d) {
    twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds % 60)}';
  }

  @override
  void onClose() {
    try {
      audioPlayer.stop();
      audioPlayer.dispose();
      waveformController?.dispose();
      waveformController = null;
    } catch (e) {
      debugPrint("Error disposing audio resources: $e");
    }
    super.onClose();
  }
}
