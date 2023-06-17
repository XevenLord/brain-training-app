import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/profile/ui/widget/info_tile.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProfileMainPage extends StatefulWidget {
  ProfileMainPage({super.key});

  @override
  State<ProfileMainPage> createState() => _ProfileMainPageState();
}

class _ProfileMainPageState extends State<ProfileMainPage> {
  final AppUser appUser = Get.find<AppUser>();

  Map<String, String> info = {
    "Name": "Nguyen Van A",
    "Email": "chuazonghong@hotmail.com",
    "Phone Number": "01109329302",
    "Gender": "Male",
    "Date of Birth": "12/12/1999",
    "Address": "123, Jalan 1, Taman 2, 12345, Kuala Lumpur",
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        InfoTile(title: "Name", label: appUser.name!),
        InfoTile(title: "IC Number", label: appUser.icNumber!),
        InfoTile(title: "Email", label: appUser.email!),
        InfoTile(title: "Gender", label: appUser.gender!),
        InfoTile(
            title: "Date Of Birth",
            label: DateFormat('yyyy-MM-dd').format(appUser.dateOfBirth!)),
        const SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: CircleAvatar(
            radius: 30.r,
            backgroundColor: AppColors.brandBlue,
            child: IconButton(
              color: AppColors.white,
              onPressed: () {},
              icon: Icon(Icons.edit),
            ),
          ),
        )
      ],
    );
  }
}
