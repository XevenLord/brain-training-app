import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatOfflineBar extends StatelessWidget {
  const ChatOfflineBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.amber,
      height: 120.h,
      // width: double.infinity,
      // alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(30.w, 30.h, 30.w, 30.h),
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Text("You are currently offline...",
            style: AppTextStyle.c1.merge(AppTextStyle.blackTextStyle)),
      ),
    );
  }
}
