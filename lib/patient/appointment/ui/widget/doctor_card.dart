import 'package:brain_training_app/common/ui/widget/empty_box.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorCard extends StatelessWidget {
  String imgUrl;
  String doctorName;
  String position;
  String email;
  bool? isAssignedPhysio;
  Function()? onTap;

  DoctorCard({
    super.key,
    required this.doctorName,
    required this.position,
    required this.imgUrl,
    required this.email,
    this.onTap,
    this.isAssignedPhysio = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: EmptyBox(
        decoration: BoxDecoration(
          color: isAssignedPhysio != null && isAssignedPhysio == true
              ? AppColors.lightBlue
              : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10.h),
            CircleAvatar(
              backgroundColor: AppColors.lightBlue,
              radius: 45.r,
              backgroundImage: (imgUrl.isEmpty)
                  ? const AssetImage(
                      AppConstant.NO_PROFILE_PIC,
                    ) as ImageProvider
                  : NetworkImage(imgUrl),
            ),
            SizedBox(height: 20.h),
            Text(
              doctorName,
              style: AppTextStyle.h3,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(height: 10.h),
            Text(
              position,
              style: AppTextStyle.c2,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(height: 5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.email, color: AppColors.brandBlue, size: 20.w),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    email,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.smallText
                        .merge(AppTextStyle.greyTextStyle),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
