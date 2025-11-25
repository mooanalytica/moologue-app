import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:go_router/go_router.dart';
import 'package:moo_logue/app/core/constants/app_assets.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
import 'package:moo_logue/app/core/constants/app_const.dart';
import 'package:moo_logue/app/core/constants/app_sizes.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';
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
import 'package:moo_logue/app/widgets/custom_appbar.dart';
import 'package:moo_logue/app/widgets/custom_button.dart';
import 'package:moo_logue/app/widgets/rounded_asset_image.dart';

class SearchScreenView extends StatefulWidget {
  const SearchScreenView({super.key});

  @override
  State<SearchScreenView> createState() => _SearchScreenViewState();
}

class _SearchScreenViewState extends State<SearchScreenView> {
  final controller = Get.put(HomeController());
  final cntBtm = Get.put(BottomBarController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.type = AppStorage.getString(AppStorage.typeState);
      debugPrint('controller.type==========>>>>>${controller.type}');
      controller.categories.clear();
      controller.subcategories.clear();
      controller.audiosData.clear();
      controller.searchCnt.clear();
      controller.update();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    cntBtm.currentIndex.value = 0;
    controller.fetchCategories(page: 0);
    controller.fetchSubCategories(page: 0);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppbar(text: 'Search here'),
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: isDark ? AppColors.darkBorderColor : const Color(0xffE5E5E5)),
                  ),
                ),
              ),
              10.heightBox,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
                child: SearchBar(
                  controller: controller.searchCnt,
                  onChanged: (value) {
                    debugPrint(
                      'controller.type ==TypeState.mainCategory.toString()==========>>>>>${controller.type == TypeState.mainCategory.toString()}',
                    );
                    debugPrint('TypeState.mainCategory.toString()==========>>>>>${TypeState.mainCategory.toString()}');
                    debugPrint('controller.type==========>>>>>${controller.type}');
                    if (controller.type == TypeState.mainCategory.toString()) {
                      controller.categories.clear();
                      controller.searchCategories(value);
                      controller.update();
                    } else if (controller.type == TypeState.subCategory.toString()) {
                      controller.subcategories.clear();
                      controller.searchSubCategories(value);
                      controller.update();
                    } else {
                      controller.audiosData.clear();
                      controller.searchSubAudioCategories(value);
                      controller.update();
                    }
                    if (value.isEmpty) {
                      controller.categories.clear();
                      controller.subcategories.clear();
                      controller.audiosData.clear();
                    }
                  },
                ),
              ),

              10.heightBox,
              controller.type == TypeState.mainCategory.toString()
                  ? Expanded(
                      child: controller.isLoading.value == true
                          ? Center(child: showLoader())
                          : controller.categories.isEmpty
                          ? Center(child: Text("No data available"))
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: controller.categories.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  debugPrint('controller.isLoading.value==========>>>>>${controller.isLoading.value}');

                                  final data = controller.categories[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
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
                                            },
                                            child: GlassEffectScreen(
                                              width: 389.w,
                                              height: 250.h,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  RoundedAssetImage(
                                                    imagePath: AppAssets.emotionalOneImage,
                                                    width: double.infinity,
                                                    height: 94.h,

                                                    fit: BoxFit.fill,
                                                    borderRadius: 25,
                                                  ),
                                                  // RoundedNetworkImage(
                                                  //   imageUrl: "$awsFilesUrl${data.audioImage}",
                                                  //   width: double.infinity,
                                                  //   height: 110.h,
                                                  //   fit: BoxFit.cover,
                                                  //   borderRadius: 20,
                                                  // ),
                                                  12.heightBox,
                                                  Text(
                                                    formatString(data.mainCategory ?? "", capitalizeWords: false),
                                                    maxLines: 2,
                                                    style: context.textTheme.headlineMedium?.copyWith(
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),

                                                  6.heightBox,
                                                  if (data.mainCategoryDec?.isEmpty ?? true)
                                                    Text(
                                                      // data.description ?? "",
                                                      "How researchers are decoding cow vocalizations — and what it means for animal welfare and the future of farming.",

                                                      maxLines: 2,
                                                      style: context.textTheme.titleSmall?.copyWith(
                                                        overflow: TextOverflow.ellipsis,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  if (data.mainCategoryDec?.isNotEmpty ?? true)
                                                    Text(
                                                      data.mainCategoryDec ?? "",

                                                      // "How researchers are decoding cow vocalizations — and what it means for animal welfare and the future of farming.",
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
                                                          maxLines: 1,
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
                                            },
                                            child: CourseCard(
                                              width: 389.w,
                                              height: 250.h,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // RoundedNetworkImage(
                                                  //   imageUrl: "$awsFilesUrl${data.audioImage}",
                                                  //   width: double.infinity,
                                                  //   height: 110.h,
                                                  //   fit: BoxFit.cover,
                                                  //   borderRadius: 20,
                                                  // ),
                                                  RoundedAssetImage(
                                                    imagePath: AppAssets.emotionalOneImage,
                                                    width: double.infinity,
                                                    height: 94.h,

                                                    fit: BoxFit.fill,
                                                    borderRadius: 25,
                                                  ),
                                                  12.heightBox,
                                                  if (data.mainCategoryDec?.isEmpty ?? true)
                                                    Text(
                                                      // data.description ?? "",
                                                      "How researchers are decoding cow vocalizations — and what it means for animal welfare and the future of farming.",

                                                      maxLines: 2,
                                                      style: context.textTheme.titleSmall?.copyWith(
                                                        overflow: TextOverflow.ellipsis,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  if (data.mainCategoryDec?.isNotEmpty ?? true)
                                                    Text(
                                                      data.mainCategoryDec ?? "",

                                                      // "How researchers are decoding cow vocalizations — and what it means for animal welfare and the future of farming.",
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
                                                          maxLines: 1,
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
                    )
                  : controller.type == TypeState.subCategory.toString()
                  ? Expanded(
                      child: controller.isLoading.value == true
                          ? Center(child: showLoader())
                          : controller.subcategories.isEmpty
                          ? Center(child: Text("No data available"))
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: controller.subcategories.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  final data = controller.subcategories[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: context.isDarkMode
                                        ? GestureDetector(
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
                                                  // Text(
                                                  //   formatString(data.description ?? "", capitalizeWords: false),
                                                  //   maxLines: 2,
                                                  //   style: context.textTheme.labelMedium?.copyWith(
                                                  //     fontWeight: FontWeight.w400,
                                                  //   ),
                                                  // ),
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
                                          )
                                        : GestureDetector(
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
                                                  5.heightBox,
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
                                                  // Text(
                                                  //   formatString(data.description ?? "", capitalizeWords: false),
                                                  //   maxLines: 2,
                                                  //   style: context.textTheme.labelMedium?.copyWith(
                                                  //     fontWeight: FontWeight.w400,
                                                  //   ),
                                                  // ),
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
                    )
                  : Expanded(
                      child: controller.isLoading.value == true
                          ? Center(child: showLoader())
                          : controller.audiosData.isEmpty
                          ? Center(child: Text("No data available"))
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: controller.audiosData.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  debugPrint('controller.isLoading.value==========>>>>>${controller.isLoading.value}');

                                  debugPrint(
                                    'controller.subcategories.length==========>>>>>${controller.audiosData.length}',
                                  );
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
                                                  style: context.textTheme.headlineMedium?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Spacer(),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          ctx?.push(Routes.fenceInteractionCallView, extra: data);
                                                          controller.addViewDetailsPts();
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
                                                                color: context.isDarkMode
                                                                    ? AppColors.whiteColor
                                                                    : AppColors.primary,
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
                                                                  color: context.isDarkMode
                                                                      ? AppColors.whiteColor
                                                                      : Colors.black,
                                                                ),
                                                              ),
                                                              5.widthBox,
                                                              SvgPicture.asset(
                                                                AppAssets.playIcon,
                                                                width: 13.w,
                                                                height: 14.h,
                                                                color: context.isDarkMode
                                                                    ? AppColors.whiteColor
                                                                    : Colors.black,
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
                                                  style: context.textTheme.headlineMedium?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                15.heightBox,
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        ctx?.push(Routes.fenceInteractionCallView, extra: data);
                                                        controller.addViewDetailsPts();
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
                                                              color: context.isDarkMode
                                                                  ? AppColors.whiteColor
                                                                  : AppColors.primary,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    10.widthBox,
                                                    GestureDetector(
                                                      onTap: () {
                                                        ctx?.push(Routes.fenceInteractionCallView, extra: data);
                                                        controller.addPlaySoundPts();
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
                                                                color: context.isDarkMode
                                                                    ? Colors.black
                                                                    : AppColors.whiteColor,
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
                    ),
            ],
          ),
        );
      },
    );
  }
}
