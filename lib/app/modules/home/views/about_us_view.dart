import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:moo_logue/app/core/constants/app_assets.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
import 'package:moo_logue/app/core/constants/app_sizes.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';
import 'package:moo_logue/app/core/extention/sized_box_extention.dart';
import 'package:moo_logue/app/modules/home/controllers/about_us_controller.dart';
import 'package:moo_logue/app/modules/home/widgets/glass_effect_view.dart';
import 'package:moo_logue/app/modules/home/widgets/normal_conatiner.dart';
import 'package:moo_logue/app/widgets/common_home_app_bar.dart';
import 'package:moo_logue/app/widgets/rounded_asset_image.dart';

class AboutUsView extends StatelessWidget {
  AboutUsView({super.key});
  final controller = Get.put(AboutUsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomHomeAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.heightBox,
              Center(child: Text(AppString.aboutMooLogue, style: context.textTheme.displayMedium?.copyWith())),
              35.heightBox,
              RoundedAssetImage(imagePath: AppAssets.aboutUsBannerImage, width: double.infinity, height: 233.h, borderRadius: 25),
              35.heightBox,
              Text(AppString.aboutMooLogue, style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600)),
              10.heightBox,
              Text(AppString.aboutMooLogueDiscription, style: context.textTheme.labelLarge?.copyWith()),
              35.heightBox,
              Text(AppString.whatsInside, style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600)),
              10.heightBox,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  controller.aboutList.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Container(
                      width: 210.w,
                      decoration: BoxDecoration(color: AppColors.aboutContainerColor, borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
                        child: Text(
                          controller.aboutList[index],
                          style: context.textTheme.titleLarge?.copyWith(fontSize: 10.sp, color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              35.heightBox,
              Text(AppString.credits, style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600)),
              10.heightBox,
              Text(AppString.creditsDiscription, style: context.textTheme.labelLarge?.copyWith()),
              15.heightBox,
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
              50.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
