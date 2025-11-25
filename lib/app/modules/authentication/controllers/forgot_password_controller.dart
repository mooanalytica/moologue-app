import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:moo_logue/app/api/api_constant.dart';
import 'package:moo_logue/app/api/api_service.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
import 'package:moo_logue/app/routes/app_routes.dart';
import 'package:moo_logue/app/routes/index.js.dart';
import 'package:moo_logue/app/widgets/app_snackbar.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController forgotEmailCnt = TextEditingController();
  RxBool isButtonEnabled = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void checkForButtonEnabled() {
    bool oldValue = isButtonEnabled.value;
    if (forgotEmailCnt.text.isNotEmpty) {
      isButtonEnabled.value = true;
    } else {
      isButtonEnabled.value = false;
    }

    if (oldValue != isButtonEnabled.value) {
      update();
    }
  }

  Future<void> forgotPassword(BuildContext context) async {
    showLoaderDialog(context);

    try {
      final String email = forgotEmailCnt.text.trim();


      final QuerySnapshot userQuery = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).limit(1).get();

      if (userQuery.docs.isEmpty) {
        hideLoaderDialog(context);
        showSnackBar(context, "No account found with this email");
        return;
      }

      await sendOtp(context, email);
    } catch (e) {
      hideLoaderDialog(context);
      showSnackBar(context, "Something went wrong: $e");
    }
  }

  Future<void> sendOtp(BuildContext context, String email) async {
    try {
      var response = await APIService().postAPI(url: AppUrls.sendOtp, body: {"email": email}, isMultipart: false, context: context);
      print('response==========>>>>>${response!.statusCode}');
      if (response.data['success'] == false) {
        showSnackBar(context, response.data['message'], backgroundColor: Colors.red);
        update();
      } else {
        await ctx!.push(Routes.resetVerificationView, extra: {'email': email, "isCreate": false});


        update();
      }
      hideLoaderDialog(context);
    } catch (e) {
      hideLoaderDialog(context);
      update();
    }
  }

  // Future<void> forgotPassword(BuildContext context) async {
  //   showLoaderDialog(context);
  //
  //   try {
  //
  //     await _auth.sendPasswordResetEmail(email: forgotEmailCnt.text);
  //     hideLoaderDialog(context);
  //     // await ctx!.push(
  //     //   Routes.resetVerificationView,
  //     //   extra: {'email': forgotEmailCnt.text},
  //     // );
  //     showSnackBar(
  //       context,
  //       'Password reset email sent!',
  //       backgroundColor: AppColors.primary,
  //     );
  //     await Future.delayed(
  //       Duration(seconds: 4),
  //       () => Navigator.pop(context),
  //     ).then((value) {
  //       forgotEmailCnt.clear();
  //     });
  //   } catch (e) {
  //     hideLoaderDialog(context);
  //     showSnackBar(context, e.toString());
  //   }
  // }
}
