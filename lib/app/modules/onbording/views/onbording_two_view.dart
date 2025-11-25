import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:go_router/go_router.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:moo_logue/app/core/constants/app_assets.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
import 'package:moo_logue/app/core/constants/app_sizes.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';
import 'package:moo_logue/app/core/extention/sized_box_extention.dart';
import 'package:moo_logue/app/modules/onbording/controllers/onbording_two_controller.dart';
import 'package:moo_logue/app/modules/onbording/controllers/onbording_controller.dart';
import 'package:moo_logue/app/routes/app_routes.dart';
import 'package:moo_logue/app/routes/index.js.dart';
import 'package:moo_logue/app/widgets/app_logo.dart';
import 'package:moo_logue/app/widgets/custom_button.dart';
import 'package:moo_logue/app/widgets/rounded_asset_image.dart';

class OnbordingTwoView extends StatelessWidget {
  final controller = Get.put(OnbordingTwoController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              10.heightBox,
              Align(
                alignment: FractionalOffset.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
                  child: GestureDetector(
                    onTap: () {
                      ctx!.pop();
                    },
                    child: Container(
                      height: 30.h,
                      width: 30.w,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.closeIconBgColor),
                      child: const Icon(Icons.close, color: AppColors.primaryTextColor, size: 12),
                    ),
                  ),
                ),
              ),
              30.heightBox,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
                child: SizedBox(
                  height: 3.h,
                  child: LinearProgressBar(
                    maxSteps: 3,
                    progressType: LinearProgressBar.progressTypeLinear,
                    currentStep: controller.currentPage.value + 1,
                    progressColor: AppColors.primary,
                    backgroundColor: AppColors.sliderColor.withValues(alpha: 0.5),
                  ),
                ),
              ),
              30.heightBox,
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: (index) {
                    controller.currentPage.value = index;
                    print('index: $index');
                    print('currentPage: ${controller.currentPage.value}');
                  },
                  itemCount: controller.mooLogue.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
                      child: Column(
                        children: [
                          Text(
                            "${controller.mooLogue[index]['Title']}",
                            textAlign: TextAlign.center,
                            style: context.textTheme.displayMedium,
                          ),
                          35.heightBox,
                          Text(
                            "${controller.mooLogue[index]['SubTitle']}",
                            textAlign: TextAlign.center,
                            style: context.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w400),
                          ),
                          50.heightBox,
                          RoundedAssetImage(
                            imagePath: "${controller.mooLogue[index]['Image']}",
                            width: double.infinity,
                            height: 450.h,
                            borderRadius: 25,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              30.heightBox,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
                child: CustomButton(
                  text: 'Next',
                  onTap: () {
                    if (controller.currentPage.value == controller.mooLogue.length - 1) {
                      ctx!.go(Routes.createAccountView);
                    } else {
                      controller.scrollTap();
                    }
                  },
                ),
              ),
              20.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
