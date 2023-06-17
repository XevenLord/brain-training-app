import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class PillButton extends StatefulWidget {
  String text;
  EdgeInsets padding;
  EdgeInsets? margin;
  bool isSelected;
  Function? onTap;

  PillButton({
    super.key,
    required this.text,
    this.padding = const EdgeInsets.all(8),
    this.margin,
    this.onTap,
    this.isSelected = false,
  });

  @override
  State<PillButton> createState() => _PillButtonState();
}

class _PillButtonState extends State<PillButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.isSelected = !widget.isSelected;
          if (widget.onTap != null) {
            widget.onTap!();
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.isSelected ? AppColors.brandBlue : AppColors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 2,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        padding: widget.padding,
        margin: widget.margin,
        child: Text(
          widget.text,
          style: AppTextStyle.c2.merge(
            widget.isSelected
                ? AppTextStyle.whiteTextStyle.merge(AppTextStyle.h4)
                : AppTextStyle.blackTextStyle,
          ),
        ),
      ),
    );
  }
}
