import 'package:brain_training_app/admin/games/maths/ui/view_model/math_result_vmodel.dart';
import 'package:brain_training_app/common/domain/service/user_repo.dart';
import 'package:brain_training_app/common/ui/widget/info_card.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MathPatientList extends StatefulWidget {
  const MathPatientList({super.key});

  @override
  State<MathPatientList> createState() => _MathPatientListState();
}

class _MathPatientListState extends State<MathPatientList> {
  late UserRepository userRepo;
  late MathResultViewModel mathResultViewModel;
  dynamic patients;
  bool isLoading = true;

  @override
  void initState() {
    mathResultViewModel = Get.find<MathResultViewModel>();
    userRepo = Get.find<UserRepository>();
    mathResultViewModel.getMathUserIdList();
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
    dynamic filteredPatients = patients.where((element) =>
        mathResultViewModel.matchedUserIdList.contains(element.uid));
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
        title: Text('Arithmetic Game', style: AppTextStyle.h2),
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
            : SingleChildScrollView(
                child: Padding(
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
                            dynamic mathAns = await mathResultViewModel
                                .getMathAnswersByUserId(e.uid!);
                            setState(() {});
                            Get.toNamed(RouteHelper.getMathScoreOverview(),
                                arguments: [e, mathAns]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
