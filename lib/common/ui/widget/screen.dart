import 'package:brain_training_app/common/ui/widget/page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Screen extends StatelessWidget {
  final String appBarTitle;
  final AppBar? appBar;
  final bool noBackBtn;
  final bool headerNoAction;
  final bool hasShare;
  final void Function()? onPressed;
  final String prevPage;
  final List<InkWell> iconList;
  final Widget body;
  final bool hasHorizontalPadding;
  final Widget? bottomWidget;
  final Widget? bottomNavigationBar;
  final List<Function> iconOnClick;
  final ScrollController? scrollController;
  final bool bodyCenter;
  final bool hasTopPadding;


  Screen({
    super.key,
    this.appBarTitle = "",
    this.appBar,
    this.noBackBtn = false,
    this.headerNoAction = false,
    this.hasShare = false,
    this.onPressed,
    this.iconList = const [],
    this.iconOnClick = const [],
    this.prevPage = "",
    required this.body,
    this.hasHorizontalPadding = true,
    this.bottomWidget,
    this.scrollController,
    this.bottomNavigationBar,
    this.bodyCenter = false,
    this.hasTopPadding = true,
  });

  double topPadding() {
    if (hasTopPadding) {
      return 30.h;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: SafeArea(
        child: Column(
          children: [
            !noBackBtn
                ? PageHeader(
                    prevPage: prevPage,
                    title: appBarTitle,
                    noBackBtn: noBackBtn,
                    iconList: iconList,
                    noAction: headerNoAction,
                    hasShare: hasShare,
                    onPressed: onPressed,
                  )
                : Container(),
            Expanded(
              child: bodyCenter
                  ? Center(
                      child: SingleChildScrollView(
                        child: Padding(
                            padding: EdgeInsets.only(
                                left: (hasHorizontalPadding) ? 30.w : 0,
                                right: (hasHorizontalPadding) ? 30.w : 0,
                                top: noBackBtn ? 0 : topPadding(),
                                bottom: 30.h),
                            child: body),
                      ),
                    )
                  : SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: (hasHorizontalPadding) ? 30.w : 0,
                              right: (hasHorizontalPadding) ? 30.w : 0,
                              top: noBackBtn ? 0 : topPadding(),
                              bottom: 30.h),
                          child: body),
                    ),
            ),
            Container(
              child: (bottomWidget == null)
                  ? const SizedBox.shrink()
                  : bottomWidget,
            )
          ],
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
