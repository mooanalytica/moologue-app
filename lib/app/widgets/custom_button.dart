import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
import 'package:moo_logue/app/core/theme/text_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final Color color;
  final Color? textColor;
  final double? textSize;
  final FontWeight? fontWeight;

  CustomButton({
    Key? key,
    required this.text,
    this.onTap,
    this.width,
    this.height,
    this.color = AppColors.primary,
    this.textColor,
    this.textSize,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap == null ? 0.5 : 1,
      child: SizedBox(
        width: width ?? double.infinity, // full width if null
        height: height ?? 65.h,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            disabledBackgroundColor: color,
            elevation: 0,
            splashFactory: NoSplash.splashFactory,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100), // full rounded
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: FontFamily.poppins,
                color: textColor ?? const Color(0xffFFFEFA),
                fontSize: textSize ?? 16,
                fontWeight: fontWeight ?? FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
