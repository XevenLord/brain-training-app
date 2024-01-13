import 'package:brain_training_app/admin/mmse/domain/entity/question.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class QuestionWidget extends StatefulWidget {
  final Question question;

  QuestionWidget({required this.question});

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.white, width: 1),
      ),
      elevation: 4,
      color: Colors.white,
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.question.question,
                style: AppTextStyle.h3.merge(AppTextStyle.brandBlueTextStyle)),
            SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.question.options.map((option) {
                return Row(
                  children: [
                    Checkbox(
                      value: option.isSelected,
                      onChanged: (value) {
                        setState(() {
                          option.isSelected = value!;
                        });
                      },
                    ),
                    Text(option.text, style: AppTextStyle.c1),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
