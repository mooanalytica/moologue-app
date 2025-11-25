import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
import 'package:moo_logue/app/core/constants/app_sizes.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';
import 'package:moo_logue/app/core/extention/sized_box_extention.dart';
import 'package:moo_logue/app/modules/authentication/controllers/reset_verification_controller.dart';
import 'package:moo_logue/app/routes/app_routes.dart';
import 'package:moo_logue/app/routes/index.js.dart';
import 'package:moo_logue/app/widgets/custom_appbar.dart';
import 'package:moo_logue/app/widgets/custom_button.dart';
import 'package:pinput/pinput.dart';

class ResetVerificationView extends StatefulWidget {
  final dynamic email;
  final bool isCreate;
  ResetVerificationView({super.key, required this.email, required this.isCreate});

  @override
  State<ResetVerificationView> createState() => _ResetVerificationViewState();
}

class _ResetVerificationViewState extends State<ResetVerificationView> {
  final controller = Get.put(ResetVerificationController());

  @override
  void initState() {
    controller.pinController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(text: AppString.checkYourInbox),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            20.heightBox,
            RichText(
              text: TextSpan(
                text: 'Enter the code we sent to ',
                style: context.textTheme.bodySmall,
                children: <TextSpan>[
                  TextSpan(
                    text: widget.email.toString(),
                    style: context.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                    ),
                  ),
                  const TextSpan(text: ' to verify your account.'),
                ],
              ),
            ),
            35.heightBox,
            Directionality(
              textDirection: TextDirection.ltr,
              child: Pinput(
                length: 6,
                controller: controller.pinController,
                defaultPinTheme: controller.defaultPinTheme,
                separatorBuilder: (index) => SizedBox(width: 8.w),
                hapticFeedbackType: HapticFeedbackType.lightImpact,
                onCompleted: (pin) {
                  debugPrint('onCompleted: $pin');
                },
                onChanged: controller.checkForButtonEnabled,
              ),
            ),
            50.heightBox,
            Obx(
              () => CustomButton(
                text: AppString.continueLbl,
                onTap: controller.isButtonEnabled.value
                    ? () {

                    controller.verifyOtp(context,widget.email, controller.pinController.text,widget.isCreate);



                      }
                    : null,
              ),
            ),
            50.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppString.resetVerification1,
                  style: context.textTheme.bodyMedium,
                ),
                5.widthBox,
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    AppString.resendCode,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationThickness: 2,
                    ),
                  ),
                ),
              ],
            ),
            15.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppString.resetVerification2,
                  style: context.textTheme.bodyMedium,
                ),
                5.widthBox,
                Text(
                  AppString.emailId,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
