import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:moo_logue/app/api/api_constant.dart';
import 'package:moo_logue/app/api/api_service.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
import 'package:moo_logue/app/core/storage/get_storage.dart';
import 'package:moo_logue/app/model/users_response_model.dart';
import 'package:moo_logue/app/modules/home/controllers/home_controller.dart';

import 'package:moo_logue/app/widgets/app_snackbar.dart';

class UpdateAccountController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isButtonEnabled = false.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool isShowPasswordOptionShow = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxString photoUrl = "".obs;
  String? type = "Normal";



  void checkForButtonEnabled() {
    bool oldValue = isButtonEnabled.value;
    if (emailController.text.isNotEmpty &&
        firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      isButtonEnabled.value = true;
    } else {
      isButtonEnabled.value = false;
    }

    if (oldValue != isButtonEnabled.value) {
      update();
    }
  }

  void clearController() {
    emailController.clear();
    firstNameController.clear();
    lastNameController.clear();
    passwordController.clear();
    update();
  }

  void checkForPasswordVisibility() {
    bool oldValue = isShowPasswordOptionShow.value;
    log('passwordController.text==============>>>${passwordController.text}');
    if (passwordController.text.isNotEmpty) {
      isShowPasswordOptionShow.value = true;
    } else {
      isShowPasswordOptionShow.value = false;
    }

    if (oldValue != isShowPasswordOptionShow.value) {
      update();
    }
  }

  // Future<void> updateProfileAWS(BuildContext context) async {
  //   try {
  //     final bytes = await pickedImage!.readAsBytes(); // read bytes from XFile
  //     String image = "data:image/jpeg;base64,${base64Encode(bytes)}";
  //     showLoaderDialog(context);
  //     var response = await APIService().postAPI(
  //       url: AppUrls.uploadProfile,
  //       body: {"profile": image, "folderName": "UserProfile"},
  //       isMultipart: false,
  //       context: context,
  //     );
  //
  //     print('response=====verifyOtp=====>>>>>${response?.statusCode}');
  //     if (response?.statusCode == 200) {
  //       await saveUpdatedProfile(context, response?.data["data"]);
  //     } else {
  //       showSnackBar(context, "Invalid Code", backgroundColor: Colors.red);
  //     }
  //     hideLoaderDialog(context);
  //   } catch (e) {
  //     showSnackBar(context, "${e}", backgroundColor: Colors.red);
  //     log("verifyOtp error =======>> $e");
  //     hideLoaderDialog(context);
  //     update();
  //   } finally {
  //     hideLoaderDialog(context);
  //     update();
  //   }
  // }

  Future<void> loadUserData(BuildContext context) async {
    try {
      showLoaderDialog(context);
      String? userId = AppStorage.getString(AppStorage.userId);

      if (userId != null && userId.isNotEmpty) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
        final userStorage = UserStorageService();
        if (userDoc.exists) {
          var data = userDoc.data() as Map<String, dynamic>;

          firstNameController.text = data['firstName'] ?? '';
          lastNameController.text = data['lastName'] ?? '';
          emailController.text = data['email'] ?? '';
          passwordController.text = data['password'] ?? ''; // ⚠️ only if you stored plain password
          passwordController.text = data['password'] ?? ''; // ⚠️ only if you stored plain password
          photoUrl.value = data['photo'] ?? '';
          type = data['type'] ?? '';

          DateTime createdAt;
          if (data['createdAt'] is Timestamp) {
            createdAt = (data['createdAt'] as Timestamp).toDate();
          } else if (data['createdAt'] is String) {
            createdAt = DateTime.tryParse(data['createdAt']) ?? DateTime.now();
          } else {
            createdAt = DateTime.now();
          }

          DateTime endDate;
          if (data['endDate'] is Timestamp) {
            endDate = (data['endDate'] as Timestamp).toDate();
          } else if (data['endDate'] is String) {
            endDate = DateTime.tryParse(data['endDate']) ?? DateTime.now();
          } else {
            endDate = DateTime.now();
          }

          final dynamic rawPoints = data['totalPoints'];
          int parsedPoints = 0;
          if (rawPoints is int) {
            parsedPoints = rawPoints;
          } else if (rawPoints is num) {
            parsedPoints = rawPoints.toInt();
          } else if (rawPoints is String) {
            parsedPoints = int.tryParse(rawPoints) ?? 0;
          }

          final dynamic streakPoints = data['streakCount'];
          int parsedStreakPoints = 0;
          if (streakPoints is int) {
            parsedStreakPoints = streakPoints;
          } else if (streakPoints is num) {
            parsedStreakPoints = streakPoints.toInt();
          } else if (streakPoints is String) {
            parsedStreakPoints = int.tryParse(streakPoints) ?? 0;
          }
          await userStorage.saveUser(
            UserModel(
              createdAt: createdAt,
              email: data['email'] ?? "",
              firstName: data['firstName'] ?? "",
              lastName: data['lastName'] ?? "",
              photo: data['photo'] ?? "",
              totalPoints: parsedPoints,
              endDate: endDate,
              streakCount: parsedStreakPoints,
            ),
          );
          user = userStorage.getUser();
          update();
        }
      }
      hideLoaderDialog(context);
    } catch (e) {
      log("Error loading user data: $e");
    }
  }

  Future<void> saveUpdatedProfile(BuildContext context) async {
    try {
      showLoaderDialog(context);
      String? userId = AppStorage.getString(AppStorage.userId);

      if (userId == null || userId.isEmpty) {
        showSnackBar(context, "User not found", backgroundColor: Colors.red);
        hideLoaderDialog(context);
        return;
      }

      await _firestore.collection('users').doc(userId).update({
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'email': emailController.text.trim(),
        'photo': photoUrl.value, // update photo only if new selected
        'updatedAt': FieldValue.serverTimestamp(),
      });

      showSnackBar(context, "Profile updated successfully!", backgroundColor: AppColors.primary);
      update();
      hideLoaderDialog(context);
    } catch (e) {
      log("Error saving profile: $e");
      showSnackBar(context, "Error updating profile", backgroundColor: Colors.red);
      hideLoaderDialog(context);
    }
  }
}
