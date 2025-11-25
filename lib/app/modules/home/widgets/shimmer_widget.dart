import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyShimmer extends StatelessWidget {
  final double width;
  final double height;

  const EmptyShimmer({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[600]! : Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isDark ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image shimmer
            Container(
              width: double.infinity,
              height: 94.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.grey[200],
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
            SizedBox(height: 20.h),
            // Title shimmer
            Container(
              width: 160.w,
              height: 18.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.grey[200],
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            SizedBox(height: 6.h),
            // Description shimmer
            Container(
              width: double.infinity,
              height: 14.h,
              margin: EdgeInsets.only(bottom: 4.h),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.grey[200],
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            Container(
              width: 200.w,
              height: 14.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.grey[200],
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
