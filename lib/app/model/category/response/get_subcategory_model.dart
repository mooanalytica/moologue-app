import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubCategoryModel {
  final String? docId;
  final String? mainCategory;
  final String? mainCategoryId;
  final String? subCategory;
  final String? subCategoryDec;
  final String? description;
  final String? folderName;
  final List<String>? attachments;
  final DateTime? createdDate;
  final DateTime? updatedDate;

  SubCategoryModel({
    this.docId,
    this.mainCategory,
    this.subCategoryDec,
    this.mainCategoryId,
    this.subCategory,
    this.folderName,
    this.attachments,
    this.createdDate,
    this.updatedDate,
    this.description,
  });

  factory SubCategoryModel.fromMap(Map<String, dynamic> map) {
    return SubCategoryModel(
      docId: map['docId'] as String?,
      mainCategory: map['main_category'] as String?,
      subCategoryDec: map['subCategoryDec'] as String?,
      mainCategoryId: map['main_category_id'] as String?,
      subCategory: map['sub_category'] as String?,
      folderName: map['folderName'] as String?,
      description: map['description'] as String?,
      attachments: (map['attachments'] != null) ? List<String>.from(map['attachments']) : null,
      createdDate: map['createdDate'] != null ? (map['createdDate'] as Timestamp).toDate() : null,
      updatedDate: map['updatedDate'] != null ? (map['updatedDate'] as Timestamp).toDate() : null,
    );
  }

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel.fromMap(json);
  }

  Map<String, dynamic> toJson() {
    return {
      'docId': docId,
      'main_category': mainCategory,
      'main_category_id': mainCategoryId,
      'sub_category': subCategory,
      'folderName': folderName,
      'attachments': attachments,
      'description': description,
      'subCategoryDec': subCategoryDec,
      'createdDate': createdDate?.toIso8601String(),
      'updatedDate': updatedDate?.toIso8601String(),
    };
  }

  factory SubCategoryModel.fromJsonString(String source) => SubCategoryModel.fromJson(json.decode(source));

  String toJsonString() => json.encode(toJson());
}
