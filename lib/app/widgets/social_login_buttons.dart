import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:moo_logue/app/core/constants/app_assets.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
import 'package:moo_logue/app/core/extention/sized_box_extention.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({
    super.key,
    this.onAppleLogin,
    this.onGoogleLogin,
    this.onFacebookLogin,
  });
  final VoidCallback? onAppleLogin;
  final VoidCallback? onGoogleLogin;
  final VoidCallback? onFacebookLogin;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (Platform.isIOS)
          GestureDetector(
            onTap: onAppleLogin,
            child: _buildRoundContainer(
              Center(
                child: SvgPicture.asset(
                  AppAssets.appleIcon,
                  colorFilter: ColorFilter.mode(
                    context.isDarkMode
                        ? Colors.white.withValues(alpha: 0.9)
                        : Colors.black,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              context,
            ),
          ),
        10.widthBox,
        GestureDetector(
          onTap: onGoogleLogin,
          child: _buildRoundContainer(
            Center(child: SvgPicture.asset(AppAssets.googleIcon)),
            context,
          ),
        ),

        10.widthBox,
        GestureDetector(
          onTap: onFacebookLogin,
          child: _buildRoundContainer(
            Center(child: SvgPicture.asset(AppAssets.facebookIcon)),
            context,
          ),
        ),
      ],
    );
  }

  Widget _buildRoundContainer(Widget child, BuildContext context) {
    return Container(
      width: 50.w,
      height: 50.h,
      decoration: BoxDecoration(
        border: Border.all(
          color: context.isDarkMode ? Colors.white : AppColors.primaryTextColor,
        ),
        shape: BoxShape.circle,
      ),
      child: child,
    );
  }
}
