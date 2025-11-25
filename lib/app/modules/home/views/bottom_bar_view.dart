import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:moo_logue/app/core/constants/app_assets.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
import 'package:moo_logue/app/core/theme/text_theme.dart';
import 'package:moo_logue/app/modules/home/controllers/bottom_bar_controller.dart';
import 'package:moo_logue/app/modules/home/views/home_view.dart';

class BottomBarView extends StatelessWidget {
  BottomBarView({super.key, required this.child});

  final controller = Get.find<BottomBarController>();
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Obx(
        () => Container(
          height: 92.h,
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: context.isDarkMode ? Color(0xff424242) : Color(0xFFE5E5E5), width: 1.0)),
          ),
          child: Theme(
            data: Theme.of(
              context,
            ).copyWith(splashFactory: NoSplash.splashFactory, highlightColor: Colors.transparent, hoverColor: Colors.transparent),
            child: BottomNavigationBar(
              backgroundColor: context.isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
              currentIndex: controller.currentIndex.value,
              onTap: (int newIndex) {
                // controller.currentIndex.value = newIndex;
                controller.onItemTapped(newIndex);
              },
              selectedFontSize: 12.sp,
              items: [
                _buildSvgNavItem(
                  isSelected: controller.currentIndex.value == 0,
                  selectedIcon: AppAssets.homeFillIcon,
                  unselectedIcon: AppAssets.homeIcon,
                  label: 'Home',
                ),
                _buildSvgNavItem(
                  isSelected: controller.currentIndex.value == 1,
                  selectedIcon: AppAssets.learningFillIcon,
                  unselectedIcon: AppAssets.learningIcon,
                  label: 'Learn',
                ),
                _buildSvgNavItem(
                  isSelected: controller.currentIndex.value == 2,
                  selectedIcon: AppAssets.leaderboardFillIcon,
                  unselectedIcon: AppAssets.leaderboardIcon,
                  label: 'Leaderboard',
                ),
                _buildSvgNavItem(
                  isSelected: controller.currentIndex.value == 3,
                  selectedIcon: AppAssets.aboutUsFillIcon,
                  unselectedIcon: AppAssets.aboutUsIcon,
                  label: 'About Us',
                ),
              ],
              iconSize: 20.sp,

              unselectedFontSize: 12.sp,
              selectedItemColor: AppColors.primary,
              selectedLabelStyle: TextStyle(
                color: AppColors.primary,
                fontFamily: FontFamily.poppins,
                fontWeight: FontWeight.w500,
                height: 2.2,
                fontSize: 10.sp,
              ),

              unselectedLabelStyle: TextStyle(
                color: AppColors.unselectedIconColor,
                fontFamily: FontFamily.poppins,
                fontWeight: FontWeight.w500,
                height: 2.2,
                fontSize: 10.sp,
              ),

              unselectedItemColor: AppColors.unselectedIconColor,
              type: BottomNavigationBarType.fixed,
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildSvgNavItem({
    required bool isSelected,
    required String selectedIcon,
    required String unselectedIcon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
        child: SvgPicture.asset(
          color: isSelected ? AppColors.primary : null,
          isSelected ? selectedIcon : unselectedIcon,
          key: ValueKey<bool>(isSelected), // triggers animation on change
          width: 20.w,
          height: 20.h,
        ),
      ),
      label: label,
    );
  }
}
