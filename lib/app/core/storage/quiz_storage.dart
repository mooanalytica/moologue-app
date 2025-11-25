import 'package:get_storage/get_storage.dart';
import 'package:moo_logue/app/model/quiz_model.dart';
import 'package:moo_logue/app/utils/quiz_generate_screen.dart';

class QuizSession {
  // Remove audioId as a unique identifier for sessions
  final List<QuizQuestion> questions;
  final int currentIndex;
  final Map<int, String> selectedAnswers;
  final List<AnswerAttempt> attempts;
  final bool completed;
  final List<int> lockedIndices; // indices where answer can no longer be edited

  QuizSession({
    required this.questions,
    required this.currentIndex,
    required this.selectedAnswers,
    required this.attempts,
    required this.completed,
    required this.lockedIndices,
  });

  QuizSession copyWith({
    List<QuizQuestion>? questions,
    int? currentIndex,
    Map<int, String>? selectedAnswers,
    List<AnswerAttempt>? attempts,
    bool? completed,
    List<int>? lockedIndices,
  }) {
    return QuizSession(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      attempts: attempts ?? this.attempts,
      completed: completed ?? this.completed,
      lockedIndices: lockedIndices ?? this.lockedIndices,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questions': questions.map((q) => q.toJson()).toList(),
      'currentIndex': currentIndex,
      'selectedAnswers': selectedAnswers.map(
        (k, v) => MapEntry(k.toString(), v),
      ),
      'attempts': attempts.map((a) => a.toJson()).toList(),
      'completed': completed,
      'lockedIndices': lockedIndices,
    };
  }

  factory QuizSession.fromJson(Map<String, dynamic> json) {
    final rawSelected = (json['selectedAnswers'] as Map?) ?? {};
    final convertedSelected = <int, String>{};
    rawSelected.forEach((key, value) {
      final idx = int.tryParse(key.toString());
      if (idx != null) convertedSelected[idx] = value?.toString() ?? '';
    });

    return QuizSession(
      questions: (json['questions'] as List<dynamic>? ?? const [])
          .map((e) => QuizQuestion.fromJson((e as Map).cast<String, dynamic>()))
          .toList(),
      currentIndex: json['currentIndex'] is int
          ? json['currentIndex'] as int
          : int.tryParse('${json['currentIndex']}') ?? 0,
      selectedAnswers: convertedSelected,
      attempts: (json['attempts'] as List<dynamic>? ?? const [])
          .map(
            (e) => AnswerAttempt.fromJson((e as Map).cast<String, dynamic>()),
          )
          .toList(),
      completed: (json['completed'] is bool)
          ? json['completed'] as bool
          : json['completed'].toString() == 'true',
      lockedIndices: (json['lockedIndices'] as List<dynamic>? ?? const [])
          .map((e) => int.tryParse(e.toString()) ?? -1)
          .where((e) => e >= 0)
          .toList(),
    );
  }
}

class QuizStorage {
  final GetStorage _box = GetStorage();
  static const String _globalKey = 'quiz_session_global';

  Future<void> saveSession(QuizSession session) async {
    await _box.write(_globalKey, session.toJson());
  }

  QuizSession? loadSession() {
    final data = _box.read<Map<String, dynamic>>(_globalKey);
    if (data == null) return null;
    return QuizSession.fromJson(data);
  }

  Future<void> clearSession() async {
    await _box.remove(_globalKey);
  }
}
