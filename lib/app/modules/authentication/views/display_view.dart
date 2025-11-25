import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:moo_logue/app/controllers/theme_controller.dart';
import 'package:moo_logue/app/core/constants/app_assets.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
import 'package:moo_logue/app/core/constants/app_sizes.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';
import 'package:moo_logue/app/core/extention/sized_box_extention.dart';
import 'package:moo_logue/app/modules/authentication/controllers/display_view_controller.dart';
import 'package:moo_logue/app/routes/app_routes.dart';
import 'package:moo_logue/app/widgets/common_home_app_bar.dart';
import 'package:moo_logue/app/widgets/custom_appbar.dart';

class DisplayView extends StatelessWidget {
  DisplayView({super.key});
  final controller = Get.put(DisplayViewController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(text: AppString.display),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: AppSize.horizontalPadding),
        child: Column(
          children: List.generate(
            controller.displayList.length,
            (index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: SvgPicture.asset(
                    "${controller.displayList[index]['DisplayIcon']}",
                    height: 20.h,
                    width: 22.w,
                    colorFilter: ColorFilter.mode(context.isDarkMode ? AppColors.whiteColor : AppColors.primaryTextColor, BlendMode.srcIn),
                  ),
                  title: Text(
                    "${controller.displayList[index]['DisplayName']}",
                    style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  trailing: TextButton(
                    onPressed: () {
                      if (index == 0) {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: context.isDarkMode ? AppColors.primary : AppColors.whiteColor,
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
                                  ),
                                  child: Column(
                                    children: [
                                      20.h.heightBox,
                                      Text(
                                        AppString.fontSize,
                                        style: context.textTheme.headlineLarge?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: context.isDarkMode ? AppColors.whiteColor : Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 200.h,
                                        child: ListView.builder(
                                          itemCount: 3,
                                          itemBuilder: (context, index) {
                                            return Obx(
                                              () => ListTile(
                                                leading: Container(
                                                  height: 20.h,
                                                  width: 20.w,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.transparent,
                                                    border: Border.all(
                                                      color: context.isDarkMode ? AppColors.whiteColor : AppColors.darkBorderColor,
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Icon(
                                                      controller.selectedFontIndex.value == index ? Icons.circle : null,
                                                      color: AppColors.primaryTextColor,
                                                      size: 16.sp,
                                                    ),
                                                  ),
                                                ),
                                                title: Text(
                                                  controller.fontSizeList[index],
                                                  style: context.textTheme.titleMedium?.copyWith(
                                                    color: context.isDarkMode ? AppColors.whiteColor : Colors.black,
                                                  ),
                                                ),
                                                onTap: () {
                                                  controller.changeFontSize(index);
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            final themeController = Get.find<ThemeController>();
                            final displayController = Get.find<DisplayViewController>();

                            final themeNames = displayController.themeList; // ["Light", "Dark", "System"]

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: context.isDarkMode ? AppColors.primary : AppColors.whiteColor,
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
                                  ),
                                  child: Column(
                                    children: [
                                      20.h.heightBox,
                                      Text(
                                        "Select Theme",
                                        style: context.textTheme.headlineLarge?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: context.isDarkMode ? AppColors.whiteColor : Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 200.h,
                                        child: ListView.builder(
                                          itemCount: themeNames.length,
                                          itemBuilder: (context, index) {
                                            return Obx(
                                              () => ListTile(
                                                leading: Container(
                                                  height: 20.h,
                                                  width: 20.w,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: context.isDarkMode ? AppColors.whiteColor : AppColors.darkBorderColor,
                                                      width: 1.4,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Icon(
                                                      themeController.themeMode.value.index == index ? Icons.circle : null,
                                                      color: AppColors.primaryTextColor,
                                                      size: 12.sp,
                                                    ),
                                                  ),
                                                ),
                                                title: Text(
                                                  themeNames[index],
                                                  style: context.textTheme.titleMedium?.copyWith(
                                                    color: context.isDarkMode ? AppColors.whiteColor : Colors.black,
                                                  ),
                                                ),
                                                onTap: () {
                                                  debugPrint(
                                                    'themeController.themeMode.value.index == index==========>>>>>${themeController.themeMode.value.index == index}',
                                                  );
                                                  debugPrint(
                                                    'themeController.themeMode.value.index==========>>>>>${themeController.themeMode.value.index}',
                                                  );
                                                  debugPrint('themeNames[index]==========>>>>>${themeNames[index]}');
                                                  debugPrint('index==========>>>>>${index}');

                                                  themeController.setThemeMode(index); // updates ThemeMode
                                                  displayController.changeTheme(index); // updates display
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text(
                      AppString.edit,
                      style: context.textTheme.titleSmall?.copyWith(decoration: TextDecoration.underline, decorationThickness: 2),
                    ),
                  ),
                ),
                16.heightBox,
                Obx(
                  () => index == 1
                      ? Row(
                          children: [
                            // Text(
                            //   AppString.enabled,
                            //
                            //   style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 15),
                            // ),
                            // Spacer(),
                            Text(
                              controller.themeList[controller.selectedThemeIndex.value],

                              style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ],
                        )
                      : Text(
                          controller.fontSizeList[controller.selectedFontIndex.value],

                          style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                ),
                10.heightBox,
                Divider(color: context.isDarkMode ? AppColors.whiteColor : AppColors.primaryTextColor.withValues(alpha: 0.1)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
