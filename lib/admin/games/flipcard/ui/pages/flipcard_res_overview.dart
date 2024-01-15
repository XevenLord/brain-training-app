import 'package:brain_training_app/admin/games/flipcard/domain/entity/flipcard_set.dart';
import 'package:brain_training_app/admin/games/flipcard/ui/view_model/flipcard_vmodel.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FlipCardResultOverview extends StatefulWidget {
  AppUser patient;
  List<FlipCardSet>? flipCardSet;
  FlipCardResultOverview({super.key, required this.patient, this.flipCardSet});

  @override
  State<FlipCardResultOverview> createState() => _FlipCardResultOverviewState();
}

class _FlipCardResultOverviewState extends State<FlipCardResultOverview> {
  late AdminFlipCardViewModel adminFlipCardViewModel =
      Get.find<AdminFlipCardViewModel>();
  List<FlipCardSet> flipCardSet = [];
  int index = 1;
  bool isLoading = true;

  @override
  void initState() {
    print(widget.flipCardSet.toString());
    flipCardSet = widget.flipCardSet!;
    isLoading = false;

    setState(() {});
    super.initState();
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
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Flip Card Result Overview",
            style: AppTextStyle.h2,
          ),
        ),
        body: SafeArea(
          child: flipCardSet.isEmpty
              ? Center(
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              Image.asset(
                                AppConstant.EMPTY_DATA,
                                width: 200,
                                height: 200,
                              ),
                              Text("There is no data of Flip Card result yet.",
                                  style: AppTextStyle.h2
                                      .merge(AppTextStyle.brandBlueTextStyle))
                            ]),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(children: [
                      SizedBox(height: 10.h),
                      Row(
                        // mainAxisAlignment: MainAxisAlignments.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 32.r,
                            backgroundColor: AppColors.lightBlue,
                            backgroundImage:
                                (widget.patient.profilePic == null ||
                                        widget.patient.profilePic!.isEmpty)
                                    ? const AssetImage(
                                        AppConstant.NO_PROFILE_PIC,
                                      ) as ImageProvider
                                    : NetworkImage(widget.patient.profilePic!),
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.patient.name!,
                                  style: AppTextStyle.h2),
                              Text(
                                  "Age: ${calculateAge(widget.patient.dateOfBirth)}",
                                  style: AppTextStyle.h3),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      ...flipCardSet.map((cardSet) {
                        return ExpansionTile(
                          title: Text(cardSet.id ?? "", style: AppTextStyle.h3),
                          children: cardSet.flipCards!.map((card) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 8.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${card.timestamp.toString()}',
                                    style: AppTextStyle.h3,
                                  ),
                                  Text(
                                    '${card.level.toUpperCase()}',
                                    style: AppTextStyle.h3.merge(TextStyle(
                                        color: card.level == 'Easy'
                                            ? Colors.green
                                            : card.level == 'Medium'
                                                ? Colors.orange
                                                : Colors.red)),
                                  ),
                                  Text(
                                    '${card.second.toString()} seconds',
                                    style: AppTextStyle.h3,
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ]),
                  ),
                ),
        ));
  }
}
