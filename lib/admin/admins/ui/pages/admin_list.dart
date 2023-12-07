import 'package:brain_training_app/common/domain/service/user_repo.dart';
import 'package:brain_training_app/common/ui/widget/info_card.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminList extends StatefulWidget {
  const AdminList({super.key});

  @override
  State<AdminList> createState() => _AdminListState();
}

class _AdminListState extends State<AdminList> {
  late UserRepository userRepo;
  late List<AppUser> admins;
  bool isLoading = true;

  @override
  void initState() {
    userRepo = Get.find<UserRepository>();
    fetchAdmins();
    super.initState();
  }

  void fetchAdmins() async {
    try {
      await userRepo.fetchAllAdmins();
      setState(() {
        admins = userRepo.getAdminUsers;
        isLoading = false;
      });
    } catch (e) {
      debugModePrint(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  String calculateAge(DateTime? dateOfBirth) {
    if (dateOfBirth == null) {
      return 'N/A';
    }

    final currentDate = DateTime.now();
    final age = currentDate.year - dateOfBirth.year;

    if (currentDate.month < dateOfBirth.month ||
        (currentDate.month == dateOfBirth.month &&
            currentDate.day < dateOfBirth.day)) {
      return (age - 1)
          .toString(); // Subtract 1 if birthday hasn't occurred this year yet
    }

    return age.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text("Admin List",
              style: AppTextStyle.brandBlueTextStyle.merge(AppTextStyle.h2)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.brandBlue),
          onPressed: () => Get.back(), // Or Get.back() if using GetX
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...admins.map(
                      (e) => InfoCardTile().buildInfoCard(
                        name: e.name!,
                        age: calculateAge(e.dateOfBirth),
                        gender: e.gender!,
                        position: e.role,
                        onEdit: () {
                          Get.toNamed(RouteHelper.getPatientOverviewPage(),
                              arguments: e);
                        },
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 30.w),
                        child: Column(
                          children: [
                            IconButton(
                              iconSize: 60.w,
                              icon: Icon(Icons.add_circle,
                                  color: Colors.blue, size: 60.w),
                              onPressed: () {},
                            ),
                            Text("Add New Admin",
                                style: AppTextStyle.h3
                                    .merge(AppTextStyle.brandBlueTextStyle)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
