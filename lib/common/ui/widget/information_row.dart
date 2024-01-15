import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InformationRow extends StatelessWidget {
  final String title;
  final String value;
  EdgeInsetsGeometry? padding;
  double titlefontSize;
  double valuefontSize;
  TextStyle? titleStyle;
  TextStyle? valueStyle;

  InformationRow(
      {required this.title,
      required this.value,
      this.padding = const EdgeInsets.all(0),
      this.titlefontSize = 16,
      this.valuefontSize = 16,
      this.titleStyle,
      this.valueStyle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding!,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 100.w,
            child: Text(
              '$title',
              style: titleStyle ??
                  TextStyle(
                    fontSize: titlefontSize,
                    color: Colors.black54,
                  ).merge(AppTextStyle.c1),
            ),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Text(
              '$value',
              textAlign: TextAlign.right,
              overflow: TextOverflow.visible,
              style: valueStyle ??
                  TextStyle(
                    fontSize: valuefontSize,
                    fontWeight: FontWeight.bold,
                  ).merge(AppTextStyle.c1),
            ),
          ),
        ],
      ),
    );
  }
}
