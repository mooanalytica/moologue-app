import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:moo_logue/app/api/api_constant.dart';
import 'package:moo_logue/app/api/api_service.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
import 'package:moo_logue/app/core/storage/get_storage.dart';
import 'package:moo_logue/app/routes/app_routes.dart';
import 'package:moo_logue/app/routes/index.js.dart';
import 'package:moo_logue/app/widgets/app_snackbar.dart';

class CreateAccountController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isButtonEnabled = false.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool isShowPasswordOptionShow = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  // Future<void> signUpWithEmail(BuildContext context) async {
  //   showLoaderDialog(context);
  //   try {
  //     final UserCredential userCredential = await _auth
  //         .createUserWithEmailAndPassword(
  //           email: emailController.text.trim(),
  //           password: passwordController.text.trim(),
  //         );
  //
  //     final User? user = userCredential.user;
  //
  //     if (user != null) {
  //       await AppStorage.setString(AppStorage.userId, user.uid);
  //       await _firestore.collection('users').doc(user.uid).set({
  //         'firstName': firstNameController.text.trim(),
  //         'lastName': lastNameController.text.trim(),
  //         'email': emailController.text.trim(),
  //         'photo':'',
  //         'createdAt': FieldValue.serverTimestamp(),
  //         'user_id':user.uid,
  //         'is_user_verify': false,
  //         'password':passwordController.text.trim()
  //       });
  //
  //       // await user.sendEmailVerification();
  //
  //
  //
  //
  //       await sendOtp(context,emailController.text.trim());
  //       showSnackBar(
  //       context,
  //       'Account created successfully! Please verify your email.',
  //       backgroundColor: AppColors.primary,
  //       );
  //       clearController();
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     String message = '';
  //     if (e.code == 'email-already-in-use') {
  //       message = 'This email is already registered.';
  //     } else if (e.code == 'weak-password') {
  //       message = 'Password should be at least 6 characters.';
  //     } else {
  //       message = e.message ?? 'An error occurred.';
  //     }
  //     showSnackBar(context, message, backgroundColor: Colors.red);
  //     hideLoaderDialog(context);
  //   } catch (e) {
  //     log('e=================>>>>>$e');
  //   }
  // }
  Future<void> signUpWithEmail(BuildContext context) async {
    showLoaderDialog(context);
    try {
      final String email = emailController.text.trim();


      final QuerySnapshot existingUser = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (existingUser.docs.isNotEmpty) {
        hideLoaderDialog(context);
        showSnackBar(context, 'This email is already registered.',
            backgroundColor: Colors.red);
        return;
      }

      final String userId = _firestore.collection('users').doc().id;

      await _firestore.collection('users').doc(userId).set({
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'email': email,
        'photo': '',
        'createdAt': FieldValue.serverTimestamp(),
        'user_id': userId,
        'is_user_verify': false,
        'password': passwordController.text.trim(),
        'type':"Normal",
        'isUserBlock':false
      });

      await AppStorage.setString(AppStorage.userId, userId);
      await sendOtp(context,emailController.text.trim());
      showSnackBar(
        context,
        'Account created successfully! Please verify your email.',

        backgroundColor: AppColors.primary,
      );

      clearController();

    } catch (e) {
      hideLoaderDialog(context);
      log('Error=================>>>>>$e');
      showSnackBar(context, 'An error occurred.', backgroundColor: Colors.red);
    }
  }

  Future<void> sendOtp(BuildContext context,String email) async {
    try {

      var response = await APIService().postAPI(
        url: AppUrls.sendOtp,
        body: {"email": email, },
        isMultipart: false, context: context,
      );
      print('response==========>>>>>${response!.statusCode}');
      if (response.data['success'] == false) {
        showSnackBar(context, response.data['message'],backgroundColor: Colors.red);
        update();
      } else {
        await ctx!.push(
          Routes.resetVerificationView,
          extra: {'email': emailController.text,'isCreate':true},
        );

        update();
      }
      hideLoaderDialog(context);
    } catch (e) {
      hideLoaderDialog(context);
      update();
    }
  }
}
