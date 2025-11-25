import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String? docId;
  final String? mainCategory;
  final String? mainCategoryDec;
  final String? mainCategoryImage;
  final DateTime? createdDate;
  final DateTime? updatedDate;

  CategoryModel({
    this.docId,
    this.mainCategoryDec,
    this.mainCategoryImage,
    this.mainCategory,
    this.createdDate,
    this.updatedDate,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      docId: json['docId'] ?? '',
      mainCategory: json['main_category'] ?? '',
      mainCategoryImage: json['main_category_image'] ?? '',
      mainCategoryDec: json['mainCategoryDec'] ?? '',
      createdDate: (json['createdDate'] as Timestamp).toDate(),
      updatedDate: (json['updatedDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'docId': docId,
      'main_category': mainCategory,
      'main_category_image': mainCategory,
      'createdDate': createdDate,
      'updatedDate': updatedDate,
      'mainCategoryDec': mainCategoryDec,
    };
  }
}
