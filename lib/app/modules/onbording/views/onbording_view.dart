import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:moo_logue/app/controllers/theme_controller.dart';
import 'package:moo_logue/app/core/constants/app_assets.dart';
import 'package:moo_logue/app/core/constants/app_sizes.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';
import 'package:moo_logue/app/core/enums/font_size_option.dart';
import 'package:moo_logue/app/core/extention/sized_box_extention.dart';
import 'package:moo_logue/app/modules/home/widgets/glass_effect_view.dart';
import 'package:moo_logue/app/modules/home/widgets/normal_conatiner.dart';
import 'package:moo_logue/app/modules/onbording/controllers/onbording_controller.dart';
import 'package:moo_logue/app/modules/onbording/widgets/galss_effect_container.dart';
import 'package:moo_logue/app/routes/app_routes.dart';
import 'package:moo_logue/app/modules/onbording/views/onbording_two_view.dart';
import 'package:moo_logue/app/routes/app_routes.dart';
import 'package:moo_logue/app/routes/index.js.dart';
import 'package:moo_logue/app/widgets/app_logo.dart';
import 'package:moo_logue/app/widgets/custom_button.dart';
import 'package:moo_logue/app/widgets/rounded_asset_image.dart';

class OnBordingView extends StatelessWidget {
  final controller = Get.put(OnBordingController);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              10.heightBox,
              Center(child: AppLogo()),
              50.heightBox,
              RoundedAssetImage(
                imagePath: AppAssets.onbording1,
                width: double.infinity,
                height: 233.h,
                borderRadius: 25,
              ),
              50.heightBox,
              Text(
                AppString.onBordingTitle1,
                textAlign: TextAlign.center,
                style: context.textTheme.titleLarge?.copyWith(fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
              20.heightBox,
              Text(
                AppString.onBordingSubtitle1,
                textAlign: TextAlign.center,
                style: context.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w400),
              ),

              50.heightBox,
              Text(AppString.poweredBy, style: context.textTheme.labelSmall?.copyWith(fontSize: 10.sp)),
              12.heightBox,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  context.isDarkMode
                      ? GlassEffectScreen(
                          width: 140.w,
                          height: 50.h,
                          color: context.isDarkMode ? Colors.black.withOpacity(0.1) : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          child: Center(
                            child: SvgPicture.asset(
                              context.isDarkMode ? AppAssets.dalhouseDarkLogo : AppAssets.dalhouseLightLogo,
                              width: 120.w,
                            ),
                          ),
                        )
                      : CourseCard(
                          width: 140.w,
                          height: 50.h,
                          color: context.isDarkMode ? Colors.black.withOpacity(0.1) : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          child: Center(
                            child: SvgPicture.asset(
                              context.isDarkMode ? AppAssets.dalhouseDarkLogo : AppAssets.dalhouseLightLogo,
                              width: 120.w,
                            ),
                          ),
                        ),
                  20.widthBox,
                  context.isDarkMode
                      ? GlassEffectScreen(
                          width: 140.w,
                          height: 50.h,
                          color: context.isDarkMode ? Colors.black.withOpacity(0.1) : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          child: Center(child: SvgPicture.asset(AppAssets.mooanalyticaLogo)),
                        )
                      : CourseCard(
                          width: 140.w,
                          height: 50.h,
                          color: context.isDarkMode ? Colors.black.withOpacity(0.1) : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          child: Center(child: SvgPicture.asset(AppAssets.mooanalyticaLogo)),
                        ),
                ],
              ),
              const Spacer(),
              CustomButton(
                text: 'Continue',
                onTap: () {
                  ctx!.push(Routes.onbordingTwoView);
                },
              ),
              10.heightBox,
              TextButton(
                onPressed: () {
                  ctx!.go(Routes.loginView);
                },
                child: Text(AppString.logIn, style: context.textTheme.titleMedium),
              ),
              20.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
