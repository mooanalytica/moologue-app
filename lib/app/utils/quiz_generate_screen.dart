// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:moo_logue/app/model/quiz_model.dart';
//
// class QuizQuestion {
//   final String audioFile;
//   final String correctMainCategory;
//   final String correctSubCategory;
//   final List<String> mainCategoryOptions;
//   final List<String> subCategoryOptions;
//
//   QuizQuestion({
//     required this.audioFile,
//     required this.correctMainCategory,
//     required this.correctSubCategory,
//     required this.mainCategoryOptions,
//     required this.subCategoryOptions,
//   });
//
//   Map<String, dynamic> toJson() {
//     return {
//       'audioFile': audioFile,
//       'correctMainCategory': correctMainCategory,
//       'correctSubCategory': correctSubCategory,
//       'mainCategoryOptions': mainCategoryOptions,
//       'subCategoryOptions': subCategoryOptions,
//     };
//   }
//
//   factory QuizQuestion.fromJson(Map<String, dynamic> json) {
//     return QuizQuestion(
//       audioFile: json['audioFile'] ?? '',
//       correctMainCategory: json['correctMainCategory'] ?? '',
//       correctSubCategory: json['correctSubCategory'] ?? '',
//       mainCategoryOptions: (json['mainCategoryOptions'] as List<dynamic>? ?? const []).map((e) => e?.toString() ?? '').toList(),
//       subCategoryOptions: (json['subCategoryOptions'] as List<dynamic>? ?? const []).map((e) => e?.toString() ?? '').toList(),
//     );
//   }
// }
//
// // List<QuizQuestion> generateQuizQuestions(List<AudioData> audioData, List<SubCategory> subCatList) {
// //   final random = Random();
// //   audioData.shuffle();
// //
// //   final allMainCats = audioData.map((e) => e.audioTitle.trim()).where((title) => title.isNotEmpty).toSet().toList();
// //
// //   final allSubCats = subCatList.map((e) => e.subCategory.trim()).where((sub) => sub.isNotEmpty).toSet().toList();
// //
// //   debugPrint('Total main categories: ${allMainCats.length}');
// //   debugPrint('Total sub categories: ${allSubCats.length}');
// //
// //   final List<QuizQuestion> questions = [];
// //
// //   for (int i = 0; i < audioData.length; i++) {
// //     final audio = audioData[i];
// //
// //     final hasMain = audio.audioTitle.trim().isNotEmpty;
// //     final hasSub = allSubCats.isNotEmpty;
// //
// //     if (!hasMain && !hasSub) {
// //       debugPrint('Skipping audio with no main/sub available: ${audio.audioFile}');
// //       continue;
// //     }
// //
// //     // Randomly pick question type (main or sub) if both available
// //     final isMainQuestion = (hasMain && hasSub) ? random.nextBool() : hasMain;
// //
// //     List<String> options = [];
// //     if (isMainQuestion && hasMain) {
// //       // Main category question
// //       options = _buildOptions(audio.audioTitle, allMainCats, allSubCats, 5);
// //     } else if (!isMainQuestion && hasSub) {
// //       // Subcategory question
// //       // Pick a random subcategory if audio.subCategory is empty
// //       final subCategory = audio.subCategory.trim().isNotEmpty ? audio.subCategory : allSubCats[random.nextInt(allSubCats.length)];
// //       options = _buildOptions(subCategory, allSubCats, allMainCats, 5);
// //     }
// //
// //     final question = QuizQuestion(
// //       audioFile: audio.audioFile,
// //       correctMainCategory: audio.audioTitle,
// //       correctSubCategory: audio.subCategory.isNotEmpty
// //           ? audio.subCategory
// //           : (isMainQuestion ? '' : options.first), // fallback correct answer for sub
// //       mainCategoryOptions: isMainQuestion ? options : [],
// //       subCategoryOptions: !isMainQuestion ? options : [],
// //     );
// //
// //     questions.add(question);
// //
// //     debugPrint('---------- Question ${i + 1} ----------');
// //     debugPrint('Audio file: ${audio.audioFile}');
// //     debugPrint('Is Main Question: $isMainQuestion');
// //     debugPrint('Correct Main Category: ${audio.audioTitle}');
// //     debugPrint('Correct Sub Category: ${question.correctSubCategory}');
// //     debugPrint('Options: $options');
// //     debugPrint('Total Questions so far: ${questions.length}');
// //   }
// //
// //   debugPrint('Final total questions generated: ${questions.length}');
// //   return questions;
// // }
// List<QuizQuestion> generateQuizQuestions(
//     List<AudioData> audioData, List<SubCategory> subCatList) {
//   final random = Random();
//   audioData.shuffle();
//
//   final allMainCats = audioData
//       .map((e) => e.audioTitle.trim())
//       .where((title) => title.isNotEmpty)
//       .toSet()
//       .toList();
//
//   final allSubCats = subCatList
//       .map((e) => e.subCategory.trim())
//       .where((sub) => sub.isNotEmpty)
//       .toSet()
//       .toList();
//
//   debugPrint('Total main categories: ${allMainCats.length}');
//   debugPrint('Total sub categories: ${allSubCats.length}');
//
//   final List<QuizQuestion> questions = [];
//   final Set<String> usedMainCats = {}; // 👈 track used main categories
//   final Set<String> usedSubCats = {};  // 👈 track used sub categories
//
//   for (int i = 0; i < audioData.length; i++) {
//     final audio = audioData[i];
//
//     final hasMain = audio.audioTitle.trim().isNotEmpty;
//     final hasSub = audio.subCategory.trim().isNotEmpty;
//
//     if (!hasMain && !hasSub) {
//       debugPrint('Skipping audio with no main/sub available: ${audio.audioFile}');
//       continue;
//     }
//
//     // Randomly pick question type (main or sub)
//     final isMainQuestion = (hasMain && hasSub) ? random.nextBool() : hasMain;
//
//     List<String> options = [];
//
//     if (isMainQuestion && hasMain) {
//       if (usedMainCats.contains(audio.audioTitle)) {
//         debugPrint('------------------------------Skipping duplicate main category:------------------------------ ${audio.audioTitle}');
//         continue; // 👈 skip if already used
//       }
//       options = _buildOptions(audio.audioTitle, allMainCats, allSubCats, 5);
//       usedMainCats.add(audio.audioTitle); // 👈 mark as used
//     } else if (!isMainQuestion && hasSub) {
//       if (usedSubCats.contains(audio.subCategory)) {
//         debugPrint('------------------------------Skipping duplicate subcategory: ------------------------------${audio.subCategory}');
//         continue; // 👈 skip if already used
//       }
//       options = _buildOptions(audio.subCategory, allSubCats, allMainCats, 5);
//       usedSubCats.add(audio.subCategory); // 👈 mark as used
//     }
//
//     final question = QuizQuestion(
//       audioFile: audio.audioFile,
//       correctMainCategory: audio.audioTitle,
//       correctSubCategory: audio.subCategory,
//       mainCategoryOptions: isMainQuestion ? options : [],
//       subCategoryOptions: !isMainQuestion ? options : [],
//     );
//
//     questions.add(question);
//
//     debugPrint('---------- Question ${i + 1} ----------');
//     debugPrint('Audio file: ${audio.audioFile}');
//     debugPrint('Is Main Question: $isMainQuestion');
//     debugPrint('Correct Main Category: ${audio.audioTitle}');
//     debugPrint('Correct Sub Category: ${question.correctSubCategory}');
//     debugPrint('Options: $options');
//     debugPrint('Total Questions so far: ${questions.length}');
//   }
//
//   debugPrint('Final total questions generated: ${questions.length}');
//   return questions;
// }
//
// List<String> _buildOptions(String correctAnswer, List<String> primaryPool, List<String> backupPool, int count) {
//   final random = Random();
//   final normalizedCorrect = correctAnswer.trim();
//
//   final primary = primaryPool
//       .map((e) => e.trim())
//       .where((e) => e.isNotEmpty && e.toLowerCase() != normalizedCorrect.toLowerCase())
//       .toSet()
//       .toList();
//   final backup = backupPool
//       .map((e) => e.trim())
//       .where((e) => e.isNotEmpty && e.toLowerCase() != normalizedCorrect.toLowerCase())
//       .toSet()
//       .toList();
//
//   primary.shuffle();
//   backup.shuffle();
//
//   final Set<String> result = {};
//
//   // Take from primary
//   for (final v in primary) {
//     if (result.length >= count - 1) break;
//     result.add(v);
//   }
//
//   // Fill from backup if needed
//   for (final v in backup) {
//     if (result.length >= count - 1) break;
//     result.add(v);
//   }
//
//   // Ensure correct answer included
//   if (normalizedCorrect.isNotEmpty) result.add(correctAnswer);
//
//   // Pad if still short
//   while (result.length < count) {
//     if (result.isNotEmpty) {
//       result.add(result.elementAt(random.nextInt(result.length)));
//     } else {
//       result.add(correctAnswer.isNotEmpty ? correctAnswer : '');
//     }
//   }
//
//   // Convert to list and shuffle
//   final finalList = result.toList()..shuffle();
//   return finalList.take(count).toList();
// }
//
// // List<QuizQuestion> generateQuizQuestions(List<AudioData> audioData, List<SubCategory> subCatList) {
// //   final random = Random();
// //   audioData.shuffle();
// //
// //   final allMainCats = audioData.map((e) => e.audioTitle.trim()).where((title) => title.isNotEmpty).toSet().toList();
// //
// //   final allSubCats = subCatList.map((e) => e.subCategory.trim()).where((sub) => sub.isNotEmpty).toSet().toList();
// //
// //   debugPrint('Total main categories: ${allMainCats.length}');
// //   debugPrint('Total sub categories: ${allSubCats.length}');
// //
// //   final List<QuizQuestion> questions = [];
// //
// //   for (int i = 0; i < 10 && i < audioData.length; i++) {
// //     final audio = audioData[i];
// //
// //     final hasMain = audio.audioTitle.trim().isNotEmpty;
// //     final hasSub = audio.subCategory.trim().isNotEmpty;
// //
// //     // Decide the type only among available correct answers
// //     late final bool isMainQuestion;
// //     if (hasMain && hasSub) {
// //       isMainQuestion = random.nextBool();
// //     } else if (hasMain) {
// //       isMainQuestion = true;
// //     } else if (hasSub) {
// //       isMainQuestion = false;
// //     } else {
// //       debugPrint('Skipping audio with no main/sub: ${audio.audioFile}');
// //       continue;
// //     }
// //
// //     final mainOptions = isMainQuestion ? _buildOptions(audio.audioTitle, allMainCats, allSubCats, 5) : <String>[];
// //
// //     final subOptions = !isMainQuestion ? _buildOptions(audio.subCategory, allSubCats, allMainCats, 5) : <String>[];
// //
// //     final question = QuizQuestion(
// //       audioFile: audio.audioFile,
// //       correctMainCategory: audio.audioTitle,
// //       correctSubCategory: audio.subCategory,
// //       mainCategoryOptions: mainOptions,
// //       subCategoryOptions: subOptions,
// //     );
// //
// //     questions.add(question);
// //
// //     debugPrint('---------- Question ${i + 1} ----------');
// //     debugPrint('Audio file: ${audio.audioFile}');
// //     debugPrint('Is Main Question: $isMainQuestion');
// //     debugPrint('Correct Main Category: ${audio.audioTitle}');
// //     debugPrint('Correct Sub Category: ${audio.subCategory}');
// //     debugPrint('Main Options: $mainOptions');
// //     debugPrint('Sub Options: $subOptions');
// //     debugPrint('Total Questions so far: ${questions.length}');
// //   }
// //
// //   debugPrint('Final total questions generated: ${questions.length}');
// //   return questions;
// // }
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:moo_logue/app/model/quiz_model.dart';

class QuizQuestion {
  final String audioFile;
  final String correctMainCategory;
  final String correctSubCategory;
  final List<String> mainCategoryOptions;
  final List<String> subCategoryOptions;

  QuizQuestion({
    required this.audioFile,
    required this.correctMainCategory,
    required this.correctSubCategory,
    required this.mainCategoryOptions,
    required this.subCategoryOptions,
  });

  Map<String, dynamic> toJson() {
    return {
      'audioFile': audioFile,
      'correctMainCategory': correctMainCategory,
      'correctSubCategory': correctSubCategory,
      'mainCategoryOptions': mainCategoryOptions,
      'subCategoryOptions': subCategoryOptions,
    };
  }

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      audioFile: json['audioFile'] ?? '',
      correctMainCategory: json['correctMainCategory'] ?? '',
      correctSubCategory: json['correctSubCategory'] ?? '',
      mainCategoryOptions: (json['mainCategoryOptions'] as List<dynamic>? ?? const [])
          .map((e) => e?.toString() ?? '')
          .toList(),
      subCategoryOptions: (json['subCategoryOptions'] as List<dynamic>? ?? const [])
          .map((e) => e?.toString() ?? '')
          .toList(),
    );
  }
}

List<QuizQuestion> generateQuizQuestions(List<AudioData> audioData, List<SubCategory> subCatList) {
  final random = Random();
  audioData.shuffle();

  // Mapping of option -> subcategory
  final Map<String, String> optionToSubCat = {};
  for (var audio in audioData) {
    optionToSubCat[audio.audioTitle] = audio.subCategory;
  }

  final allMainCats = audioData.map((e) => e.audioTitle.trim()).where((title) => title.isNotEmpty).toList();
  final allSubCats = subCatList.map((e) => e.subCategory.trim()).where((sub) => sub.isNotEmpty).toList();

  debugPrint('Total main categories: ${allMainCats.length}');
  debugPrint('Total sub categories: ${allSubCats.length}');

  final List<QuizQuestion> questions = [];

  for (int i = 0; i < audioData.length; i++) {
    final audio = audioData[i];
    final hasMain = audio.audioTitle.trim().isNotEmpty;
    final hasSub = audio.subCategory.trim().isNotEmpty;

    if (!hasMain && !hasSub) {
      debugPrint('Skipping audio with no main/sub: ${audio.audioFile}');
      continue;
    }

    // Randomly decide question type
    final isMainQuestion = (hasMain && hasSub) ? random.nextBool() : hasMain;

    // Build options with unique subcategories
    List<String> options = isMainQuestion
        ? buildUniqueSubCategoryOptions(audio.audioTitle, allMainCats, optionToSubCat, 5)
        : buildUniqueSubCategoryOptions(audio.subCategory, allMainCats, optionToSubCat, 5);

    final question = QuizQuestion(
      audioFile: audio.audioFile,
      correctMainCategory: audio.audioTitle,
      correctSubCategory: audio.subCategory,
      mainCategoryOptions: isMainQuestion ? options : [],
      subCategoryOptions: !isMainQuestion ? options : [],
    );

    questions.add(question);

    debugPrint('---------- Question ${i + 1} ----------');
    debugPrint('Audio file: ${audio.audioFile}');
    debugPrint('Is Main Question: $isMainQuestion');
    debugPrint('Correct Main Category: ${audio.audioTitle}');
    debugPrint('Correct Sub Category: ${audio.subCategory}');
    debugPrint('Options: $options');
    debugPrint('Total Questions so far: ${questions.length}');
  }

  debugPrint('Final total questions generated: ${questions.length}');
  return questions;
}

/// Build options ensuring no two options share the same subcategory
List<String> buildUniqueSubCategoryOptions(
    String correctAnswer, List<String> allOptions, Map<String, String> optionToSubCat, int totalOptions) {
  final random = Random();
  final result = <String>{correctAnswer};

  // Get subcategory for correctAnswer, or fallback empty string
  final correctSubCat = optionToSubCat[correctAnswer] ?? '';
  final usedSubCats = <String>{};
  if (correctSubCat.isNotEmpty) usedSubCats.add(correctSubCat);

  final shuffledOptions = allOptions.toList()..shuffle();

  for (var option in shuffledOptions) {
    if (result.length >= totalOptions) break;
    if (option == correctAnswer) continue;

    final subCat = optionToSubCat[option] ?? '';
    if (subCat.isNotEmpty && !usedSubCats.contains(subCat)) {
      result.add(option);
      usedSubCats.add(subCat);
      debugPrint('Added option $option with unique subcategory $subCat');
    }
  }

  // If still not enough, fill with any remaining options
  for (var option in shuffledOptions) {
    if (result.length >= totalOptions) break;
    if (!result.contains(option)) {
      result.add(option);
      debugPrint('Added extra option $option (duplicate subcategory allowed)');
    }
  }

  final finalList = result.toList()..shuffle();
  return finalList.take(totalOptions).toList();
}
