import 'package:brain_training_app/common/domain/service/user_repo.dart';
import 'package:brain_training_app/common/ui/widget/info_card.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/route_helper.dart';
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
  late List<AppUser> patients;
  bool isLoading = true;

  @override
  void initState() {
    userRepo = Get.find<UserRepository>();
    fetchPatients();
    super.initState();
  }

  void fetchPatients() async {
    try {
      patients = await UserRepository.fetchAllPatients();
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
        backgroundColor: Colors.white,
        foregroundColor: AppColors.brandBlue,
        title: const Text('Mathematics Game'),
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
                    ...patients.map(
                      (e) => InfoCardTile().buildInfoCard(
                        name: e.name!,
                        age: calculateAge(e.dateOfBirth),
                        gender: e.gender!,
                        isView: true,
                        onEdit: () {
                          Get.toNamed(RouteHelper.getMathScoreOverview(),
                              arguments: e);
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
