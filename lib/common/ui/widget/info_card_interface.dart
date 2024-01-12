import 'package:flutter/material.dart';

abstract class InfoCardInterface {
  Widget buildInfoCard({
    required String name,
    required String gender,
    required String age,
    bool hasEditIcon,
    bool hasCheckIcon,
    Function()? onEdit,
    Function()? onCheck,
  });

  Widget buildRequestCard({
    required String name,
    required String gender,
    required String age,
    required String imgUrl,
    required String date,
    required String time,
    required String reason,
    Function()? onAccept,
    Function()? onDecline,
  });
}
