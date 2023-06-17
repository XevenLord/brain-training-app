import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app_text_style.dart';

Future<V> useLoadingDialog<V, T>({
  required Future<V> Function(T) func,
  required T args,
  required String title,
  required TextStyle titleStyle,
  Widget? content,
  EdgeInsets titlePadding = const EdgeInsets.fromLTRB(0, 20, 0, 10),
  EdgeInsets contentPadding =
      const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
  bool closeLoadingDialogOnComplete = true,
}) async {
  Get.defaultDialog(
    title: title,
    titleStyle: titleStyle,
    titlePadding: titlePadding,
    content: content ??
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/image/rick-loading.gif"),
              const SizedBox(height: 20),
              Text(
                "Processing request",
                style: AppTextStyle.c1,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
    contentPadding: contentPadding,
    barrierDismissible: false,
    onWillPop: () async {
      // prevent close loading before done process
      return false;
    },
  );
  // async validator calls
  V res = await func(args);
  // close loading dialog
  if (closeLoadingDialogOnComplete) {
    Get.back();
  }
  return res;
}

useInfoDialog(
    {required String title,
    required TextStyle titleStyle,
    required Widget content,
    required String description,
    required TextStyle descriptionStyle,
    String? confirmButtonText,
    String? cancelButtonText,
    String? customButtonText,
    void Function()? onConfirm,
    void Function()? onCancel,
    void Function()? onCustom,
    EdgeInsets titlePadding = const EdgeInsets.fromLTRB(20, 20, 20, 0),
    EdgeInsets contentPadding =
        const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    TextAlign descriptionTextAlign = TextAlign.center}) {
  Get.defaultDialog(
    title: title,
    titleStyle: titleStyle,
    titlePadding: titlePadding,
    content: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        content,
        const SizedBox(
          height: 15,
        ),
        Text(
          description,
          style: descriptionStyle,
          textAlign: descriptionTextAlign,
        ),
      ],
    ),
    contentPadding: contentPadding,
    barrierDismissible: false,
    onWillPop: () async {
      // prevent close loading before done process
      return false;
    },
    textConfirm: confirmButtonText,
    confirmTextColor: AppColors.white,
    onConfirm: onConfirm,
    textCustom: customButtonText,
    onCustom: onCustom,
    textCancel: cancelButtonText,
    onCancel: onCancel,
  );
}

useErrorDialog(
    {required String title,
    required TextStyle titleStyle,
    required String description,
    required TextStyle descriptionStyle,
    EdgeInsets titlePadding = const EdgeInsets.fromLTRB(20, 20, 20, 0),
    EdgeInsets contentPadding =
        const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    TextAlign descriptionTextAlign = TextAlign.center}) {
  Get.defaultDialog(
    title: title,
    titleStyle: titleStyle,
    titlePadding: titlePadding,
    content: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.error_outline_sharp,
          color: Colors.red,
          size: 64.0,
        ),
        const SizedBox(
          height: 15,
        ),
        Text(description,
            style: descriptionStyle, textAlign: descriptionTextAlign)
      ],
    ),
    contentPadding: contentPadding,
    barrierDismissible: false,
    textCancel: "Close",
  );
}

void killDialog() {
  Get.back();
}
