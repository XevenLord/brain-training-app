import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class EmptyBox extends StatelessWidget {
  Widget child;
  EdgeInsetsGeometry? padding;
  EdgeInsetsGeometry? margin;
  double? height;
  double? width;
  Decoration? decoration;
  AlignmentGeometry? alignment;
  BoxConstraints? constraints;
  Color? color;

  EmptyBox({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    this.margin,
    this.height,
    this.width,
    this.decoration,
    this.alignment = Alignment.center,
    this.constraints,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: decoration ??
            BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
        color: color,
        padding: padding,
        margin: margin,
        height: height,
        width: width,
        alignment: alignment,
        constraints: constraints,
        child: child,
      ),
    );
  }
}
