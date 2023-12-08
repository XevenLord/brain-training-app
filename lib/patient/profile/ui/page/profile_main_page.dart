import 'package:brain_training_app/common/ui/widget/empty_box.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/profile/ui/view_model/profile_vmodel.dart';
import 'package:brain_training_app/patient/profile/ui/widget/info_tile.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProfileMainPage extends StatefulWidget {
  ProfileMainPage({super.key});

  @override
  State<ProfileMainPage> createState() => _ProfileMainPageState();
}

class _ProfileMainPageState extends State<ProfileMainPage> {
  late ProfileViewModel profileVModel;
  AppUser appUser = Get.find<AppUser>();

  @override
  void initState() {
    super.initState();
    profileVModel = Get.find<ProfileViewModel>();
    appUser = Get.find<AppUser>();
    print(appUser.toJson());
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Use Future Builder
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        // Circle Avatar Picture
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("About Yourself",
                style: AppTextStyle.h2.merge(AppTextStyle.brandBlueTextStyle)),
            SizedBox(
              height: 12.h,
            ),
            Center(
              child: CircleAvatar(
                radius: 70.r,
                child: appUser.profilePic != null &&
                        appUser.profilePic!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(69.r),
                        child: Image(
                          image: NetworkImage(appUser.profilePic! as String),
                          width: 100,
                          height: 100,
                          fit: BoxFit.fill,
                        ))
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        )),
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            appUser.aboutMe != null && appUser.aboutMe!.isNotEmpty
                ? EmptyBox(
                    decoration: BoxDecoration(
                        color: AppColors.brandBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.r)),
                    child:
                        Text('"${appUser.aboutMe!}"', style: AppTextStyle.h3))
                : EmptyBox(
                    decoration: BoxDecoration(
                        color: AppColors.lightBlue.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10.r)),
                    child: Text('Edit to add self-description',
                        style: AppTextStyle.h3)),
          ],
        ),
        SizedBox(height: 20.h),
        InfoTile(title: "Name", label: appUser.name!),
        InfoTile(title: "IC Number", label: appUser.icNumber!),
        InfoTile(title: "Email", label: appUser.email!),
        InfoTile(title: "Phone", label: appUser.phoneNumber!),
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
            backgroundColor: AppColors.lightBlue,
            child: IconButton(
              color: AppColors.white,
              onPressed: () {
                Get.toNamed(RouteHelper.getProfileEditPage());
              },
              icon: const Icon(Icons.edit, color: AppColors.brandBlue),
            ),
          ),
        )
      ],
    );
  }
}
