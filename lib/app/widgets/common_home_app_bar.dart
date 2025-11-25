import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moo_logue/app/core/constants/app_assets.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
import 'package:moo_logue/app/core/constants/app_const.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';
import 'package:moo_logue/app/core/extention/sized_box_extention.dart';
import 'package:moo_logue/app/modules/home/controllers/home_controller.dart';
import 'package:moo_logue/app/routes/app_routes.dart';
import 'package:moo_logue/app/routes/index.js.dart';

class CustomHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomHomeAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(70.h); // Adjust height as needed

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorderColor : const Color(0xffE5E5E5))),
        ),
        padding: EdgeInsets.only(bottom: 10.h, top: 5.h, left: 20.w, right: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo & App Name
            Row(
              children: [
                SvgPicture.asset(AppAssets.appLogo, width: 30.w, height: 25.h,color:  AppColors.primary,),
                6.widthBox,
                Text(
                  AppString.appName,
                  style: textTheme.displaySmall?.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w600),
                ),
              ],
            ),

            // Score & Points
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(30.r)),
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
                  child: Row(
                    children: [
                      Text(
                        '${user?.streakCount ?? "0"}',
                        style: textTheme.bodyLarge?.copyWith(
                          fontSize: 16.sp,
                          color: isDark ? AppColors.primaryTextColor : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      4.widthBox,
                      SvgPicture.asset(
                        AppAssets.wheatIcon,
                        colorFilter: ColorFilter.mode(isDark ? AppColors.primaryTextColor : Colors.white, BlendMode.srcIn),
                      ),
                    ],
                  ),
                ),
                6.widthBox,
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
                  child: Text(
                    '${user?.totalPoints ?? "0"} Points',
                    style: textTheme.bodyLarge?.copyWith(fontSize: 10.sp, color: AppColors.primary),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                ctx?.push(Routes.searchScreenView);
              },
              child: Icon(Icons.search, color: AppColors.primary),
            ),
            // Notification Icon
            // Stack(
            //   clipBehavior: Clip.none,
            //   children: [
            //     SvgPicture.asset(
            //       AppAssets.notificationIcon,
            //       colorFilter: ColorFilter.mode(!isDark ? AppColors.primaryTextColor : Colors.white, BlendMode.srcIn),
            //     ),
            //     Positioned(
            //       bottom: 23,
            //       right: 0,
            //       child: Container(
            //         width: 5,
            //         height: 5,
            //         decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            //       ),
            //     ),
            //   ],
            // ),
            // RoundedNetworkImage(imageUrl: ,
            //
            // )
            // Profile Picture
            GestureDetector(
              onTap: () {
                ctx!.push(Routes.settingsView);
              },
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  // image: DecorationImage(image: AssetImage(AppAssets.dummyProfile), fit: BoxFit.cover),
                  image: DecorationImage(
                    image: (user?.photo != null && (user!.photo ?? '').isNotEmpty)
                        ? user!.photo!.startsWith("https")
                              ? NetworkImage(user!.photo!)
                              : NetworkImage("$awsFilesUrl${user!.photo!}")
                        : const NetworkImage(
                            'https://www.mauicardiovascularsymposium.com/wp-content/uploads/2019/08/dummy-profile-pic-300x300.png',
                          ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
