import 'package:brain_training_app/admin/games/tzfe/ui/view_model/tzfe_vmodel.dart';
import 'package:brain_training_app/common/domain/service/user_repo.dart';
import 'package:brain_training_app/common/ui/widget/info_card.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TZFEPatientList extends StatefulWidget {
  const TZFEPatientList({super.key});

  @override
  State<TZFEPatientList> createState() => _TZFEPatientListState();
}

class _TZFEPatientListState extends State<TZFEPatientList> {
  late UserRepository userRepo;
  late AdminTZFEViewModel adminTZFEViewModel;
  dynamic patients;
  bool isLoading = true;

  @override
  void initState() {
    adminTZFEViewModel = Get.find<AdminTZFEViewModel>();
    userRepo = Get.find<UserRepository>();
    adminTZFEViewModel.getTZFEUserIdList();
    fetchPatients();
    super.initState();
  }

  void fetchPatients() async {
    try {
      patients = await UserRepository.fetchAllPatients();
      filterPatientByGame();
      setState(() {
        isLoading = false; // Set loading to false after data is fetched
      });
    } catch (e) {
      // Handle any potential errors during data fetching
      print(e);
      setState(() {
        isLoading = false; // Set loading to false even on error
      });
    }
  }

  void filterPatientByGame() {
    dynamic filteredPatients = patients!.where((element) =>
        adminTZFEViewModel.matchedUserIdList.contains(element.uid));
    setState(() {
      patients = filteredPatients;
    });
  }

  String calculateAge(DateTime? dateOfBirth) {
    print("Calculate age");
    print(dateOfBirth.runtimeType);
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
        backgroundColor: Colors.white,
        foregroundColor: AppColors.brandBlue,
        title: Text('2048 Game', style: AppTextStyle.h2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : (patients == null || patients!.isEmpty)
                ? Center(
                    child: displayEmptyDataLoaded(
                      "There is no data of 2048 Game yet.",
                      showBackArrow: false,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...patients.map(
                          (e) => InfoCardTile().buildInfoCard(
                            name: e.name!,
                            age: calculateAge(e.dateOfBirth),
                            gender: e.gender!,
                            isView: true,
                            onEdit: () async {
                              dynamic tzfeSets = await adminTZFEViewModel
                                  .getTZFEScoreSetByUserId(e.uid!);
                              setState(() {});
                              Get.toNamed(RouteHelper.getTZFEScoreOverview(),
                                  arguments: [e, tzfeSets]);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
