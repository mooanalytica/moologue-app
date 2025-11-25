 
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
 
import 'package:go_router/go_router.dart';
import 'package:moo_logue/app/core/constants/app_assets.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
import 'package:moo_logue/app/core/constants/app_const.dart';
import 'package:moo_logue/app/core/constants/app_sizes.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';
import 'package:moo_logue/app/core/extention/sized_box_extention.dart';
import 'package:moo_logue/app/modules/home/controllers/emotional_calls_controller.dart';
import 'package:moo_logue/app/modules/home/controllers/home_controller.dart';
import 'package:moo_logue/app/modules/home/widgets/glass_effect_view.dart';
import 'package:moo_logue/app/modules/home/widgets/normal_conatiner.dart';
import 'package:moo_logue/app/routes/app_routes.dart';
import 'package:moo_logue/app/routes/index.js.dart';
import 'package:moo_logue/app/utils/common_function.dart' show formatString;
import 'package:moo_logue/app/widgets/app_snackbar.dart';
import 'package:moo_logue/app/widgets/common_home_app_bar.dart';
 
import 'package:moo_logue/app/widgets/rounded_asset_image.dart';

class EmotionalCallsView extends StatefulWidget {
  const EmotionalCallsView({super.key, required this.id, required this.name});
  final String id;
  final String name;

  @override
  State<EmotionalCallsView> createState() => _EmotionalCallsViewState();
}

class _EmotionalCallsViewState extends State<EmotionalCallsView> {
  final controller = Get.put(EmotionalCallsController());
  final homeController = Get.find<HomeController>();

  @override
  void initState() {
    debugPrint('widget.id==========>>>>>${widget.id}');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.fetchMaternalCallsBySubCategory(categoryId: widget.id);
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmotionalCallsController>(
      builder: (controller) {
        return Scaffold(
          appBar: CustomHomeAppBar(),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
            child: Column(
              children: [
                25.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        ctx!.pop();
                      },
                      child: SvgPicture.asset(
                        AppAssets.arrowleftIcon,
                        colorFilter: ColorFilter.mode(
                          context.isDarkMode ? AppColors.whiteColor : AppColors.primaryTextColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    Text(
                      // AppString.emotionalCalls,
                      formatString(widget.name, capitalizeWords: false),
                      style: context.textTheme.displayMedium?.copyWith(),
                    ),
                    SizedBox(),
                  ],
                ),
                25.heightBox,
                Expanded(
                  child: controller.isLoading.value == true
                      ? Center(child: showLoader())
                      : controller.audiosData.isEmpty
                      ? Center(child: Text("No data available"))
                      : ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: controller.audiosData.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            debugPrint('controller.isLoading.value==========>>>>>${controller.isLoading.value}');
                            debugPrint('controller.subcategories.length==========>>>>>${controller.audiosData.length}');
                            final data = controller.audiosData[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: context.isDarkMode
                                  ? GlassEffectScreen(
                                      width: 389.w,
                                      height: 250.h,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          RoundedNetworkImage(
                                            imageUrl: "$awsFilesUrl${data.audioImage}",
                                            width: double.infinity,
                                            height: 110.h,
                                            fit: BoxFit.cover,
                                            borderRadius: 20,
                                          ),
                                          12.heightBox,
                                          Text(
                                            formatString(data.audioTitle ?? "", capitalizeWords: false),
                                            maxLines: 2,
                                            style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
                                          ),
                                          Spacer(),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    ctx?.push(Routes.fenceInteractionCallView, extra: data);
                                                    controller.addViewDetailsPts();
                                                    homeController.markStreakForToday();
                                                  },
                                                  child: Container(
                                                    height: 40.h,

                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius: BorderRadius.circular(100),
                                                      border: Border.all(color: AppColors.primary, width: 1),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        AppString.learnMore,
                                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                          fontWeight: FontWeight.w600,
                                                          color: context.isDarkMode ? AppColors.whiteColor : AppColors.primary,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              10.widthBox,
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    ctx?.push(Routes.fenceInteractionCallView, extra: data);
                                                    controller.addPlaySoundPts();
                                                    homeController.markStreakForToday();
                                                  },
                                                  child: Container(
                                                    height: 40.h,

                                                    decoration: BoxDecoration(
                                                      color: AppColors.primary,
                                                      borderRadius: BorderRadius.circular(100),
                                                      border: Border.all(color: AppColors.primary, width: 1),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          AppString.playSound,
                                                          style: context.textTheme.bodySmall?.copyWith(
                                                            fontWeight: FontWeight.w600,
                                                            color: context.isDarkMode ? AppColors.whiteColor : Colors.black,
                                                          ),
                                                        ),
                                                        5.widthBox,
                                                        SvgPicture.asset(
                                                          AppAssets.playIcon,
                                                          width: 13.w,
                                                          height: 14.h,
                                                          color: context.isDarkMode ? AppColors.whiteColor : Colors.black,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          5.heightBox,
                                        ],
                                      ),
                                    )
                                  : CourseCard(
                                      width: 389.w,

                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          RoundedNetworkImage(
                                            imageUrl: "$awsFilesUrl${data.audioImage}",
                                            width: double.infinity,
                                            height: 110.h,
                                            fit: BoxFit.cover,
                                            borderRadius: 20,
                                          ),
                                          12.heightBox,
                                          Text(
                                            formatString(data.audioTitle ?? "", capitalizeWords: false),

                                            maxLines: 2,
                                            style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
                                          ),
                                          15.heightBox,
                                          Row(
                                            children: [
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    ctx?.push(Routes.fenceInteractionCallView, extra: data);
                                                    controller.addViewDetailsPts();
                                                    homeController.markStreakForToday();
                                                  },
                                                  child: Container(
                                                    height: 40.h,
                                                    width: 170.w,
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius: BorderRadius.circular(100),
                                                      border: Border.all(color: AppColors.primary, width: 1),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        AppString.learnMore,
                                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                          fontWeight: FontWeight.w600,
                                                          color: context.isDarkMode ? AppColors.whiteColor : AppColors.primary,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              10.widthBox,
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    ctx?.push(Routes.fenceInteractionCallView, extra: data);
                                                    controller.addPlaySoundPts();
                                                    homeController.markStreakForToday();
                                                  },
                                                  child: Container(
                                                    height: 40.h,
                                                    width: 170.w,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.primary,
                                                      borderRadius: BorderRadius.circular(100),
                                                      border: Border.all(color: AppColors.primary, width: 1),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          AppString.playSound,
                                                          style: context.textTheme.bodySmall?.copyWith(
                                                            fontWeight: FontWeight.w600,
                                                            color: context.isDarkMode ? Colors.black : AppColors.whiteColor,
                                                          ),
                                                        ),
                                                        5.widthBox,
                                                        SvgPicture.asset(
                                                          AppAssets.playIcon,
                                                          width: 13.w,
                                                          height: 14.h,
                                                          color: index < 2
                                                              ? AppColors.whiteColor
                                                              : context.isDarkMode
                                                              ? Colors.black
                                                              : AppColors.whiteColor,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          5.heightBox,
                                        ],
                                      ),
                                    ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
