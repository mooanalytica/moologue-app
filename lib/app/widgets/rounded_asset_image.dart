import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
class RoundedAssetImage extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;
  final double borderRadius;
  final BoxFit fit;
  final BorderRadiusGeometry? borderRadiusMain;
  final Color? color;

  const RoundedAssetImage({
    super.key,
    required this.imagePath,
    this.width = 100,
    this.height = 100,
    this.borderRadius = 8,
    this.fit = BoxFit.cover,
    this.borderRadiusMain, this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadiusMain ?? BorderRadius.circular(borderRadius),
      child: Image.asset(imagePath, width: width, height: height, fit: fit,color: color,),
    );
  }
}



class RoundedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final BoxFit fit;
  final BorderRadiusGeometry? borderRadiusMain;
  final Widget? placeholder;
  final Widget? errorWidget;

  const RoundedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width = 100,
    this.height = 100,
    this.borderRadius = 8,
    this.fit = BoxFit.cover,
    this.borderRadiusMain,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadiusMain ?? BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, __) => placeholder ?? Center(child: CircularProgressIndicator(color: AppColors.primary,)),
        errorWidget: (_, __, ___) => errorWidget ?? Icon(Icons.error),
      ),
    );
  }
}
