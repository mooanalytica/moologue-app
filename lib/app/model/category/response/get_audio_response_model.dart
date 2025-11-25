import 'package:cloud_firestore/cloud_firestore.dart';

class AudioDataResponseModel {
  final String? audioTitle;
  final String? audioDesc;
  final String? audioFile;
  final String? audioImage;
  final String? callDuration; // keep String, but convert safely
  final num? confident;       // can be int or double
  final String? emotion;
  final String? audioId;

  AudioDataResponseModel({
    this.audioTitle,
    this.audioDesc,
    this.audioFile,
    this.audioImage,
    this.callDuration,
    this.confident,
    this.emotion,
    this.audioId,
  });

  /// JSON -> Model
  factory AudioDataResponseModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AudioDataResponseModel();
    return AudioDataResponseModel(
      audioTitle: json['audioTitle'] as String?,
      audioDesc: json['audioDesc'] as String?,
      audioId: json['audioId'] as String?,
      audioFile: json['audioFile'] as String?,
      audioImage: json['audioImage'] as String?,
      callDuration: json['callDuration']?.toString(),   // 🔹 safe conversion
      confident: (json['confident'] is int || json['confident'] is double)
          ? json['confident'] as num
          : num.tryParse(json['confident']?.toString() ?? ""),
      emotion: json['emotion']?.toString(),
    );
  }

  /// Model -> JSON
  Map<String, dynamic> toJson() {
    return {
      if (audioTitle != null) 'audioTitle': audioTitle,
      if (audioDesc != null) 'audioDesc': audioDesc,
      if (audioId != null) 'audioId': audioId,
      if (audioFile != null) 'audioFile': audioFile,
      if (audioImage != null) 'audioImage': audioImage,
      if (callDuration != null) 'callDuration': callDuration,
      if (confident != null) 'confident': confident,
      if (emotion != null) 'emotion': emotion,
    };
  }
}


class MaternalCall {
  final String? docId;
  final String? folderName;
  final String? mainCategory;
  final String? subCategory;
  final String? description;
  final dynamic emotion;
  final dynamic callDuration;
  final dynamic confident;
  final List<AudioDataResponseModel>? audioData;
  final DateTime? createdDate;
  final DateTime? updatedDate;

  MaternalCall({
    this.docId,
    this.folderName,
    this.mainCategory,
    this.subCategory,
    this.description,
    this.emotion,
    this.callDuration,
    this.confident,
    this.audioData,
    this.createdDate,
    this.updatedDate,
  });

  /// Firestore Document -> Model
  factory MaternalCall.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return MaternalCall.fromJson({...data, 'docId': doc.id});
  }

  /// JSON -> Model
  factory MaternalCall.fromJson(Map<String, dynamic>? json) {
    if (json == null) return MaternalCall();
    return MaternalCall(
      docId: json['docId'] as String?,
      folderName: json['folderName'] as String?,
      mainCategory: json['main_category'] as String?,
      subCategory: json['sub_category'] as String?,
      description: json['description'] as String?,
      emotion: json['emotion'],
      callDuration: json['callDuration'],
      confident: json['confident'],
      createdDate: (json['createdDate'] is Timestamp)
          ? (json['createdDate'] as Timestamp).toDate()
          : null,
      updatedDate: (json['updatedDate'] is Timestamp)
          ? (json['updatedDate'] as Timestamp).toDate()
          : null,
      audioData: (json['audioData'] as List<dynamic>?)
          ?.map((e) => AudioDataResponseModel.fromJson(e as Map<String, dynamic>?))
          .toList(),
    );
  }

  /// Model -> JSON
  Map<String, dynamic> toJson() {
    return {
      if (docId != null) 'docId': docId,
      if (folderName != null) 'folderName': folderName,
      if (mainCategory != null) 'main_category': mainCategory,
      if (subCategory != null) 'sub_category': subCategory,
      if (description != null) 'description': description,
      if (emotion != null) 'emotion': emotion,
      if (callDuration != null) 'callDuration': callDuration,
      if (confident != null) 'confident': confident,
      if (createdDate != null) 'createdDate': Timestamp.fromDate(createdDate!),
      if (updatedDate != null) 'updatedDate': Timestamp.fromDate(updatedDate!),
      if (audioData != null) 'audioData': audioData!.map((e) => e.toJson()).toList(),
    };
  }
}
