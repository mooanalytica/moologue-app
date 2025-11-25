import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
import 'package:moo_logue/app/routes/app_routes.dart';
import 'package:moo_logue/app/widgets/app_snackbar.dart';

class ResetPasswordController extends GetxController {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  RxBool isButtonEnabled = false.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool isPasswordVisible1 = false.obs;
  RxBool isShowPasswordOptionShow = false.obs;
  RxBool isShowPasswordOptionShow1 = false.obs;

  void checkForButtonEnabled(BuildContext context) {
    bool oldValue = isButtonEnabled.value;
    if (newPasswordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty) {


        isButtonEnabled.value = true;

    } else {

      isButtonEnabled.value = false;
    }

    if (oldValue != isButtonEnabled.value) {
      update();
    }
  }

  Future<void> isPasswordMatch(context,email,confirmPassword) async {
    if(newPasswordController.text != confirmPasswordController.text){
      showSnackBar(context, 'Password do not match', backgroundColor: Colors.red);
    }else{
     await resetPassword(context,email,confirmPassword);
    }
  }
  void checkForPasswordVisibility() {
    bool oldValue = isShowPasswordOptionShow.value;
    log(
      'passwordController.text==============>>>${newPasswordController.text}',
    );
    if (newPasswordController.text.isNotEmpty) {
      isShowPasswordOptionShow.value = true;
    } else {
      isShowPasswordOptionShow.value = false;
    }

    if (oldValue != isShowPasswordOptionShow.value) {
      update();
    }
  }
  Future<void> resetPassword(BuildContext context,String email, String newPassword) async {
    showLoaderDialog(context);
    final QuerySnapshot userQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (userQuery.docs.isNotEmpty) {
      final userDocId = userQuery.docs.first.id;

      await FirebaseFirestore.instance.collection('users').doc(userDocId).update({
        "password": newPassword,
        "updatedAt": FieldValue.serverTimestamp(),
      });
      showSnackBar(context, 'Password reset successfully!', backgroundColor:AppColors.primary);
      hideLoaderDialog(context);
      context.go(Routes.loginView);
    }
  }

  void checkForPasswordVisibilityOne() {
    bool oldValue = isShowPasswordOptionShow1.value;
    log(
      'passwordController.text==============>>>${confirmPasswordController.text}',
    );
    if (confirmPasswordController.text.isNotEmpty) {
      isShowPasswordOptionShow1.value = true;
    } else {
      isShowPasswordOptionShow1.value = false;
    }

    if (oldValue != isShowPasswordOptionShow1.value) {
      update();
    }
  }
}
