// audio_data.dart
class AudioData {
  final String audioFile;
  final String audioTitle;
  final String subCategory;

  AudioData({
    required this.audioFile,
    required this.audioTitle,
    required this.subCategory,
  });

  factory AudioData.fromMap(Map<String, dynamic> data) {
    return AudioData(
      audioFile: data['audioFile'] ?? '',
      audioTitle: data['audioTitle'] ?? '',
      subCategory: data['sub_category'] ?? '',
    );
  }
}

class SubCategory {
  final String subCategory;

  SubCategory({required this.subCategory});

  factory SubCategory.fromMap(Map<String, dynamic> data) {
    return SubCategory(
      subCategory: data['sub_category'] ?? '',
    );
  }
}
class AnswerAttempt {
  final String question;
  final String selectedAnswer;
  final String correctAnswer;
  final bool isCorrect;

  AnswerAttempt({
    required this.question,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.isCorrect,
  });

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'selectedAnswer': selectedAnswer,
      'correctAnswer': correctAnswer,
      'isCorrect': isCorrect,
    };
  }

  factory AnswerAttempt.fromJson(Map<String, dynamic> json) {
    return AnswerAttempt(
      question: json['question'] ?? '',
      selectedAnswer: json['selectedAnswer'] ?? '',
      correctAnswer: json['correctAnswer'] ?? '',
      isCorrect: (json['isCorrect'] is bool) ? json['isCorrect'] as bool : json['isCorrect'].toString() == 'true',
    );
  }
}
