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

import 'package:moo_logue/app/core/extention/sized_box_extention.dart';
import 'package:moo_logue/app/core/storage/get_storage.dart';
import 'package:moo_logue/app/modules/home/controllers/bottom_bar_controller.dart';
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

class SubcategoryListView extends StatefulWidget {
  const SubcategoryListView({super.key, required this.id, required this.name, required this.desc});
  final String id;
  final String name;
  final String desc;

  @override
  State<SubcategoryListView> createState() => _SubcategoryListViewState();
}

class _SubcategoryListViewState extends State<SubcategoryListView> {
  final controller = Get.put(EmotionalCallsController());
  final cntBtm = Get.put(BottomBarController());
  final homeController = Get.find<HomeController>();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.fetchIdSubCategories(id: widget.id);
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // cntBtm.currentIndex.value = 0;
    });

    super.dispose();
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
                      : controller.subIdCategories.isEmpty
                      ? Center(child: Text("No data available"))
                      : ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: controller.subIdCategories.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            final data = controller.subIdCategories[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: context.isDarkMode
                                  ? GestureDetector(
                                      onTap: () async {
                                        await AppStorage.setString(AppStorage.typeState, TypeState.audio.toString());
                                        ctx?.push(
                                          Routes.emotionalCallsView,
                                          extra: {'id': data.docId, 'name': data.subCategory},
                                        );
                                      },
                                      child: GlassEffectScreen(
                                        width: 389.w,
                                        height: 240.h,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            RoundedNetworkImage(
                                              imageUrl: "$awsFilesUrl${data.attachments?[0]}",
                                              width: double.infinity,
                                              height: 110.h,
                                              fit: BoxFit.cover,
                                              borderRadius: 20,
                                            ),
                                            12.heightBox,
                                            Text(
                                              formatString(data.subCategory ?? "", capitalizeWords: false),
                                              maxLines: 1,
                                              style: context.textTheme.headlineMedium?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            6.heightBox,
                                            if (data.subCategoryDec?.isEmpty ?? true)
                                              Text(
                                                // data.description ?? "",
                                                "How researchers are decoding cow vocalizations — and what it means for animal welfare and the future of farming.",

                                                maxLines: 2,
                                                style: context.textTheme.labelMedium?.copyWith(
                                                  overflow: TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            if (data.subCategoryDec?.isNotEmpty ?? true)
                                              Text(
                                                data.subCategoryDec ?? "",

                                                // "How researchers are decoding cow vocalizations — and what it means for animal welfare and the future of farming.",
                                                maxLines: 2,
                                                style: context.textTheme.labelMedium?.copyWith(
                                                  overflow: TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            Spacer(),
                                            GestureDetector(
                                              onTap: () async {
                                                await AppStorage.setString(
                                                  AppStorage.typeState,
                                                  TypeState.audio.toString(),
                                                );
                                                ctx?.push(
                                                  Routes.emotionalCallsView,
                                                  extra: {'id': data.docId, 'name': data.subCategory},
                                                );
                                                homeController.markStreakForToday();
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Read more',
                                                    maxLines: 3,
                                                    style: context.textTheme.bodySmall?.copyWith(
                                                      fontWeight: FontWeight.w600,
                                                      color: AppColors.primary,
                                                    ),
                                                  ),
                                                  10.widthBox,
                                                  SvgPicture.asset(AppAssets.rightLongArrow,color:  AppColors.primary,),
                                                ],
                                              ),
                                            ),

                                            5.heightBox,
                                          ],
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () async {
                                        await AppStorage.setString(AppStorage.typeState, TypeState.audio.toString());
                                        ctx?.push(
                                          Routes.emotionalCallsView,
                                          extra: {'id': data.docId, 'name': data.subCategory},
                                        );
                                        homeController.markStreakForToday();
                                      },
                                      child: CourseCard(
                                        width: 389.w,

                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            RoundedNetworkImage(
                                              imageUrl: "$awsFilesUrl${data.attachments?[0]}",
                                              width: double.infinity,
                                              height: 110.h,
                                              fit: BoxFit.cover,
                                              borderRadius: 20,
                                            ),
                                            12.heightBox,
                                            Text(
                                              formatString(data.subCategory ?? "", capitalizeWords: false),

                                              maxLines: 2,
                                              style: context.textTheme.headlineMedium?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            6.heightBox,
                                            if (data.subCategoryDec?.isEmpty ?? true)
                                              Text(
                                                // data.description ?? "",
                                                "How researchers are decoding cow vocalizations — and what it means for animal welfare and the future of farming.",

                                                maxLines: 2,
                                                style: context.textTheme.labelMedium?.copyWith(
                                                  overflow: TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            if (data.subCategoryDec?.isNotEmpty ?? true)
                                              Text(
                                                data.subCategoryDec ?? "",

                                                // "How researchers are decoding cow vocalizations — and what it means for animal welfare and the future of farming.",
                                                maxLines: 2,
                                                style: context.textTheme.labelMedium?.copyWith(
                                                  overflow: TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            15.heightBox,
                                            GestureDetector(
                                              onTap: () async {
                                                await AppStorage.setString(
                                                  AppStorage.typeState,
                                                  TypeState.audio.toString(),
                                                );
                                                ctx?.push(
                                                  Routes.emotionalCallsView,
                                                  extra: {'id': data.docId, 'name': data.subCategory},
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Read more',
                                                    maxLines: 3,
                                                    style: context.textTheme.bodySmall?.copyWith(
                                                      fontWeight: FontWeight.w600,
                                                      color: AppColors.primary,
                                                    ),
                                                  ),
                                                  10.widthBox,
                                                  SvgPicture.asset(AppAssets.rightLongArrow),
                                                ],
                                              ),
                                            ),
                                            5.heightBox,
                                          ],
                                        ),
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
