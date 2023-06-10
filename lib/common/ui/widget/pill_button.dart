import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class PillButton extends StatefulWidget {
  String text;
  EdgeInsets padding;
  EdgeInsets? margin;
  Function()? onTap;


  PillButton({
    super.key,
    required this.text,
    this.padding = const EdgeInsets.all(8),
    this.margin,
    this.onTap,
  });

  @override
  State<PillButton> createState() => _PillButtonState();
}

class _PillButtonState extends State<PillButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 2,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        padding: widget.padding,
        margin: widget.margin,
        child: Text(widget.text),
      ),
    );
  }
}
