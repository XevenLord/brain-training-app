import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyle {
  static TextStyle h1 = TextStyle(
    fontSize: 30.sp,
    fontWeight: FontWeight.w700,
    fontFamily: "Montserrat",
  );
  static TextStyle h2 = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
    height: 1.4,
    fontFamily: 'Montserrat',
  );
  static TextStyle h3 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    height: 1.4,
    fontFamily: 'Montserrat',
  );
  static TextStyle h4 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    height: 1.4,
    fontFamily: 'Montserrat',
  );
  static TextStyle c1 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    height: 1.4,
    fontFamily: 'Montserrat',
  );
  static TextStyle c2 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    height: 1.4,
    fontFamily: 'Montserrat',
  );
  static TextStyle c3 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    height: 1.4,
    fontFamily: 'Montserrat',
  );
  static TextStyle smallText = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.normal,
    height: 1.4,
    fontFamily: 'Montserrat',
  );

  // font styles with colors
  static TextStyle whiteTextStyle = const TextStyle(color: AppColors.white);
  static TextStyle blackTextStyle = const TextStyle(color: AppColors.black);
  static TextStyle greyTextStyle = const TextStyle(color: AppColors.grey);
  static TextStyle brandBlueTextStyle =
      const TextStyle(color: AppColors.brandBlue);
  static TextStyle lightGreyTextStyle = const TextStyle(
    color: Color(0xFF6B779A),
  );
  static TextStyle underlineTextStyle = const TextStyle(
    decoration: TextDecoration.underline,
  );
}
