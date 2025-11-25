import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:moo_logue/app/core/constants/app_assets.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
import 'package:moo_logue/app/routes/index.js.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String text;

  CustomAppbar({super.key, required this.text});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          AppAssets.backArrow_icon,
          colorFilter: ColorFilter.mode(
            context.isDarkMode ? Colors.white : AppColors.primaryTextColor,
            BlendMode.srcIn,
          ),
        ),
        onPressed: () {
          ctx!.pop();
        },
      ),
      title: Text(text, style: context.textTheme.displayMedium),
    );
  }
}
