import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:moo_logue/app/core/constants/app_assets.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
import 'package:moo_logue/app/core/constants/app_const.dart';
import 'package:moo_logue/app/core/constants/app_sizes.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';
import 'package:moo_logue/app/core/extention/sized_box_extention.dart';
import 'package:moo_logue/app/modules/home/controllers/leader_board_controller.dart';
import 'package:moo_logue/app/widgets/app_snackbar.dart';
import 'package:moo_logue/app/widgets/common_home_app_bar.dart';

class LearnBoardView extends StatefulWidget {
  const LearnBoardView({super.key});

  @override
  State<LearnBoardView> createState() => _LearnBoardViewState();
}

class _LearnBoardViewState extends State<LearnBoardView> {
  final controller = Get.put(LeaderBoardController());

  @override
  void initState() {
    controller.fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomHomeAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          20.h.heightBox,
          Text(AppString.topMooListeners, style: context.textTheme.displayMedium?.copyWith(), textAlign: TextAlign.center),
          16.h.heightBox,
          Text(
            AppString.topMooListenersDisc,
            style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
          20.h.heightBox,

          // Reactive Tabs and Leaderboard
          Obx(
            () => Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: AppColors.closeIconBgColor.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildTabButton(title: AppString.today, index: 0, context: context),
                        buildTabButton(title: AppString.week, index: 1, context: context),
                        buildTabButton(title: AppString.month, index: 2, context: context),
                        buildTabButton(title: AppString.allTime, index: 3, context: context),
                      ],
                    ),
                  ),
                  20.h.heightBox,

                  // Leaderboard List
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              return controller.isLoading.value
                  ? Center(child: showLoader())
                  : controller.filteredUsers.isEmpty
                  ? Center(
                      child: Text(
                        "No listeners available",
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                          color: context.isDarkMode ? AppColors.whiteColor : AppColors.primaryTextColor,
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: controller.filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = controller.filteredUsers[index];
                        final bool isTopThree = index < 3;

                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Container(
                                color: isTopThree
                                    ? (context.isDarkMode ? AppColors.closeIconBgColor : AppColors.closeIconBgColor.withOpacity(0.5))
                                    : Colors.transparent,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                                      child: Row(
                                        children: [
                                          // if (isTopThree)
                                          //   SvgPicture.asset(AppAssets.weekoneIcon, height: 25.h, width: 25.w)
                                          // else
                                          CircleAvatar(
                                            backgroundColor: Colors.yellow,
                                            radius: 12,
                                            child: Text(
                                              "${index + 1}",
                                              style: context.textTheme.titleLarge?.copyWith(fontSize: 14.sp, color: AppColors.primary),
                                            ),
                                          ),
                                          10.w.widthBox,
                                          CircleAvatar(
                                            radius: 15.r,
                                            backgroundImage: (user.photo != null && user.photo!.isNotEmpty)
                                                ? (user.photo!.startsWith("https")
                                                ? NetworkImage(user.photo!)
                                                : NetworkImage("$awsFilesUrl${user.photo}"))
                                                : null,
                                            child: (user.photo == null || user.photo!.isEmpty) ? Icon(Icons.person, size: 18.sp) : null,
                                          ),
                                          10.w.widthBox,


                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${(user.firstName ?? '')} ${(user.lastName ?? '')}".trim().isEmpty
                                                      ? (user.email ?? 'User')
                                                      : "${(user.firstName ?? '')} ${(user.lastName ?? '')}".trim(),
                                                  overflow: TextOverflow.ellipsis, // Prevents overflow
                                                  maxLines: 1,
                                                  style: context.textTheme.bodyMedium?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                    color: isTopThree
                                                        ? AppColors.primary
                                                        : (context.isDarkMode ? AppColors.whiteColor : AppColors.primaryTextColor),
                                                  ),
                                                ),
                                                2.5.h.heightBox,
                                                Text(
                                                  user.endDate != null ? "Last active: ${user.endDate}" : "",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: context.textTheme.labelSmall?.copyWith(
                                                    fontSize: 10.sp,
                                                    color: isTopThree
                                                        ? AppColors.primaryTextColor
                                                        : (context.isDarkMode
                                                              ? AppColors.closeIconBgColor.withOpacity(0.75)
                                                              : AppColors.primaryTextColor),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          if (user.streakCount != 0)
                                            Container(
                                              height: 35.h,
                                              width: 38.w,
                                              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(100)),
                                              child: Center(
                                                child: SvgPicture.asset(AppAssets.weekstarIcon, height: 16.h, width: 18.w),
                                              ),
                                            )
                                          else
                                            SizedBox(width: 38.w, height: 35.h),
                                          10.w.widthBox,
                                          Container(
                                            height: 31.h,
                                            width: 66.w,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(100),
                                              border: Border.all(color: AppColors.primary, width: 1),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "${user.totalPoints ?? 0}",
                                                  style: context.textTheme.titleLarge?.copyWith(fontSize: 10.sp, color: AppColors.primary),
                                                ),
                                                2.w.widthBox,
                                                Text(
                                                  AppString.points,
                                                  style: context.textTheme.titleLarge?.copyWith(fontSize: 10.sp, color: AppColors.primary),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      height: 0,
                                      color: isTopThree
                                          ? (context.isDarkMode ? AppColors.dividerColor : AppColors.primaryTextColor.withOpacity(0.1))
                                          : (context.isDarkMode
                                                ? AppColors.closeIconBgColor.withOpacity(0.25)
                                                : AppColors.primaryTextColor.withOpacity(0.1)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
            }),
          ),
        ],
      ),
    );
  }
}

Widget buildTabButton({required String title, required int index, BuildContext? context}) {
  final controller = Get.find<LeaderBoardController>();

  bool isSelected = controller.selectedIndex.value == index;

  return GestureDetector(
    onTap: () => controller.updateIndex(index),
    child: Container(
      width: 95.w,
      height: 28.h,
      decoration: BoxDecoration(color: isSelected ? AppColors.primary : Colors.transparent, borderRadius: BorderRadius.circular(5.r)),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected
                ? AppColors.whiteColor
                : context!.isDarkMode
                ? AppColors.whiteColor
                : AppColors.primaryTextColor,
          ),
        ),
      ),
    ),
  );
}
