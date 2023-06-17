import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoTile extends StatefulWidget {
  String title;
  String label;
  bool hasDivider;
  EdgeInsetsGeometry? padding;
  TextEditingController? controller;
  Function()? onPressed;

  InfoTile({
    super.key,
    required this.title,
    required this.label,
    this.controller,
    this.hasDivider = false,
    this.onPressed,
    this.padding,
  });

  @override
  State<InfoTile> createState() => _InfoTileState();
}

class _InfoTileState extends State<InfoTile> {
  bool readOnly = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding ?? EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        border: widget.hasDivider
            ? Border(bottom: BorderSide(color: AppColors.grey))
            : Border(),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title, style: AppTextStyle.h3),
              Text(widget.label,
                  style: AppTextStyle.c1.merge(AppTextStyle.greyTextStyle))
            ],
          ),
        ],
      ),
    );
  }
}
