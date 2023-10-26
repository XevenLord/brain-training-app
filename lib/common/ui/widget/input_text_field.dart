import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class InputTextFormField extends StatefulWidget {
  String promptText;
  String name;
  TextEditingController? textEditingController;
  bool obscureText;
  String? label;
  TextInputType? keyboardType;
  Widget? prefixIcon;
  TextStyle? prefixStyle;
  Widget? suffixIcon;
  TextStyle? suffixStyle;
  Function()? onTap;
  int? maxLines;
  bool readOnly;
  String? Function(String?)? validator;
  TextAlign? textAlign;

  // for dropdown
  bool isDropdown;
  String? initialValue;
  List<String>? items;
  Function(dynamic)? onChanged;

  InputTextFormField({
    super.key,
    required this.name,
    required this.promptText,
    this.textEditingController,
    this.obscureText = false,
    this.label,
    this.keyboardType,
    this.prefixIcon,
    this.prefixStyle,
    this.suffixIcon,
    this.suffixStyle,
    this.onTap,
    this.maxLines = 1,
    this.validator,
    this.readOnly = false,
    this.textAlign,
    // for dropdown
    this.isDropdown = false,
    this.onChanged,
    this.initialValue,
    this.items,
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
        widget.isDropdown
            ? FormBuilderDropdown<String>(
                name: widget.name,
                initialValue: widget.initialValue,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFD9D9D9).withOpacity(0.3),
                  label: widget.label != null
                      ? Text(widget.label!, style: AppTextStyle.h4)
                      : null,
                  labelStyle:
                      AppTextStyle.c2.merge(AppTextStyle.lightGreyTextStyle),
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
                items: widget.items!
                    .map((item) => DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        value: item,
                        child: Text(item)))
                    .toList(),
                onChanged: widget.onChanged)
            : FormBuilderTextField(
                readOnly: widget.readOnly,
                name: widget.name,
                keyboardType: widget.keyboardType,
                maxLines: widget.maxLines,
                obscureText: widget.obscureText,
                controller: widget.textEditingController,
                textAlign: widget.textAlign ?? TextAlign.start,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFD9D9D9).withOpacity(0.3),
                  label: widget.label != null
                      ? Text(widget.label!, style: AppTextStyle.h4,)
                      : null,
                  labelStyle:
                      AppTextStyle.c2.merge(AppTextStyle.lightGreyTextStyle),
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
