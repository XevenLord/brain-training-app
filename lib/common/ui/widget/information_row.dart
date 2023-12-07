import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class InformationRow extends StatelessWidget {
  final String title;
  final String value;
  EdgeInsetsGeometry? padding;
  double titlefontSize;
  double valuefontSize;

  InformationRow(
      {required this.title,
      required this.value,
      this.padding = const EdgeInsets.all(0),
      this.titlefontSize = 16,
      this.valuefontSize = 16});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding!,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '$title',
            style: TextStyle(
              fontSize: titlefontSize,
              color: Colors.black54,
            ).merge(AppTextStyle.c1),
          ),
          Text(
            '$value',
            style: TextStyle(
              fontSize: valuefontSize,
              fontWeight: FontWeight.bold,
            ).merge(AppTextStyle.c1),
          ),
        ],
      ),
    );
  }
}
