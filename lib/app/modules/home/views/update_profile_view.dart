import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moo_logue/app/core/constants/app_const.dart';
import 'package:moo_logue/app/core/constants/app_sizes.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';
import 'package:moo_logue/app/core/extention/sized_box_extention.dart';
import 'package:moo_logue/app/modules/home/controllers/update_account_cnt.dart';
import 'package:moo_logue/app/widgets/custom_appbar.dart';
import 'package:moo_logue/app/widgets/custom_button.dart';
import 'package:moo_logue/app/widgets/custom_text_form_field.dart';

class UpdateAccountView extends StatefulWidget {
  const UpdateAccountView({super.key});

  @override
  State<UpdateAccountView> createState() => _UpdateAccountViewState();
}

class _UpdateAccountViewState extends State<UpdateAccountView> {
  UpdateAccountController controller = Get.put(UpdateAccountController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadUserData(context);
      controller.checkForButtonEnabled();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(text: AppString.profile),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
          child: GetBuilder<UpdateAccountController>(
            builder: (controller) => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.heightBox,
                  Center(
                    child: GetBuilder<UpdateAccountController>(
                      builder: (controller) {
                        return GestureDetector(
                          onTap: () {},
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage: controller.photoUrl.value.isNotEmpty
                                ? (controller.photoUrl.value.startsWith("https")
                                      ? NetworkImage(controller.photoUrl.value)
                                      : NetworkImage("$awsFilesUrl${controller.photoUrl.value}"))
                                : NetworkImage(
                                    "https://www.shutterstock.com/image-vector/user-profile-icon-vector-avatar-600nw-2558760599.jpg",
                                  ),
                            child: controller.photoUrl.value.isEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Center(
                                      child: Image.network(
                                        "https://www.shutterstock.com/image-vector/user-profile-icon-vector-avatar-600nw-2558760599.jpg",
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  ),

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
                        readOnly: true,
                        controller: controller.emailController,
                        onChanged: (p0) => controller.checkForButtonEnabled(),
                      ),
                      15.heightBox,
                      if (controller.type == "Normal")
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
                                        log('controller.isPasswordVisible.value==============>>>${controller.isPasswordVisible.value}');
                                      },
                                      icon: const Text(AppString.show),
                                    ).paddingOnly(right: 15.w)
                                  : const SizedBox.shrink(),
                            ),
                          ),
                        ),
                    ],
                  ),

                  40.heightBox,
                  CustomButton(
                    text: AppString.updateProfile,
                    onTap: () {
                      // controller.updateProfileAWS(context);
                      controller.saveUpdatedProfile(context);
                    },
                  ),
                  15.heightBox,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
