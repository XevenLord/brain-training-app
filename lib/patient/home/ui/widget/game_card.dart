import 'package:brain_training_app/common/ui/widget/empty_box.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameCard extends StatefulWidget {
  String img;
  String title;
  String description;
  EdgeInsetsGeometry margin;
  Function()? onTap;

  GameCard({
    super.key,
    required this.img,
    required this.title,
    required this.description,
    this.onTap,
    this.margin = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  @override
  Widget build(BuildContext context) {
    return EmptyBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 7,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      padding: EdgeInsets.zero,
      margin: widget.margin,
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              height: 350.h,
              decoration: BoxDecoration(
                color: AppColors.white,
                image: DecorationImage(
                  image: NetworkImage(widget.img),
                  // AssetImage(widget.img),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: Container(
                      height: 30.h,
                      width: 30.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.more_horiz, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.description,
                          style:
                              AppTextStyle.c2.merge(AppTextStyle.greyTextStyle)),
                      IconButton(
                        // padding: EdgeInsets.zero,
                        alignment: Alignment.centerRight,
                        icon: const Icon(Icons.arrow_right_alt),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(
                      5,
                      (index) => const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.star, color: Colors.yellow),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
