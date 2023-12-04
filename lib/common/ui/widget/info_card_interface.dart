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
}

