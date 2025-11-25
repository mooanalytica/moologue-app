import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:moo_logue/app/api/api_constant.dart';
import 'package:moo_logue/app/api/api_service.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
import 'package:moo_logue/app/core/storage/get_storage.dart';
import 'package:moo_logue/app/routes/app_routes.dart';
import 'package:moo_logue/app/routes/index.js.dart';
import 'package:moo_logue/app/widgets/app_snackbar.dart';
import 'package:pinput/pinput.dart';

class ResetVerificationController extends GetxController {
  RxBool isButtonEnabled = false.obs;
  TextEditingController pinController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void checkForButtonEnabled(String value) {
    bool oldValue = isButtonEnabled.value;
    if (value.length >= 6) {

      isButtonEnabled.value = true;

    } else {
      isButtonEnabled.value = false;
    }

    if (oldValue != isButtonEnabled.value) {
      update();
    }
  }

  final defaultPinTheme = PinTheme(
    width: 61.w,
    height: 75.h,
    textStyle: const TextStyle(fontSize: 20, color: AppColors.primaryTextColor),
    decoration: BoxDecoration(
      color: AppColors.closeIconBgColor.withValues(alpha: 0.25),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppColors.pinputBorder),
    ),
  );

  Future<void> verifyOtp(BuildContext context, String email, String code, bool isCreate) async {
    try {
      showLoaderDialog(context);
      var response = await APIService().postAPI(url: AppUrls.verifyOtp, body: {"email": email, "code": code}, isMultipart: false, context: context);

      print('response=====verifyOtp=====>>>>>${response?.statusCode}');
      if(response?.statusCode == 200){
        if (response?.data['status'] == "pending" || response?.data['status'] == "Invalid Code") {
          showSnackBar(context,"Invalid Code", backgroundColor: Colors.red);
          update();
        } else {
          String? userId = AppStorage.getString(AppStorage.userId);

          if (userId != null && userId.isNotEmpty) {
            await _firestore.collection('users').doc(userId).update({"is_user_verify": true, "updatedAt": FieldValue.serverTimestamp()});
          }

          if (isCreate == true) {
            ctx!.go(Routes.homeView);
          } else {
            await ctx!.push(Routes.resetPasswordView, extra: {'email': email, "isCreate": false});

          }
          update();
        }
      }else{
        showSnackBar(context, "Invalid Code", backgroundColor: Colors.red);
      }
      hideLoaderDialog(context);
    } catch (e) {
      showSnackBar(context, "${e}", backgroundColor: Colors.red);
      log("verifyOtp error =======>> $e");
      hideLoaderDialog(context);
      update();
    }finally{
      hideLoaderDialog(context);
      update();
    }
  }
}
