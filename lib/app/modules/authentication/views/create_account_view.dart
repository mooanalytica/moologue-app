import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:moo_logue/app/core/constants/app_assets.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
import 'package:moo_logue/app/core/constants/app_sizes.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';
import 'package:moo_logue/app/core/extention/sized_box_extention.dart';
import 'package:moo_logue/app/modules/authentication/controllers/create_account_controller.dart';
import 'package:moo_logue/app/modules/authentication/controllers/login_view_controller.dart';
import 'package:moo_logue/app/routes/app_routes.dart';
import 'package:moo_logue/app/routes/index.js.dart';
import 'package:moo_logue/app/widgets/custom_button.dart';
import 'package:moo_logue/app/widgets/custom_text_form_field.dart';
import 'package:moo_logue/app/widgets/social_login_buttons.dart';

class CreateAccountView extends StatelessWidget {
  CreateAccountView({super.key});
  CreateAccountController controller = Get.put(CreateAccountController());
  LoginViewController authController = Get.put(LoginViewController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
          child: SingleChildScrollView(
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
                      AppString.welcomeToMoologue,
                      style: context.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                30.heightBox,
                Text(AppString.loginDiscription, style: context.textTheme.bodyMedium),
                30.heightBox,
                Column(
                  children: [
                    CustomTextFormField(
                      hintText: AppString.firstNameHint,
                      title: AppString.firstName,
                      onChanged: (p0) => controller.checkForButtonEnabled(),
                      controller: controller.firstNameController,
                    ),
                    15.heightBox,
                    CustomTextFormField(
                      hintText: AppString.lastNameHint,
                      title: AppString.lastName,
                      onChanged: (p0) => controller.checkForButtonEnabled(),
                      controller: controller.lastNameController,
                    ),
                    15.heightBox,
                    CustomTextFormField(
                      hintText: AppString.emailHint,
                      title: AppString.email,
                      controller: controller.emailController,
                      onChanged: (p0) => controller.checkForButtonEnabled(),
                    ),
                    15.heightBox,
                    Obx(
                      () => CustomTextFormField(
                        hintText: AppString.passwordHint,
                        title: AppString.password,
                        controller: controller.passwordController,
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
                                  icon: const Text(AppString.show),
                                ).paddingOnly(right: 15.w)
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ],
                ),
                30.heightBox,
                Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        text: AppString.termsPrefix,
                        style: context.textTheme.bodySmall,
                        children: <TextSpan>[
                          TextSpan(
                            text: AppString.termsAndConditions,
                            style: context.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2,
                            ),
                          ),
                          const TextSpan(text: AppString.and),
                          TextSpan(
                            text: AppString.privacyPolicy,
                            style: context.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    40.heightBox,
                    Obx(
                      () => CustomButton(
                        text: AppString.createAccount,
                        onTap: controller.isButtonEnabled.value
                            ? () {
                                controller.signUpWithEmail(context);
                              }
                            : null,
                      ),
                    ),
                    15.heightBox,
                    Row(
                      children: [
                        Expanded(child: Divider(color: AppColors.primaryTextColor.withAlpha(25))),
                        Text(AppString.or, style: context.textTheme.bodySmall),
                        Expanded(child: Divider(color: AppColors.primaryTextColor.withAlpha(25))),
                      ],
                    ),
                    15.heightBox,
                    SocialLoginButtons(
                      onGoogleLogin: () => authController.signInWithGoogle(context),
                      onAppleLogin: () => authController.signInWithApple(context),
                      // onFacebookLogin: () => authController.signWithFacebook(context),
                    ),
                    15.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppString.alreadyHaveAnAccount, style: context.textTheme.bodyMedium),
                        5.widthBox,
                        GestureDetector(
                          onTap: () {
                            ctx!.go(Routes.loginView);
                          },
                          child: Text(
                            AppString.signIn,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
