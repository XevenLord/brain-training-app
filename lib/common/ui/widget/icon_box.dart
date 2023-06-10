import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconBox extends StatefulWidget {
  Widget icon;
  double iconSize;
  String? title;
  Function()? onPressed;
  Color? boxColor;
  TextStyle? textStyle;

  IconBox({
    super.key,
    required this.icon,
    this.iconSize = 24.0,
    this.onPressed,
    this.title,
    this.boxColor,
    this.textStyle,
  });

  @override
  State<IconBox> createState() => _IconBoxState();
}

class _IconBoxState extends State<IconBox> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: widget.boxColor ?? Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: IconButton(
            onPressed: widget.onPressed,
            icon: widget.icon,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          widget.title ?? "",
          style: widget.textStyle ?? AppTextStyle.c1.merge(AppTextStyle.blackTextStyle),
        ),
      ],
    );
  }
}
