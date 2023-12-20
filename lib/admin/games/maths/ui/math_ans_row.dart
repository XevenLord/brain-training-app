import 'package:brain_training_app/common/domain/entity/math_ans.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MathAnsRow extends StatelessWidget {
  int index;
  MathAnswer mathAnswer;
  MathAnsRow({
    super.key,
    required this.mathAnswer,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: index == 1 ? null : const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
        color: mathAnswer.isUserCorrect!
            ? AppColors.lightGreen
            : AppColors.lightRed,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          SizedBox(
            width: 64.w,
            child: Text(
              index.toString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              mathAnswer.question!.replaceAll("=", ""),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            mathAnswer.level!.toUpperCase(),
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: mathAnswer.level == "Easy"
                    ? Colors.green
                    : mathAnswer.level == "Medium"
                        ? Colors.yellow[700]
                        : Colors.red),
          ),
          SizedBox(
            width: 24.w,
          ),
          Text(
            mathAnswer.isUserCorrect.toString().toUpperCase(),
            style: TextStyle(
                fontSize: 12,
                color: mathAnswer.isUserCorrect!
                    ? AppColors.brandGreen
                    : AppColors.brandRed),
          ),
        ]),
      ),
    );
  }
}
