import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:moo_logue/app/core/constants/app_sizes.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';
import 'package:moo_logue/app/core/extention/sized_box_extention.dart';
import 'package:moo_logue/app/modules/authentication/controllers/reset_password_controller.dart';
import 'package:moo_logue/app/routes/app_routes.dart';
import 'package:moo_logue/app/routes/index.js.dart';
import 'package:moo_logue/app/widgets/custom_appbar.dart';
import 'package:moo_logue/app/widgets/custom_button.dart';
import 'package:moo_logue/app/widgets/custom_text_form_field.dart';

class ResetPasswordView extends StatelessWidget {
  ResetPasswordView({super.key, this.email, required this.isCreate});
  final dynamic email;
  final bool isCreate;
  final controller = Get.put(ResetPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(text: AppString.resetPassword),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
        child: Column(
          children: [
            35.heightBox,
            Obx(
              () => CustomTextFormField(
                hintText: '8 character minimum',
                title: 'New Password',
                controller: controller.newPasswordController,
                onChanged: (p0) {
                  controller.checkForButtonEnabled(context);
                  controller.checkForPasswordVisibility();
                },
                obscureText: !controller.isPasswordVisible.value,
                suffixIcon: Obx(
                  () => controller.isShowPasswordOptionShow.value
                      ? IconButton(
                          onPressed: () {
                            controller.isPasswordVisible.value =
                                !controller.isPasswordVisible.value;
                            log(
                              'controller.isPasswordVisible.value==============>>>${controller.isPasswordVisible.value}',
                            );
                          },
                          icon: const Text('Show'),
                        ).paddingOnly(right: 15.w)
                      : const SizedBox.shrink(),
                ),
              ),
            ),
            15.heightBox,
            Obx(
              () => CustomTextFormField(
                hintText: 'Passwords must match',
                title: 'Retype Password',
                controller: controller.confirmPasswordController,
                onChanged: (p0) {
                  controller.checkForButtonEnabled(context);
                  controller.checkForPasswordVisibilityOne();
                },
                obscureText: !controller.isPasswordVisible1.value,
                suffixIcon: Obx(
                  () => controller.isShowPasswordOptionShow1.value
                      ? IconButton(
                          onPressed: () {
                            controller.isPasswordVisible1.value =
                                !controller.isPasswordVisible1.value;
                            log(
                              'controller.isPasswordVisible.value==============>>>${controller.isPasswordVisible1.value}',
                            );
                          },
                          icon: const Text('Show'),
                        ).paddingOnly(right: 15.w)
                      : const SizedBox.shrink(),
                ),
              ),
            ),
            50.heightBox,
            Obx(
              () => CustomButton(
                text: 'Reset password',
                onTap: controller.isButtonEnabled.value
                    ? () {
                  controller.isPasswordMatch(context,email,controller.confirmPasswordController.text.trim());
                        // ctx?.go(Routes.loginView);
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
