import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
enum TypeState { audio, mainCategory, subCategory }
class GlassEffectScreen extends StatefulWidget {
  const GlassEffectScreen({super.key, required this.child, required this.width, required this.height, this.borderRadius, this.color});
  final double? width;
  final double? height;
  final Widget? child;
  final Color? color;
  final BorderRadius? borderRadius;

  @override
  State<GlassEffectScreen> createState() => _GlassEffectScreenState();
}

class _GlassEffectScreenState extends State<GlassEffectScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: GlassContainer.frostedGlass(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(30.0),
        borderWidth: 1.3,

        blur: 15.0,
        frostedOpacity: 0.0,
        color: widget.color ?? Color(0xFFF1F8CB).withOpacity(0.24),
        borderGradient: LinearGradient(
          colors: [Colors.grey.withOpacity(0.4), Colors.transparent, Colors.transparent, Colors.grey.withOpacity(0.4)],
          begin: Alignment(0.5, -1.0),
          end: Alignment(1.0, 0.5),
          stops: [0.0, 0.25, 0.3, 0.45],
        ),

        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        elevation: 1.0,
        child: widget.child,
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const SearchBar({super.key, required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Color(0xffF1F8CB).withOpacity(0.5),
        // color: isDark
        //     ? Colors.white.withOpacity(0.1) // Dark mode bg
        //     : Colors.black.withOpacity(0.05), // Light mode bg
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(color: isDark ? AppColors.whiteColor : Colors.black),
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: isDark ? AppColors.whiteColor : Colors.black),
          hintText: "Search",
          hintStyle: TextStyle(color: isDark ? AppColors.whiteColor : Colors.black),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
