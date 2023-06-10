import 'package:brain_training_app/common/ui/widget/screen.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Screen(
        appBar: AppBar(
          foregroundColor: AppColors.brandBlue,
          backgroundColor: AppColors.white,
          centerTitle: true,
          title: Text(
            'Chat',
            style: AppTextStyle.h2,
          ),
        ),
        body: Column(children: []));
  }
}
