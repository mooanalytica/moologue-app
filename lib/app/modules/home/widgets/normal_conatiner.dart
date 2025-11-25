import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';
import 'package:moo_logue/app/core/extention/sized_box_extention.dart';
import 'package:moo_logue/app/widgets/custom_button.dart';
import 'package:moo_logue/app/widgets/rounded_asset_image.dart';

class CourseCard extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget child;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;

  const CourseCard({super.key, this.width, this.height, required this.child, this.color, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? Color(0xffF1F8CB).withOpacity(0.24),
        borderRadius: borderRadius ?? BorderRadius.circular(25.r),
      ),
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: child),
    );
  }
}
