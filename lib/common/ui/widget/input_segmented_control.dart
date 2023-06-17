import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputFormSegmentedControl extends StatefulWidget {
  String name;
  String? fieldName;
  Function(Object?)? onChanged;
  List<FormBuilderFieldOption<Object>> options;

  InputFormSegmentedControl({
    required this.name,
    required this.options,
    super.key,
    this.fieldName,
    this.onChanged,
  });

  @override
  State<InputFormSegmentedControl> createState() =>
      _InputFormSegmentedControlState();
}

class _InputFormSegmentedControlState extends State<InputFormSegmentedControl> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.fieldName != null) ...[
          Text(widget.fieldName!, style: AppTextStyle.h3),
          // SizedBox(height: 5.h)
        ],
        FormBuilderSegmentedControl(
          initialValue: widget.options[0].value,
          unselectedColor: Theme.of(context).scaffoldBackgroundColor,
          selectedColor: AppColors.brandBlue,
          borderColor: Colors.transparent,
          name: widget.name,
          options: widget.options,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            // filled: true,
            // fillColor: Color(0xFFD9D9D9).withOpacity(0.3),
            labelStyle: AppTextStyle.c2.merge(AppTextStyle.lightGreyTextStyle),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}
