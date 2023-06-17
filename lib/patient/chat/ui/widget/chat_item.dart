import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatItem extends StatefulWidget {
  bool isSender;
  String message;
  String time;
  String type;

  ChatItem({
    super.key,
    this.isSender = false,
    this.message = '',
    this.time = '',
    this.type = 'message',
  });

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: widget.isSender ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              color: widget.isSender ? AppColors.brandBlue : AppColors.lightBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.h),
                topRight: Radius.circular(16.h),
                bottomRight: !widget.isSender
                    ? Radius.circular(16.h)
                    : const Radius.circular(0),
                bottomLeft: widget.isSender
                    ? Radius.circular(16.h)
                    : const Radius.circular(0),
              ),
            ),
            child: widget.type == "Image"
                ? InkWell(
                    onTap: () {},
                    child: Container(
                        width: 200,
                        // height: 200,
                        child: CachedNetworkImage(
                          imageUrl: widget.message,
                          placeholder: (context, url) => Container(
                            alignment: Alignment.center,
                            child: Center(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            AppConstant.LOADING_GIF))),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) {
                            return Container(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Image.asset(
                                AppConstant.ERROR_IMG,
                                width: 56.w,
                                height: 56.h,
                              ),
                            );
                          },
                        )),
                  )
                : widget.type == "Voice"
                    ? Container()

                    // VoiceMessage(
                    //     audioSrc: message,
                    //     played: false,
                    //     me: isSender,
                    //     meBgColor: AppColors.blue,
                    //     contactFgColor: AppColors.blue,
                    //     contactCircleColor: AppColors.blue,
                    //     onPlay: () {},
                    //   )
                    : Text(
                        widget.message,
                        // cursorRadius: const Radius.circular(20),
                        style: TextStyle(
                            color: widget.isSender
                                ? AppColors.white
                                : AppColors.brandBlue),
                      ),
          )
        ],
      ),
    );
  }
}
