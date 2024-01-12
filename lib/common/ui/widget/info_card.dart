import 'package:brain_training_app/common/ui/widget/info_card_interface.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      Function()? onEdit,
      Function()? onShout,
      Function()? onCheck}) {
    return Container(
      margin: margin,
      padding: EdgeInsets.all(16.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.w),
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
                          fontSize: 16,
                          color: Color(0xFF003F5F),
                        )),
                      ),
                      SizedBox(height: 4.w),
                      Text(
                        "Gender",
                        style: AppTextStyle.h3.merge(const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF003F5F),
                        )),
                      ),
                      if (position != null) ...[
                        SizedBox(height: 4.w),
                        Text(
                          "Position",
                          style: AppTextStyle.h3.merge(const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF003F5F),
                          )),
                        ),
                      ]
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003F5F),
                          )),
                        ),
                        SizedBox(height: 4.w),
                        Text(
                          gender,
                          style: AppTextStyle.h3.merge(const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003F5F),
                          )),
                        ),
                        if (position != null) ...[
                          SizedBox(height: 4.w),
                          Text(
                            position,
                            style: AppTextStyle.h3.merge(const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003F5F),
                            )),
                          ),
                        ]
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
                              InkWell(
                                onTap: () => {if (onShout != null) onShout()},
                                child: Container(
                                    width: 50.w,
                                    height: 50.w,
                                    child: const Icon(Icons.contactless,
                                        color: Colors.blue)),
                              ),
                              SizedBox(height: 8.w),
                            ],
                          )
                        : Container(),
                    hasEditIcon
                        ? InkWell(
                            onTap: () => {if (onEdit != null) onEdit()},
                            child: Container(
                                width: 50.w,
                                height: 50.w,
                                decoration: isView
                                    ? null
                                    : BoxDecoration(
                                        color: AppColors.lightBlue,
                                        borderRadius:
                                            BorderRadius.circular(10.w)),
                                child: isView
                                    ? Text("View",
                                        style: AppTextStyle.h3.merge(
                                            AppTextStyle.brandBlueTextStyle))
                                    : const Icon(Icons.edit,
                                        color: Colors.blue)),
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
                                      color: Colors.blue)),
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40.r),
                  child: Image(
                    image: NetworkImage(imgUrl),
                    width: 100,
                    height: 100,
                    fit: BoxFit.fill,
                  ),
                ),
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
                          fontSize: 14,
                        )),
                      ),
                      SizedBox(height: 4.w),
                      Text(
                        "Gender",
                        style: AppTextStyle.h3.merge(const TextStyle(
                          fontSize: 14,
                        )),
                      ),
                      SizedBox(height: 4.w),
                      Text(
                        "Date",
                        style: AppTextStyle.h3.merge(const TextStyle(
                          fontSize: 14,
                        )),
                      ),
                      SizedBox(height: 4.w),
                      Text(
                        "Time",
                        style: AppTextStyle.h3.merge(const TextStyle(
                          fontSize: 14,
                        )),
                      ),
                      Text(
                        "Reason",
                        style: AppTextStyle.h3.merge(const TextStyle(
                          fontSize: 14,
                        )),
                      )
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
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003F5F),
                          )),
                        ),
                        SizedBox(height: 4.w),
                        Text(
                          gender,
                          style: AppTextStyle.h3.merge(const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003F5F),
                          )),
                        ),
                        SizedBox(height: 4.w),
                        Text(
                          date,
                          style: AppTextStyle.h3.merge(const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003F5F),
                          )),
                        ),
                        SizedBox(height: 4.w),
                        Text(
                          time,
                          style: AppTextStyle.h3.merge(const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003F5F),
                          )),
                        ),
                        Text(
                          reason,
                          style: AppTextStyle.h3.merge(const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003F5F),
                          )),
                        ),
                      ]),
                ],
              ),
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
                SizedBox(height: 8.w),
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
