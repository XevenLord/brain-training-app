import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GameIntro extends StatelessWidget {
  String title;
  String introduction;
  String img;
  LinearGradient? gradient;
  Color? buttonColor;
  Color? btnTextColor;
  Widget? actions;
  Function() onTap;

  GameIntro(
      {super.key,
      required this.title,
      required this.introduction,
      required this.onTap,
      required this.img,
      this.actions,
      this.gradient = AppColors.transparentPurple,
      this.buttonColor = AppColors.brandYellow,
      this.btnTextColor = AppColors.white});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).viewInsets.bottom -
              AppBar().preferredSize.height,
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: const [
              BoxShadow(
                offset: Offset(3, 5),
                color: AppColors.shadow,
                blurRadius: 2,
              ),
            ],
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                        img), // Correctly load the image using AssetImage
                    opacity: 0.6,
                  ),
                ),
              ),
              Container(
                foregroundDecoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                ),
              ),
              Positioned(
                top: 0.h,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios,
                              color: AppColors.brandBlue),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                        if (actions != null) actions!,
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        shadows: [
                          Shadow(
                            color:
                                Colors.black, // Choose the color of the shadow
                            blurRadius:
                                10.0, // Adjust the blur radius for the shadow effect
                            offset: Offset(3.0,
                                2.0), // Set the horizontal and vertical offset for the shadow
                          ),
                        ],
                      ).merge(AppTextStyle.title
                          .merge(AppTextStyle.whiteTextStyle)),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'How to play',
                      style: const TextStyle(
                        shadows: [
                          Shadow(
                            color:
                                Colors.black, // Choose the color of the shadow
                            blurRadius:
                                10.0, // Adjust the blur radius for the shadow effect
                            offset: Offset(2.0,
                                1.0), // Set the horizontal and vertical offset for the shadow
                          ),
                        ],
                      ).merge(
                          AppTextStyle.h1.merge(AppTextStyle.whiteTextStyle)),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(3, 5),
                            color: AppColors.shadow,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Text(
                        introduction,
                        textAlign: TextAlign.center,
                        style:
                            AppTextStyle.h3.merge(AppTextStyle.blackTextStyle),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      onPressed: onTap,
                      child: Text('Start',
                          style: AppTextStyle.h2
                              .merge(TextStyle(color: btnTextColor))),
                    ),
                    SizedBox(height: 15.w)
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
