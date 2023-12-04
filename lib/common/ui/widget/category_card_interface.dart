import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';

abstract class CategoryCardInterface {
  Widget buildCategoryCard({
    required String category,
    required IconData icon,
    LinearGradient? gradient,
    Color? backgroundColor,
    Color? foregroundColor,
    double? cardSize,
    double? iconSize,
    double? fontSize,
    Function()? onTap,
  });
}

class CategoryCard implements CategoryCardInterface {
  @override
  Widget buildCategoryCard({
    required String category,
    required IconData icon,
    LinearGradient? gradient,
    Color? backgroundColor = AppColors.brandBlue,
    Color? foregroundColor = Colors.white,
    double? cardSize = 100,
    double? iconSize = 40,
    double? fontSize = 16,
    Function()? onTap,
    bool isRow = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.all(32),
          height: cardSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: gradient,
            color: backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: isRow
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      icon,
                      color: foregroundColor,
                      size: iconSize,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(
                      category,
                      style: TextStyle(
                        color: foregroundColor,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ).merge(AppTextStyle.h2),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: foregroundColor,
                      size: iconSize,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      category,
                      style: TextStyle(
                        color: foregroundColor,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ).merge(AppTextStyle.h3),
                    ),
                  ],
                )),
    );
  }
}
