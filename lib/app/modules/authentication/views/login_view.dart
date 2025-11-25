import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:moo_logue/app/core/constants/app_assets.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
import 'package:moo_logue/app/core/constants/app_sizes.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';
import 'package:moo_logue/app/core/extention/sized_box_extention.dart';
import 'package:moo_logue/app/modules/authentication/controllers/login_view_controller.dart';
import 'package:moo_logue/app/routes/app_routes.dart';
import 'package:moo_logue/app/routes/index.js.dart';
import 'package:moo_logue/app/widgets/custom_button.dart';
import 'package:moo_logue/app/widgets/custom_text_form_field.dart';
import 'package:moo_logue/app/widgets/social_login_buttons.dart';

class LoginView extends StatelessWidget {
  final controller = Get.put(LoginViewController());

  LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  5.heightBox,
                  SvgPicture.asset(AppAssets.appLogo,color: AppColors.primary,),
                  2.heightBox,
                  Text(
                    AppString.logIntoMooLogue,
                    style: context.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 24.sp),
                  ),
                ],
              ),
              35.heightBox,
              SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextFormField(
                      hintText: 'Enter your email',
                      title: 'Email',
                      controller: controller.loginEmailCnt,
                      onChanged: (p0) => controller.checkForButtonEnabled(),
                    ),
                    15.heightBox,
                    Obx(
                      () => CustomTextFormField(
                        hintText: 'Enter your password',
                        title: 'Password',
                        controller: controller.loginPasswordCnt,
                        onChanged: (p0) {
                          controller.checkForButtonEnabled();
                          controller.checkForPasswordVisibility();
                        },
                        obscureText: !controller.isPasswordVisible.value,
                        suffixIcon: Obx(
                          () => controller.isShowPasswordOptionShow.value
                              ? IconButton(
                                  onPressed: () {
                                    controller.isPasswordVisible.value = !controller.isPasswordVisible.value;
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
                  ],
                ),
              ),
              35.heightBox,
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  ctx!.push(Routes.forgotPasswordView);
                },
                child: Center(
                  child: Text(
                    AppString.forgotYourUsernameOrPassword,
                    style: context.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                      decoration: TextDecoration.underline,
                      decorationThickness: 2,
                    ),
                  ),
                ),
              ),
              50.heightBox,
              Obx(
                () => CustomButton(
                  text: 'Login',
                  onTap: controller.isButtonEnabled.value
                      ? () {
                          controller.signInWithEmail(context);
                        }
                      : null,
                ),
              ),
              15.heightBox,
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.primaryTextColor.withValues(alpha: 0.1))),
                  Text(' or ', style: context.textTheme.bodySmall),
                  Expanded(child: Divider(color: AppColors.primaryTextColor.withValues(alpha: 0.1))),
                ],
              ),
              15.heightBox,
              SocialLoginButtons(
                onGoogleLogin: () => controller.signInWithGoogle(context),
                onAppleLogin: () => controller.signInWithApple(context),
                // onFacebookLogin: () => controller.signWithFacebook(context),
              ),
              50.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('New to MooLogue?', style: context.textTheme.bodyMedium),
                  5.widthBox,
                  GestureDetector(
                    onTap: () {
                      ctx!.push(Routes.createAccountView);
                    },
                    child: Text(
                      'Sign up',
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              10.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
