import 'package:brain_training_app/common/ui/widget/info_card_interface.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'information_row.dart';

class InfoCardTile implements InfoCardInterface {
  @override
  Widget buildInfoCard(
      {required String name,
      required String gender,
      required String age,
      String? position,
      String? imgUrl,
      bool hasEditIcon = true,
      bool hasCheckIcon = false,
      EdgeInsetsGeometry? margin = const EdgeInsets.only(bottom: 16),
      bool isView = false,
      bool shout = false,
      bool hasAssignStarIcon = false,
      Widget? topRightTrailing,
      Color? backgroundColor,
      Color? foregroundColor,
      String? assignedTo,
      Function()? onChoose,
      Function()? onEdit,
      Function()? onShout,
      Function()? onCheck}) {
    return Container(
      margin: margin,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(name, style: AppTextStyle.h2),
              if (hasAssignStarIcon) topRightTrailing!,
            ],
          ),
          SizedBox(height: 8.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Age",
                        style: AppTextStyle.h3.merge(const TextStyle(
                          color: Color(0xFF003F5F),
                        )),
                      ),
                      SizedBox(height: 4.w),
                      Text(
                        "Gender",
                        style: AppTextStyle.h3.merge(const TextStyle(
                          color: Color(0xFF003F5F),
                        )),
                      ),
                      if (position != null) ...[
                        SizedBox(height: 4.w),
                        Text(
                          "Position",
                          style: AppTextStyle.h3.merge(const TextStyle(
                            color: Color(0xFF003F5F),
                          )),
                        ),
                      ],
                      if (assignedTo != null && assignedTo.isNotEmpty) ...[
                        SizedBox(height: 4.w),
                        Text(
                          "Assigned To",
                          style: AppTextStyle.h3.merge(const TextStyle(
                            color: Color(0xFF003F5F),
                          )),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(width: 50.w),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          age,
                          style: AppTextStyle.h3.merge(const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003F5F),
                          )),
                        ),
                        SizedBox(height: 4.w),
                        Text(
                          gender,
                          style: AppTextStyle.h3.merge(const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003F5F),
                          )),
                        ),
                        if (position != null) ...[
                          SizedBox(height: 4.w),
                          Text(
                            position,
                            style: AppTextStyle.h3.merge(const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003F5F),
                            )),
                          ),
                        ],
                        if (assignedTo != null && assignedTo.isNotEmpty) ...[
                          SizedBox(height: 4.w),
                          Text(
                            assignedTo.length > 20
                                ? assignedTo.substring(0, 12) + "..."
                                : assignedTo,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.h3.merge(const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003F5F),
                            )),
                          ),
                        ],
                      ]),
                ],
              ),
              if (hasEditIcon || hasCheckIcon || shout)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    shout
                        ? Column(
                            children: [
                              // SizedBox(height: 8.w),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: InkWell(
                                  onTap: () => {if (onShout != null) onShout()},
                                  child: Text(
                                    "Inspire",
                                    style: AppTextStyle.h3.merge(TextStyle(
                                        color: foregroundColor ??
                                            AppColors.brandBlue)),
                                  ),
                                ),
                              ),
                              // InkWell(
                              //   onTap: () => {if (onShout != null) onShout()},
                              //   child: Container(
                              //       width: 50.w,
                              //       height: 50.w,
                              //       child: const Icon(Icons.contactless,
                              //           color: AppColors.brandBlue)),
                              // ),
                              SizedBox(height: 16.w),
                            ],
                          )
                        : Container(),
                    hasEditIcon
                        ? TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  foregroundColor ?? AppColors.brandBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.w),
                              ),
                            ),
                            onPressed: () => {if (onEdit != null) onEdit()},
                            child: Container(
                                decoration: isView
                                    ? null
                                    : BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.w)),
                                child: isView
                                    ? Text("View",
                                        style: AppTextStyle.h3
                                            .merge(AppTextStyle.whiteTextStyle))
                                    : const Icon(Icons.edit,
                                        color: AppColors.white)),
                          )
                        : Container(),
                    hasCheckIcon
                        ? Column(children: [
                            SizedBox(height: 8.w),
                            InkWell(
                              onTap: () => {if (onCheck != null) onCheck()},
                              child: Container(
                                  width: 50.w,
                                  height: 50.w,
                                  decoration: BoxDecoration(
                                      color: AppColors.lightBlue,
                                      borderRadius:
                                          BorderRadius.circular(10.w)),
                                  child: const Icon(Icons.check,
                                      color: AppColors.brandBlue)),
                            ),
                          ])
                        : Container()
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget buildRequestCard({
    required String name,
    required String gender,
    required String age,
    required String imgUrl,
    required String date,
    required String time,
    required String reason,
    Function()? onAccept,
    Function()? onDecline,
    EdgeInsetsGeometry? margin = const EdgeInsets.only(bottom: 16),
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40.r,
                backgroundColor: AppColors.lightBlue,
                backgroundImage: (imgUrl.isEmpty)
                    ? const AssetImage(
                        AppConstant.NO_PROFILE_PIC,
                      ) as ImageProvider
                    : NetworkImage(imgUrl),
              ),
              SizedBox(width: 14.w),
              Text(
                name,
                style: AppTextStyle.h3.merge(
                  TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InformationRow(
                      title: "Age",
                      value: age,
                      titleStyle: AppTextStyle.c1
                          .merge(const TextStyle(fontWeight: FontWeight.bold)),
                      valueStyle: AppTextStyle.c1,
                    ),
                    SizedBox(height: 10.w),
                    InformationRow(
                      title: "Gender",
                      value: gender,
                      titleStyle: AppTextStyle.c1
                          .merge(const TextStyle(fontWeight: FontWeight.bold)),
                      valueStyle: AppTextStyle.c1,
                    ),
                    SizedBox(height: 10.w),
                    InformationRow(
                      title: "Date",
                      value: date,
                      titleStyle: AppTextStyle.c1
                          .merge(const TextStyle(fontWeight: FontWeight.bold)),
                      valueStyle: AppTextStyle.c1,
                    ),
                    SizedBox(height: 10.w),
                    InformationRow(
                      title: "Time",
                      value: time,
                      titleStyle: AppTextStyle.c1
                          .merge(const TextStyle(fontWeight: FontWeight.bold)),
                      valueStyle: AppTextStyle.c1,
                    ),
                    SizedBox(height: 10.w),
                    InformationRow(
                      title: "Reason",
                      value: reason,
                      titleStyle: AppTextStyle.c1
                          .merge(const TextStyle(fontWeight: FontWeight.bold)),
                      valueStyle: AppTextStyle.c1,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 50.w),
              Column(children: [
                SizedBox(height: 8.w),
                InkWell(
                  onTap: () => {if (onAccept != null) onAccept()},
                  child: Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                          color: AppColors.lightBlue,
                          borderRadius: BorderRadius.circular(10.w)),
                      child: const Icon(Icons.check, color: Colors.blue)),
                ),
                SizedBox(height: 24.w),
                InkWell(
                  onTap: () => {if (onDecline != null) onDecline()},
                  child: Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                          color: AppColors.lightBlue,
                          borderRadius: BorderRadius.circular(10.w)),
                      child: const Icon(Icons.close, color: Colors.blue)),
                ),
              ])
            ],
          ),
        ],
      ),
    );
  }
}
