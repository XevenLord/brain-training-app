import 'package:brain_training_app/common/ui/widget/empty_box.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/profile/ui/view_model/profile_vmodel.dart';
import 'package:brain_training_app/patient/profile/ui/widget/info_tile.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_constant.dart';
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
    profileVModel = Get.find<ProfileViewModel>();
    appUser = Get.find<AppUser>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Use Future Builder
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          // Circle Avatar Picture
          SizedBox(
            height: 12.h,
          ),
          Center(
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      insetPadding: EdgeInsets.zero,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: appUser.profilePic != null &&
                                    appUser.profilePic!.isNotEmpty
                                ? Image.network(
                                    appUser.profilePic!,
                                    fit: BoxFit.contain,
                                  )
                                : const Image(
                                    image:
                                        AssetImage(AppConstant.NO_PROFILE_PIC),
                                    fit: BoxFit.contain,
                                  )),
                      ),
                    );
                  },
                );
              },
              child: CircleAvatar(
                radius: 70.r,
                backgroundColor: AppColors.lightBlue,
                backgroundImage:
                    appUser.profilePic != null && appUser.profilePic!.isNotEmpty
                        ? NetworkImage(
                            appUser.profilePic!,
                          )
                        : const AssetImage(
                            AppConstant.NO_PROFILE_PIC,
                          ) as ImageProvider,
              ),
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
                  child: Text('"${appUser.aboutMe!}"', style: AppTextStyle.h3))
              : EmptyBox(
                  decoration: BoxDecoration(
                      color: AppColors.lightBlue.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10.r)),
                  child: Text('Edit to add self-description',
                      style: AppTextStyle.h3.merge(
                          const TextStyle(fontStyle: FontStyle.italic)))),
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
      ),
    );
  }
}
