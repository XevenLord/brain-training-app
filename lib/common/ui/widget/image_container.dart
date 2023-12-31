// ignore_for_file: prefer_const_constructors

import 'package:brain_training_app/common/domain/entity/message_chat.dart';
import 'package:flutter/material.dart';

class ImageContainer extends StatefulWidget {
  final MessageChat messageChat;
  const ImageContainer({Key? key, required this.messageChat}) : super(key: key);

  @override
  State<ImageContainer> createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Image.network(
        widget.messageChat.msg!,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.25),
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            width: 200,
            height: 200,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, object, stackTrace) {
          return Material(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              clipBehavior: Clip.hardEdge,
              child: Icon(Icons.no_photography));
        },
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      ),
    );
  }
}