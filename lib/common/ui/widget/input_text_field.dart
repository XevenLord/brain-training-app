import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputTextFormField extends StatefulWidget {
  String promptText;
  String name;
  TextEditingController textEditingController;
  bool obscureText;
  String? label;
  TextInputType? keyboardType;
  Widget? prefixIcon;
  TextStyle? prefixStyle;
  Widget? suffixIcon;
  TextStyle? suffixStyle;
  Function()? onTap;
  String? Function(String?)? validator;

  InputTextFormField({
    super.key,
    required this.name,
    required this.promptText,
    required this.textEditingController,
    this.obscureText = false,
    this.label,
    this.keyboardType,
    this.prefixIcon,
    this.prefixStyle,
    this.suffixIcon,
    this.suffixStyle,
    this.onTap,
    this.validator,
  });

  @override
  State<InputTextFormField> createState() => _InputTextFormFieldState();
}

class _InputTextFormFieldState extends State<InputTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.promptText, style: AppTextStyle.h3),
        SizedBox(height: 5.h),
        FormBuilderTextField(
          name: widget.name,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          controller: widget.textEditingController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFD9D9D9).withOpacity(0.3),
            label: widget.label != null
                ? Text(widget.label!, style: AppTextStyle.h4)
                : null,
            labelStyle: AppTextStyle.c2.merge(AppTextStyle.lightGreyTextStyle),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.white),
                borderRadius: BorderRadius.circular(10),
                gapPadding: 0),
            disabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.white),
                borderRadius: BorderRadius.circular(10),
                gapPadding: 0),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.brandBlue),
                borderRadius: BorderRadius.circular(10),
                gapPadding: 0),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.red),
                borderRadius: BorderRadius.circular(10),
                gapPadding: 0),
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10),
                gapPadding: 0),
            suffixIcon: widget.suffixIcon,
            suffixStyle: widget.suffixStyle,
            prefixIcon: widget.prefixIcon,
            prefixStyle: widget.prefixStyle,
          ),
          validator: widget.validator,
          onTap: widget.onTap,
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}
