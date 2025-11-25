import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:moo_logue/app/core/constants/app_assets.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
import 'package:moo_logue/app/core/extention/sized_box_extention.dart';

class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(AppAssets.appLogo,color: AppColors.primary,),
        12.heightBox,
        SvgPicture.asset(
          AppAssets.mooLogueLogo,
          colorFilter: ColorFilter.mode(
            context.isDarkMode ? Colors.white : Colors.black,
            BlendMode.srcIn,
          ),
        ),
      ],
    );
  }
}
