import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
import 'package:moo_logue/app/core/extention/sized_box_extention.dart';
import 'package:moo_logue/app/core/theme/text_theme.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final String? labelText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool readOnly;
  final int? maxLength;
  final int? maxLines;
  final bool autofocus;
  final FocusNode? focusNode;
  final bool enabled;
  final String? title;
  final Widget? suffixIcon;
  final BoxConstraints? suffixIconConstraints;

  const CustomTextFormField({
    Key? key,
    this.controller,
    this.initialValue,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.maxLength,
    this.maxLines = 1,
    this.autofocus = false,
    this.focusNode,
    this.enabled = true,
    this.title,
    this.suffixIcon,
    this.suffixIconConstraints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        if (title != null) ...[
          Text(title ?? '', style: context.textTheme.bodySmall),
          4.heightBox,
        ],
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          onChanged: onChanged,
          onTap: onTap,
          readOnly: readOnly,
          maxLength: maxLength,
          maxLines: maxLines,
          autofocus: autofocus,
          focusNode: focusNode,
          enabled: enabled,
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),

          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 20.h,
            ),
            hintStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: FontFamily.poppins,
              fontSize: 16.sp,
              color: !context.isDarkMode
                  ? AppColors.primaryTextColor.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.3),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            // default border
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.borderColor),
            ),
            suffixIcon: suffixIcon,
            suffixIconConstraints: suffixIconConstraints,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: context.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
