import 'package:brain_training_app/common/ui/widget/empty_box.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Green tile: Current time
// Yellow tile: Upcoming time
// Red tile: Past time
class AppointmentTile extends StatefulWidget {
  Function()? onTap;
  AppointmentTileType type;
  String? img;
  String time;
  String doctorName;

  AppointmentTile(
      {super.key,
      this.onTap,
      this.img,
      required this.time,
      required this.doctorName,
      required this.type});

  @override
  State<AppointmentTile> createState() => _AppointmentTileState();
}

class _AppointmentTileState extends State<AppointmentTile> {
  @override
  Widget build(BuildContext context) {
    return EmptyBox(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45.r),
          bottomLeft: Radius.circular(45.r),
          topRight: Radius.circular(10.r),
          bottomRight: Radius.circular(10.r),
        ),
        color: widget.type.color,
      ),
      child: InkWell(
        onTap: widget.onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 45.r,
              backgroundImage: NetworkImage(
                "https://img.freepik.com/free-photo/pleased-young-female-doctor-wearing-medical-robe-stethoscope-around-neck-standing-with-closed-posture_409827-254.jpg",
              ),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RichText(
                  text: TextSpan(
                    style: AppTextStyle.c2.merge(AppTextStyle.greyTextStyle),
                    children: [
                      TextSpan(
                        text: "In Charge By: ",
                      ),
                      TextSpan(
                        text: widget.doctorName,
                        style: AppTextStyle.h4,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  widget.time,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum AppointmentTileType {
  current,
  upcoming,
  past,
}

extension AppointmentTileTypeExtension on AppointmentTileType {
  Color get color {
    switch (this) {
      case AppointmentTileType.current:
        return AppColors.lightBlue;
      case AppointmentTileType.upcoming:
        return AppColors.lightYellow;
      case AppointmentTileType.past:
        return AppColors.lightRed;
    }
  }
}
