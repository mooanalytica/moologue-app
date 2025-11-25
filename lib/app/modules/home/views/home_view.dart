import 'dart:ui';

import 'package:flutter/material.dart';
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
import 'package:moo_logue/app/core/storage/get_storage.dart';
import 'package:moo_logue/app/core/storage/quiz_storage.dart';
import 'package:moo_logue/app/modules/home/controllers/bottom_bar_controller.dart';
import 'package:moo_logue/app/modules/home/controllers/home_controller.dart';
import 'package:moo_logue/app/modules/home/controllers/quiz_view_controller.dart';
import 'package:moo_logue/app/modules/home/widgets/glass_effect_view.dart';
import 'package:moo_logue/app/modules/home/widgets/normal_conatiner.dart';
import 'package:moo_logue/app/modules/home/widgets/shimmer_widget.dart';
import 'package:moo_logue/app/routes/app_routes.dart';
import 'package:moo_logue/app/routes/index.js.dart';
import 'package:moo_logue/app/utils/common_function.dart';
import 'package:moo_logue/app/widgets/common_home_app_bar.dart';
import 'package:moo_logue/app/widgets/custom_button.dart';
import 'package:moo_logue/app/widgets/rounded_asset_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moo_logue/app/model/quiz_model.dart';
import 'package:moo_logue/app/utils/quiz_generate_screen.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final controller = Get.put(HomeController());
  final bottomController = Get.find<BottomBarController>();
  final QuizStorage _quizStorage = QuizStorage();
  final QuizViewController quizViewController = QuizViewController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AppStorage.setString(AppStorage.typeState, TypeState.mainCategory.toString());
      await controller.fetchCategories();
      await controller.fetchSubCategories();
      await controller.getCurrentUserData();
      // Load or generate the global quiz session in the background
      final session = _quizStorage.loadSession();
      if (session == null || session.completed) {
        await quizViewController.generateGlobalQuizSession();
        quizViewController.globalSession = _quizStorage.loadSession();
      } else {
        quizViewController.globalSession = session;
      }
      if (mounted) {
        setState(() {
          quizViewController.sessionLoading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Replace all _inProgress usages with _globalSession
    // Only show the global session if it exists
    // if ( quizViewController.sessionLoading) {
    //   return Center(child: CircularProgressIndicator());
    // }
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          appBar: CustomHomeAppBar(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.heightBox,

                /// Top Poster
                Container(
                  height: 156.h,
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 20.w),

                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            10.heightBox,
                            Text(
                              'New Sound Catalog',
                              style: context.textTheme.headlineMedium?.copyWith(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                              ),
                            ),
                            10.heightBox,
                            Expanded(
                              child: Text(
                                'Tap to explore the latest sounds and discover what’s new and exciting!',

                                style: context.textTheme.bodySmall?.copyWith(color: AppColors.whiteColor),
                              ),
                            ),
                            10.heightBox,
                            GestureDetector(
                              onTap: () {
                                bottomController.currentIndex.value = 1;
                                ctx?.push(Routes.learnListeningView);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                                decoration: BoxDecoration(
                                  color: context.theme.canvasColor,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  'Explore',
                                  style: context.textTheme.titleLarge?.copyWith(
                                    color: context.isDarkMode ? AppColors.whiteColor : AppColors.primary,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ),
                            10.heightBox,
                          ],
                        ),
                      ),
                      20.widthBox,
                      RoundedAssetImage(
                        imagePath: AppAssets.homeBanner,
                        width: 150.w,
                        height: 156.h,
                        borderRadiusMain: BorderRadius.horizontal(
                          right: Radius.circular(10),
                          left: Radius.circular(25),
                        ),
                      ),
                    ],
                  ),
                ).paddingSymmetric(horizontal: AppSize.horizontalPadding),
                35.heightBox,

                /// Streak Container
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
                  child: context.isDarkMode
                      ? GlassEffectScreen(
                          width: 390.w,
                          height: 176.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'This Weeks Streak',
                                style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              16.heightBox,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                  controller.weeklyStreak.length,
                                  (index) => buildStreakCircle(controller.weeklyStreak[index], context),
                                ),
                              ),
                              16.heightBox,
                              CustomButton(
                                text: 'Start today’s lesson',
                                onTap: () {
                                  // Update bottom bar selection to 'Learn' tab

                                  bottomController.currentIndex.value = 1;

                                  // Then navigate
                                  ctx?.push(Routes.learnListeningView);
                                },
                                height: 40.h,
                                fontWeight: FontWeight.w600,
                                textSize: 12.sp,
                              ),
                            ],
                          ),
                        )
                      : CourseCard(
                          width: 390.w,
                          height: 174.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'This Weeks Streak',
                                style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              16.heightBox,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                  controller.weeklyStreak.length,
                                  (index) => buildStreakCircle(controller.weeklyStreak[index], context),
                                ),
                              ),
                              16.heightBox,
                              CustomButton(
                                text: 'Start today’s lesson',
                                onTap: () {
                                  bottomController.currentIndex.value = 1;

                                  ctx?.push(Routes.learnListeningView);
                                },
                                height: 40.h,
                                fontWeight: FontWeight.w600,
                                textSize: 12.sp,
                              ),
                            ],
                          ),
                        ),
                ),
                35.heightBox,

                /// Continue Quiz (from storage)
                if (quizViewController.globalSession != null && !quizViewController.globalSession!.completed) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
                    child: Text(
                      'Continue Quiz',
                      style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 18.sp),
                    ),
                  ),
                  16.heightBox,
                  SizedBox(
                    height: 275.h,
                    child: ListView.builder(
                      itemCount: 1,
                      padding: EdgeInsets.only(left: AppSize.horizontalPadding),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final session = quizViewController.globalSession!;
                        final progress =
                            session.selectedAnswers.length / (session.questions.isEmpty ? 1 : session.questions.length);
                        return Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: context.isDarkMode
                              ? GlassEffectScreen(
                                  width: 390.w,
                                  height: 310.h,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RoundedAssetImage(
                                        imagePath: 'assets/temp/temp_cow_image.png',
                                        width: double.infinity,
                                        height: 98.h,
                                        fit: BoxFit.cover,
                                        borderRadius: 20,
                                      ),
                                      20.heightBox,
                                      Text(
                                        'Moo Basics',
                                        style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
                                      ),
                                      6.heightBox,
                                      Text(
                                        'Happy Moos on a Farm',
                                        style: context.textTheme.titleLarge?.copyWith(fontSize: 14.sp),
                                      ),
                                      16.heightBox,
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(2),
                                        child: LinearProgressIndicator(
                                          value: progress.clamp(0.0, 1.0),
                                          backgroundColor: AppColors.sliderColor.withValues(alpha: 0.5),
                                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                          minHeight: 4.h,
                                        ),
                                      ),
                                      20.heightBox,
                                      CustomButton(
                                        text: AppString.continueLbl,
                                        onTap: () {
                                          context.push(Routes.quizView);
                                        },
                                        height: 40.h,
                                        fontWeight: FontWeight.w600,
                                        textSize: 12.sp,
                                      ),
                                    ],
                                  ),
                                )
                              : CourseCard(
                                  width: 390.w,
                                  height: 310.h,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RoundedAssetImage(
                                        imagePath: 'assets/temp/temp_cow_image.png',
                                        width: double.infinity,
                                        height: 100.h,
                                        fit: BoxFit.cover,
                                        borderRadius: 20,
                                      ),
                                      20.heightBox,
                                      Text(
                                        'Moo Basics',
                                        style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
                                      ),
                                      6.heightBox,
                                      // Text(
                                      //   'Level 1',
                                      //   style: context.textTheme.titleSmall,
                                      // ),
                                      // 6.heightBox,
                                      Text(
                                        'Happy Moos on a Farm',
                                        style: context.textTheme.titleLarge?.copyWith(fontSize: 14.sp),
                                      ),
                                      16.heightBox,
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(2),
                                        child: LinearProgressIndicator(
                                          value: progress.clamp(0.0, 1.0),
                                          backgroundColor: AppColors.sliderColor.withValues(alpha: 0.5),
                                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                          minHeight: 4.h,
                                        ),
                                      ),
                                      20.heightBox,
                                      CustomButton(
                                        text: AppString.continueLbl,
                                        onTap: () {
                                          context.push(Routes.quizView);
                                        },
                                        height: 40.h,
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
                  35.heightBox,
                ],

                /// Discover
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Discover',
                      style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 18.sp),
                    ).paddingSymmetric(horizontal: AppSize.horizontalPadding),
                    16.heightBox,

                    ///---------------------------------- DISCOVER MAINCATEGORY--------------------------------------
                    SizedBox(
                      height: 260.h,

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
                                style: TextStyle(
                                  fontSize: 16,
                                  color: context.isDarkMode ? AppColors.whiteColor : Colors.grey,
                                ),
                              ),
                            );
                          }

                          final data = controller.categories[index];

                          return Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: context.isDarkMode
                                ? GestureDetector(
                                    onTap: () async {
                                      await AppStorage.setString(
                                        AppStorage.typeState,
                                        TypeState.subCategory.toString(),
                                      );

                                      ctx?.push(
                                        Routes.subcategoryListView,
                                        extra: {
                                          'id': data.docId,
                                          'name': data.mainCategory,
                                          'desc': data.mainCategoryDec,
                                        },
                                      );
                                      // ctx?.push(Routes.emotionalCallsView,extra: {'id':data.docId,'name':data.subCategory});
                                    },
                                    child: GlassEffectScreen(
                                      width: 250.w,
                                      height: 200.h,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // RoundedAssetImage(
                                          //   imagePath: AppAssets.emotionalOneImage,
                                          //   width: double.infinity,
                                          //   height: 94.h,
                                          //
                                          //   fit: BoxFit.fill,
                                          //   borderRadius: 25,
                                          // ),
                                          RoundedNetworkImage(
                                            imageUrl: "$awsFilesUrl${data.mainCategoryImage}",
                                            width: double.infinity,
                                            height: 94.h,

                                            fit: BoxFit.fill,
                                            borderRadius: 25,
                                          ),
                                          20.heightBox,
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
                                              await AppStorage.setString(
                                                AppStorage.typeState,
                                                TypeState.subCategory.toString(),
                                              );

                                              ctx?.push(
                                                Routes.subcategoryListView,
                                                extra: {
                                                  'id': data.docId,
                                                  'name': data.mainCategory,
                                                  'desc': data.mainCategoryDec,
                                                },
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
                                                SvgPicture.asset(AppAssets.rightLongArrow,color: AppColors.primary,),
                                              ],
                                            ),
                                          ),
                                          10.heightBox,
                                        ],
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () async {
                                      await AppStorage.setString(
                                        AppStorage.typeState,
                                        TypeState.subCategory.toString(),
                                      );

                                      ctx?.push(
                                        Routes.subcategoryListView,
                                        extra: {
                                          'id': data.docId,
                                          'name': data.mainCategory,
                                          'desc': data.mainCategoryDec,
                                        },
                                      );
                                      // ctx?.push(Routes.emotionalCallsView,extra: {'id':data.docId,'name':data.subCategory});
                                    },
                                    child: CourseCard(
                                      width: 250.w,
                                      height: 200.h,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          RoundedNetworkImage(
                                            imageUrl: "$awsFilesUrl${data.mainCategoryImage}",
                                            width: double.infinity,
                                            height: 94.h,

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
                                          10.heightBox,
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
                                              await AppStorage.setString(
                                                AppStorage.typeState,
                                                TypeState.subCategory.toString(),
                                              );

                                              ctx?.push(
                                                Routes.subcategoryListView,
                                                extra: {
                                                  'id': data.docId,
                                                  'name': data.mainCategory,
                                                  'desc': data.mainCategoryDec,
                                                },
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
                                        ],
                                      ),
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),

                    ///---------------------------------- DISCOVER SUBCATEGORY--------------------------------------
                    // SizedBox(
                    //   height: 300.h,
                    //
                    //   child: ListView.builder(
                    //     itemCount: controller.subcategories.length,
                    //     shrinkWrap: true,
                    //     padding: EdgeInsets.only(left: AppSize.horizontalPadding),
                    //     scrollDirection: Axis.horizontal,
                    //     itemBuilder: (context, index) {
                    //       if (controller.isLoading.value == true) {
                    //         return const Center(child: CircularProgressIndicator());
                    //       }
                    //       if (controller.subcategories.isEmpty) {
                    //         return Center(
                    //           child: Text(
                    //             "No subcategories found",
                    //             style: TextStyle(fontSize: 16, color: context.isDarkMode ? AppColors.whiteColor : Colors.grey),
                    //           ),
                    //         );
                    //       }
                    //
                    //       final data = controller.subcategories[index];
                    //       debugPrint('data.subCategory==========>>>>>${data.subCategory}');
                    //       return Padding(
                    //         padding: const EdgeInsets.only(right: 20),
                    //         child: context.isDarkMode
                    //             ? GestureDetector(
                    //                 onTap: () {
                    //                   bottomController.currentIndex.value = 1;
                    //                   ctx?.push(Routes.emotionalCallsView,extra: {'id':data.docId,'name':data.subCategory});
                    //                 },
                    //                 child: GlassEffectScreen(
                    //                   width: 250.w,
                    //                   height: 200.h,
                    //                   child: Column(
                    //                     crossAxisAlignment: CrossAxisAlignment.start,
                    //                     children: [
                    //                       RoundedNetworkImage(
                    //                         imageUrl: "$awsFilesUrl${data.attachments?[0]}",
                    //                         width: double.infinity,
                    //                         height: 94.h,
                    //
                    //                         fit: BoxFit.fill,
                    //                         borderRadius: 25,
                    //                       ),
                    //                       20.heightBox,
                    //                       Text(
                    //                         formatString(data.subCategory ?? "", capitalizeWords: false),
                    //                         maxLines: 2,
                    //                         style: context.textTheme.headlineMedium?.copyWith(
                    //                           fontWeight: FontWeight.w600,
                    //                           overflow: TextOverflow.ellipsis,
                    //                         ),
                    //                       ),
                    //                       6.heightBox,
                    //                       Text(
                    //                         data.description ?? "",
                    //                         maxLines: 3,
                    //                         style: context.textTheme.titleSmall?.copyWith(
                    //                           overflow: TextOverflow.ellipsis,
                    //                           fontWeight: FontWeight.w400,
                    //                         ),
                    //                       ),
                    //
                    //                       20.heightBox,
                    //                       GestureDetector(
                    //                         onTap: () {
                    //                           bottomController.currentIndex.value = 1;
                    //                           ctx?.push(Routes.emotionalCallsView,extra: {'id':data.docId,'name':data.subCategory});
                    //                         },
                    //                         child: Row(
                    //                           children: [
                    //                             Text(
                    //                               'Read more',
                    //                               maxLines: 3,
                    //                               style: context.textTheme.bodySmall?.copyWith(
                    //                                 fontWeight: FontWeight.w600,
                    //                                 color: AppColors.primary,
                    //                               ),
                    //                             ),
                    //                             10.widthBox,
                    //                             SvgPicture.asset(AppAssets.rightLongArrow),
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               )
                    //             : GestureDetector(
                    //                 onTap: () {
                    //                   bottomController.currentIndex.value = 1;
                    //                   ctx?.push(Routes.emotionalCallsView,extra: {'id':data.docId,'name':data.subCategory});
                    //                 },
                    //                 child: CourseCard(
                    //                   width: 250.w,
                    //                   height: 200.h,
                    //                   child: Column(
                    //                     crossAxisAlignment: CrossAxisAlignment.start,
                    //                     children: [
                    //                       RoundedNetworkImage(
                    //                         imageUrl: "$awsFilesUrl${data.attachments?[0]}",
                    //                         width: double.infinity,
                    //                         height: 94.h,
                    //
                    //                         fit: BoxFit.fill,
                    //                         borderRadius: 25,
                    //                       ),
                    //                       10.heightBox,
                    //                       Text(
                    //                         formatString(data.subCategory ?? "", capitalizeWords: false),
                    //                         maxLines: 2,
                    //                         style: context.textTheme.headlineMedium?.copyWith(
                    //                           fontWeight: FontWeight.w600,
                    //                           overflow: TextOverflow.ellipsis,
                    //                         ),
                    //                       ),
                    //                       6.heightBox,
                    //                       Text(
                    //                         data.description ?? "",
                    //                         maxLines: 3,
                    //                         style: context.textTheme.titleSmall?.copyWith(
                    //                           overflow: TextOverflow.ellipsis,
                    //                           fontWeight: FontWeight.w400,
                    //                         ),
                    //                       ),
                    //
                    //                       20.heightBox,
                    //                       GestureDetector(
                    //                         onTap: () {
                    //                           bottomController.currentIndex.value = 1;
                    //                           ctx?.push(Routes.emotionalCallsView,extra: {'id':data.docId,'name':data.subCategory});
                    //                         },
                    //                         child: Row(
                    //                           children: [
                    //                             Text(
                    //                               'Read more',
                    //                               maxLines: 3,
                    //                               style: context.textTheme.bodySmall?.copyWith(
                    //                                 fontWeight: FontWeight.w600,
                    //                                 color: AppColors.primary,
                    //                               ),
                    //                             ),
                    //                             10.widthBox,
                    //                             SvgPicture.asset(AppAssets.rightLongArrow),
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ),
                    //       );
                    //     },
                    //   ),
                    // ),
                  ],
                ),
                35.heightBox,
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget buildStreakCircle(DayStreak streak, BuildContext context) {
  //   Color fillColor;
  //   Color borderColor;
  //   Color iconColor;
  //
  //   switch (streak.status) {
  //     case StreakStatus.past:
  //       fillColor = const Color(0xFF367A23);
  //       borderColor = Colors.transparent;
  //       iconColor = Colors.white;
  //       break;
  //     case StreakStatus.current:
  //       fillColor = const Color(0xFFA4D23B).withValues(alpha: 0.10);
  //       borderColor = const Color(0xFFA4D23B);
  //       iconColor = const Color(0xFFE7F0DA);
  //       break;
  //     case StreakStatus.future:
  //       fillColor = Colors.transparent;
  //       borderColor = const Color(0xFFE7F0DA);
  //       iconColor = const Color(0xFFE7F0DA);
  //       break;
  //   }
  //
  //   return Column(
  //     children: [
  //       Container(
  //         height: 35.h,
  //         width: 35.h,
  //         decoration: BoxDecoration(
  //           color: fillColor,
  //           border: Border.all(color: borderColor),
  //           shape: BoxShape.circle,
  //         ),
  //         padding: EdgeInsets.all(7),
  //         child: Center(
  //           child: SvgPicture.asset(AppAssets.wheatIcon, colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn)),
  //         ),
  //       ),
  //       2.heightBox,
  //       Text(streak.day, style: context.textTheme.labelMedium),
  //     ],
  //   );
  // }
  Widget buildStreakCircle(DayStreak streak, BuildContext context) {
    Color fillColor;
    Color borderColor;
    Color iconColor;

    switch (streak.status) {
      case StreakStatus.past:
        fillColor = const Color(0xFF04cc32);
        borderColor = Colors.transparent;
        iconColor = Colors.white;
        break;
      case StreakStatus.current:
        fillColor = const Color(0xFF04cc32).withOpacity(0.1);
        borderColor = const Color(0xFF04cc32);
        iconColor = const Color(0xFFE7F0DA);
        break;
      case StreakStatus.future:
        fillColor = Colors.transparent;
        borderColor = const Color(0xFFE7F0DA);
        iconColor = const Color(0xFFE7F0DA);
        break;
    }

    return Column(
      children: [
        Container(
          height: 35.h,
          width: 35.h,
          decoration: BoxDecoration(
            color: fillColor,
            border: Border.all(color: borderColor),
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(7),
          child: Center(
            child: SvgPicture.asset(AppAssets.wheatIcon, colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn)),
          ),
        ),
        2.heightBox,
        Text(streak.day, style: context.textTheme.labelMedium),
      ],
    );
  }
}
