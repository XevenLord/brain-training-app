import 'package:brain_training_app/admin/profile/ui/view_model/admin_profile_view_model.dart';
import 'package:brain_training_app/admin/profile/ui/widgets/info_tile.dart';
import 'package:brain_training_app/common/ui/widget/empty_box.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  late AdminProfileViewModel profileVM;
  late AppUser appUser;

  @override
  void initState() {
    profileVM = Get.find<AdminProfileViewModel>();
    appUser = Get.find<AppUser>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            // Circle Avatar Picture
            appUser != null &&
                    appUser.aboutMe != null &&
                    appUser.aboutMe!.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Admin Profile",
                          style: AppTextStyle.h2
                              .merge(AppTextStyle.brandBlueTextStyle)),
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
                                    image: NetworkImage(
                                        appUser.profilePic! as String),
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
                      EmptyBox(
                          decoration: BoxDecoration(
                              color: AppColors.brandBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10.r)),
                          child: Text('"${appUser.aboutMe!}"',
                              style: AppTextStyle.h3)),
                    ],
                  )
                : Container(),
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
                backgroundColor: AppColors.brandBlue,
                child: IconButton(
                  color: AppColors.white,
                  onPressed: () {
                    Get.toNamed(RouteHelper.getAdminProfileEdit(),
                        arguments: appUser);
                  },
                  icon: const Icon(Icons.edit),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
