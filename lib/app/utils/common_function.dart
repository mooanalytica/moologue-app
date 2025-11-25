import 'package:cloud_firestore/cloud_firestore.dart';

String formatString(String input, {bool capitalizeWords = true}) {
  String result = input.replaceAll('_', ' ');

  if (capitalizeWords) {
    result = result
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }

  return result;
}

String capitalizeFirstLetter(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}
dynamic convertTimestamps(dynamic data) {
  if (data is Map) {
    return data.map((key, value) => MapEntry(key, convertTimestamps(value)));
  } else if (data is List) {
    return data.map(convertTimestamps).toList();
  } else if (data is Timestamp) {
    return data.toDate().toIso8601String();
  } else {
    return data;
  }
}

String removeTimeMarkers(String input) {

  final regex = RegExp(r'\d+h|\d+m|\d+s');
  return input.replaceAll(regex, '').trim();
}
