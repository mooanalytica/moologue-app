import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:moo_logue/app/core/constants/app_assets.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
import 'package:moo_logue/app/core/constants/app_const.dart';
import 'package:moo_logue/app/core/constants/app_sizes.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';
import 'package:moo_logue/app/core/extention/sized_box_extention.dart';
import 'package:moo_logue/app/core/storage/get_storage.dart';
import 'package:moo_logue/app/modules/home/controllers/home_controller.dart';
import 'package:moo_logue/app/modules/home/controllers/learn_listening_controller.dart';
import 'package:moo_logue/app/modules/home/views/quiz_view.dart';
import 'package:moo_logue/app/modules/home/widgets/glass_effect_view.dart';
import 'package:moo_logue/app/modules/home/widgets/normal_conatiner.dart';
import 'package:moo_logue/app/modules/home/widgets/shimmer_widget.dart';
import 'package:moo_logue/app/routes/app_routes.dart';
import 'package:moo_logue/app/routes/index.js.dart';
import 'package:moo_logue/app/utils/common_function.dart';
import 'package:moo_logue/app/widgets/common_home_app_bar.dart';
import 'package:moo_logue/app/widgets/custom_button.dart';
import 'package:moo_logue/app/widgets/rounded_asset_image.dart';

class LearnListeningView extends StatefulWidget {
  const LearnListeningView({super.key});

  @override
  State<LearnListeningView> createState() => _LearnListeningViewState();
}

class _LearnListeningViewState extends State<LearnListeningView> {
  final controller = Get.put(LearnListeningController());

  final homeController = Get.put(HomeController());
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await homeController.fetchCategories(page: 0);
      await homeController.fetchSubCategories();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomHomeAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          25.heightBox,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
            child: Text(AppString.learnByListening, style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600)),
          ),
          16.heightBox,

          GetBuilder<HomeController>(
            builder: (controller) => SizedBox(
              height: 250.h,
              child: ListView.builder(
                itemCount: controller.categories.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(left: AppSize.horizontalPadding),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  if (controller.isLoading.value == true) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: EmptyShimmer(width: 250.w, height: 225.h),
                    );
                  }
                  if (controller.categories.isEmpty) {
                    return Center(
                      child: Text(
                        "No categories found",
                        style: TextStyle(fontSize: 16, color: context.isDarkMode ? AppColors.whiteColor : Colors.grey),
                      ),
                    );
                  }

                  final data = controller.categories[index];
                  log('data==========>>>>>${data.mainCategoryDec}');

                  return Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: context.isDarkMode
                        ? GestureDetector(
                            onTap: () async {
                              await AppStorage.setString(AppStorage.typeState, TypeState.subCategory.toString());
                              ctx?.push(
                                Routes.subcategoryListView,
                                extra: {'id': data.docId, 'name': data.mainCategory, 'desc': data.mainCategoryDec},
                              );
                            },
                            child: GlassEffectScreen(
                              width: 250.w,
                              height: 215.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RoundedNetworkImage(
                                    imageUrl: "$awsFilesUrl${data.mainCategoryImage}",
                                    width: double.infinity,
                                    height: 100.h,

                                    fit: BoxFit.fill,
                                    borderRadius: 25,
                                  ),
                                  // RoundedAssetImage(
                                  //   imagePath: AppAssets.emotionalOneImage,
                                  //   width: double.infinity,
                                  //   height: 94.h,
                                  //
                                  //   fit: BoxFit.fill,
                                  //   borderRadius: 25,
                                  // ),
                                  6.heightBox,
                                  Text(
                                    formatString(data.mainCategory ?? "", capitalizeWords: false),
                                    maxLines: 2,
                                    style: context.textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  6.heightBox,
                                  if (data.mainCategoryDec?.isEmpty ?? true)
                                    Text(
                                      "How researchers are decoding cow vocalizations — and what it means for animal welfare and the future of farming.",

                                      maxLines: 2,

                                      style: context.textTheme.titleSmall?.copyWith(
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  if (data.mainCategoryDec?.isNotEmpty ?? true)
                                    Text(
                                      data.mainCategoryDec ??
                                          "How researchers are decoding cow vocalizations — and what it means for animal welfare and the future of farming.",

                                      maxLines: 2,

                                      style: context.textTheme.titleSmall?.copyWith(
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      await AppStorage.setString(AppStorage.typeState, TypeState.subCategory.toString());

                                      ctx?.push(
                                        Routes.subcategoryListView,
                                        extra: {'id': data.docId, 'name': data.mainCategory, 'desc': data.mainCategoryDec},
                                      );
                                      // ctx?.push(Routes.emotionalCallsView,extra: {'id':data.docId,'name':data.subCategory});
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
                                  10.heightBox,
                                  // 6.heightBox,
                                  // Text(
                                  //   // data.description ?? "",
                                  //   "A closer look at the gentle, powerful vocal bond between mother cows and their newborns.",
                                  //
                                  //   maxLines: 2,
                                  //   style: context.textTheme.titleSmall?.copyWith(
                                  //     overflow: TextOverflow.ellipsis,
                                  //     fontWeight: FontWeight.w400,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              await AppStorage.setString(AppStorage.typeState, TypeState.subCategory.toString());
                              ctx?.push(
                                Routes.subcategoryListView,
                                extra: {'id': data.docId, 'name': data.mainCategory, 'desc': data.mainCategoryDec},
                              );
                            },
                            child: CourseCard(
                              width: 250.w,
                              height: 225.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RoundedNetworkImage(
                                    imageUrl: "$awsFilesUrl${data.mainCategoryImage}",
                                    width: double.infinity,
                                    height: 100.h,

                                    fit: BoxFit.fill,
                                    borderRadius: 25,
                                  ),
                                  // RoundedAssetImage(
                                  //   imagePath: AppAssets.emotionalOneImage,
                                  //   width: double.infinity,
                                  //   height: 94.h,
                                  //
                                  //   fit: BoxFit.fill,
                                  //   borderRadius: 25,
                                  // ),
                                  6.heightBox,
                                  Text(
                                    formatString(data.mainCategory ?? "", capitalizeWords: false),
                                    maxLines: 2,
                                    style: context.textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  6.heightBox,
                                  if (data.mainCategoryDec?.isEmpty ?? true)
                                    Text(
                                      "How researchers are decoding cow vocalizations — and what it means for animal welfare and the future of farming.",

                                      maxLines: 2,

                                      style: context.textTheme.titleSmall?.copyWith(
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  if (data.mainCategoryDec?.isNotEmpty ?? true)
                                    Text(
                                      data.mainCategoryDec ??
                                          "How researchers are decoding cow vocalizations — and what it means for animal welfare and the future of farming.",

                                      maxLines: 2,

                                      style: context.textTheme.titleSmall?.copyWith(
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      await AppStorage.setString(AppStorage.typeState, TypeState.subCategory.toString());

                                      ctx?.push(
                                        Routes.subcategoryListView,
                                        extra: {'id': data.docId, 'name': data.mainCategory, 'desc': data.mainCategoryDec},
                                      );
                                      // ctx?.push(Routes.emotionalCallsView,extra: {'id':data.docId,'name':data.subCategory});
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
                                  10.heightBox,
                                  // 6.heightBox,
                                  // Text(
                                  //   // data.description ?? "",
                                  //   "A closer look at the gentle, powerful vocal bond between mother cows and their newborns.",
                                  //
                                  //   maxLines: 2,
                                  //   style: context.textTheme.titleSmall?.copyWith(
                                  //     overflow: TextOverflow.ellipsis,
                                  //     fontWeight: FontWeight.w400,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                  );
                },
              ),
            ),
          ),
          16.heightBox,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
            child: Text(AppString.quizMe, style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600)),
          ),
          16.heightBox,
          SizedBox(
            height: 255.h,
            child: ListView.builder(
              itemCount: controller.learnListeningTwo.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(left: AppSize.horizontalPadding),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: context.isDarkMode
                      ? GlassEffectScreen(
                          width: 390.w,
                          height: 261.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RoundedAssetImage(
                                imagePath: AppAssets.quizMeImage,
                                width: double.infinity,
                                height: 100.h,
                                fit: BoxFit.cover,
                                borderRadius: 20,
                              ),
                              16.heightBox,
                              Text(AppString.mooBasics, style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600)),
                              6.heightBox,
                              // Text(
                              //   "${controller.learnListeningTwo[index]['LevelNumber']}",
                              //   style: context.textTheme.titleSmall,
                              // ),
                              // 6.heightBox,
                              Text(
                                "${controller.learnListeningTwo[index]['LevelDisc']}",
                                style: context.textTheme.titleLarge?.copyWith(fontSize: 14.sp),
                              ),
                              16.heightBox,
                              // index == 1
                              //     ? Padding(
                              //         padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding, vertical: 10),
                              //         child: Row(
                              //           children: [
                              //             SvgPicture.asset(
                              //               AppAssets.starIcon,
                              //               height: 16.h,
                              //               width: 16.w,
                              //               color: context.isDarkMode ? AppColors.whiteColor : AppColors.primary,
                              //             ),
                              //             10.widthBox,
                              //             Text(
                              //               AppString.levelPercentage,
                              //               style: context.textTheme.titleLarge?.copyWith(
                              //                 fontSize: 12.sp,
                              //                 color: context.isDarkMode ? AppColors.whiteColor : AppColors.primary,
                              //               ),
                              //             ),
                              //             Spacer(),
                              //             Text(
                              //               AppString.retackQuiz,
                              //               style: context.textTheme.titleLarge?.copyWith(
                              //                 fontSize: 12.sp,
                              //                 color: context.isDarkMode ? AppColors.whiteColor : AppColors.primary,
                              //               ),
                              //             ),
                              //             10.widthBox,
                              //             SvgPicture.asset(
                              //               AppAssets.rightLongArrowIcon,
                              //               height: 10.h,
                              //               width: 18.w,
                              //               color: context.isDarkMode ? AppColors.whiteColor : AppColors.primary,
                              //             ),
                              //           ],
                              //         ),
                              //       )
                              //     :
                              CustomButton(
                                text: AppString.startQuiz,
                                onTap: () {
                                  context.push(Routes.quizView, extra: 'global ${index + 1}');
                                },
                                height: 42.h,
                                fontWeight: FontWeight.w600,
                                textSize: 12.sp,
                              ),
                            ],
                          ),
                        )
                      : CourseCard(
                          width: 390.w,
                          height: 261.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RoundedAssetImage(
                                imagePath: AppAssets.quizMeImage,
                                width: double.infinity,
                                height: 100.h,
                                fit: BoxFit.cover,
                                borderRadius: 20,
                              ),
                              16.heightBox,
                              Text(AppString.mooBasics, style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600)),
                              6.heightBox,
                              // Text(
                              //   "${controller.learnListeningTwo[index]['LevelNumber']}",
                              //   style: context.textTheme.titleSmall,
                              // ),
                              // 6.heightBox,
                              Text(
                                "${controller.learnListeningTwo[index]['LevelDisc']}",
                                style: context.textTheme.titleLarge?.copyWith(fontSize: 14.sp),
                              ),
                              16.heightBox,
                              // index == 1
                              //     ? Padding(
                              //         padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding, vertical: 10),
                              //         child: Row(
                              //           children: [
                              //             SvgPicture.asset(
                              //               AppAssets.starIcon,
                              //               height: 16.h,
                              //               width: 16.w,
                              //               color: context.isDarkMode ? AppColors.whiteColor : AppColors.primary,
                              //             ),
                              //             10.widthBox,
                              //             Text(
                              //               AppString.levelPercentage,
                              //               style: context.textTheme.titleLarge?.copyWith(
                              //                 fontSize: 12.sp,
                              //                 color: context.isDarkMode ? AppColors.whiteColor : AppColors.primary,
                              //               ),
                              //             ),
                              //             Spacer(),
                              //             Text(
                              //               AppString.retackQuiz,
                              //               style: context.textTheme.titleLarge?.copyWith(
                              //                 fontSize: 12.sp,
                              //                 color: context.isDarkMode ? AppColors.whiteColor : AppColors.primary,
                              //               ),
                              //             ),
                              //             10.widthBox,
                              //             SvgPicture.asset(
                              //               AppAssets.rightLongArrowIcon,
                              //               height: 10.h,
                              //               width: 18.w,
                              //               color: context.isDarkMode ? AppColors.whiteColor : AppColors.primary,
                              //             ),
                              //           ],
                              //         ),
                              //       )
                              //     :
                              CustomButton(
                                text: AppString.startQuiz,
                                onTap: () {
                                  context.push(Routes.quizView, extra: 'global ${index + 1}');
                                },
                                height: 42.h,
                                fontWeight: FontWeight.w600,
                                textSize: 12.sp,
                              ),
                            ],
                          ),
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
