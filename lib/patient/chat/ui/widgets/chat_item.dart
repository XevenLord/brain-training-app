import 'package:brain_training_app/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatItem extends StatefulWidget {
  String name;
  Function()? onTap;

  ChatItem({super.key, required this.name, required this.onTap});

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                "assets/images/noProfilePic.png",
                height: Get.width * 0.07,
                width: Get.width * 0.07,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Hello, How are you?',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  '10:00 AM',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.blue,
                  child: Text(
                    '2',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
