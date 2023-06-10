import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PageHeader extends StatelessWidget {
  final String title;
  String prevPage;
  bool noBackBtn;
  bool noAction;
  bool hasShare;
  final void Function()? onPressed;
  List<InkWell> iconList;
  PageHeader(
      {super.key,
      required this.title,
      this.noBackBtn = false,
      this.noAction = false,
      this.hasShare = false,
      this.onPressed,
      this.iconList = const [],
      this.prevPage = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 30.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 5), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              //Backward icon
              !noBackBtn
                  ? InkWell(
                      onTap: () {
                        //Back to previous page
                        prevPage.isEmpty ? Get.back() : Get.offNamed(prevPage);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 35.w,
                      ),
                    )
                  : Container(),
              !noBackBtn
                  ? SizedBox(
                      width: 24.w,
                    )
                  : Container(),
              //Title
              Text(
                title,
                style: AppTextStyle.h1,
              ),
            ],
          ),
          //Search icon
          !noAction
              ? (noBackBtn
                  ? Wrap(
                      children: List.generate(iconList.length, (index) {
                        return Container(
                          margin: EdgeInsets.only(right: 15.w),
                          child: iconList[index],
                        );
                      }),
                    )
                  : iconList != null
                      ? Wrap(
                          children: List.generate(iconList.length, (index) {
                            return Container(
                              margin: EdgeInsets.only(right: 10.w),
                              child: iconList[index],
                            );
                          }),
                        )
                      : InkWell(
                          onTap: () {},
                          child: Icon(Icons.search,
                              color: Colors.white, size: 35.w),
                        ))
              : hasShare
                  ? IconButton(
                      onPressed: onPressed,
                      icon: Icon(Icons.share, size: 24.h, color: Colors.black),
                    )
                  : Container()
        ],
      ),
    );
  }
}
