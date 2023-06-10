import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatTile extends StatefulWidget {
  String imgUrl;
  String username;
  String lastMessage;
  String lastMessageTime;
  String lastMessageDate;
  bool hasDivider;
  Function()? onTap;

  ChatTile({
    super.key,
    required this.imgUrl,
    required this.username,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastMessageDate,
    this.hasDivider = true,
    this.onTap,
  });

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: widget.onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundImage: NetworkImage(
                      widget.imgUrl,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.username, style: AppTextStyle.h3),
                      Text(widget.lastMessage,
                          style: AppTextStyle.c2
                              .merge(AppTextStyle.greyTextStyle)),
                    ],
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(widget.lastMessageTime,
                      style: AppTextStyle.c3.merge(AppTextStyle.greyTextStyle)),
                  Text(widget.lastMessageDate,
                      style: AppTextStyle.c3.merge(AppTextStyle.greyTextStyle)),
                ],
              )
            ],
          ),
        ),
        widget.hasDivider
            ? Column(
                children: [
                  SizedBox(height: 5.h),
                  Divider(height: 1.h, color: AppColors.grey),
                  SizedBox(height: 10.h)
                ],
              )
            : Container()
      ],
    );
  }
}
