import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:moo_logue/app/core/constants/app_sizes.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';
import 'package:moo_logue/app/core/extention/sized_box_extention.dart';
import 'package:moo_logue/app/modules/authentication/controllers/forgot_password_controller.dart';
import 'package:moo_logue/app/routes/app_routes.dart';
import 'package:moo_logue/app/routes/index.js.dart';
import 'package:moo_logue/app/widgets/custom_appbar.dart';
import 'package:moo_logue/app/widgets/custom_button.dart';
import 'package:moo_logue/app/widgets/custom_text_form_field.dart';

class ForgotPasswordView extends StatelessWidget {
  ForgotPasswordView({super.key});
  final controller = Get.put(ForgotPasswordController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(text: AppString.forgotPassword),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
        child: Column(
          children: [
            20.heightBox,
            Text(textAlign: TextAlign.center, AppString.forgotPasswordDiscription, style: context.textTheme.titleSmall),
            35.heightBox,
            CustomTextFormField(
              hintText: 'Enter your email',
              title: 'Email',

              controller: controller.forgotEmailCnt,
              onChanged: (p0) => controller.checkForButtonEnabled(),
            ),
            50.heightBox,
            Obx(
              () => CustomButton(
                text: 'Send email',
                onTap: controller.isButtonEnabled.value
                    ? () async {

                        controller.forgotPassword(context);
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
