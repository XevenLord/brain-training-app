import 'package:brain_training_app/patient/appointment/ui/view_model/appointment_vmodel.dart';
import 'package:brain_training_app/patient/appointment/ui/widget/doctor_card.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppointmentMainPage extends StatefulWidget {
  const AppointmentMainPage({super.key});

  @override
  State<AppointmentMainPage> createState() => _AppointmentMainPageState();
}

class _AppointmentMainPageState extends State<AppointmentMainPage> {
  late AppointmentViewModel appointmentViewModel;
  List<AppUser> physiotherapists = [];
  AppUser? assignedPhysio;

  @override
  void initState() {
    super.initState();
    appointmentViewModel = Get.find<AppointmentViewModel>();
    if (appointmentViewModel.physiotherapistList.isEmpty) {
      getPhysiotherapistList();
    } else {
      physiotherapists = appointmentViewModel.physiotherapistList;
    }
    if (Get.find<AppUser>().assignedTo != null) {
      assignedPhysio =physiotherapists.firstWhere(
          (element) => element.uid == Get.find<AppUser>().assignedTo);
    }
    print("physiotherapists: $physiotherapists");
  }

  void getPhysiotherapistList() async {
    physiotherapists = await appointmentViewModel.getPhysiotherapistList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return physiotherapists.isEmpty
        ? const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : SingleChildScrollView(
            key: PageStorageKey("appts"),
            child: Column(
              children: [
                assignedPhysio != null
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                style: AppTextStyle.h3.merge(
                                    const TextStyle(color: Colors.black)),
                                children: [
                                  const TextSpan(
                                    text: "You are assigned to:  ",
                                  ),
                                  TextSpan(
                                    text: "Dr. ${assignedPhysio!.name!}",
                                    style: AppTextStyle.h2
                                        .merge(AppTextStyle.brandBlueTextStyle),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8.h),
                          ],
                        ),
                      )
                    : Container(),
                assignedPhysio != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width:
                                (MediaQuery.of(context).size.width - 60.w) / 2,
                            child: DoctorCard(
                              doctorName: assignedPhysio!.name!,
                              position: assignedPhysio!.position!,
                              imgUrl: assignedPhysio!.profilePic!,
                              email: assignedPhysio!.email!,
                              isAssignedPhysio:
                                  Get.find<AppUser>().assignedTo ==
                                          assignedPhysio!.uid
                                      ? true
                                      : false,
                              onTap: () {
                                appointmentViewModel.setChosenPhysiotherapist(
                                  physiotherapist: assignedPhysio!,
                                );
                                Get.toNamed(
                                    RouteHelper.getAppointmentBookingPage());
                              },
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text("All practitioners below:",
                                style: AppTextStyle.h3),
                          ),
                        ],
                      )
                    : Align(
                        alignment: Alignment.bottomLeft,
                        child: Text("Select a practitioner to make appointment:",
                            style: AppTextStyle.h3)),
                SizedBox(height: 8.h),
                GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16.w,
                    shrinkWrap: true, // Add this line
                    physics:
                        const NeverScrollableScrollPhysics(), // Add this line
                    children: [
                      ...List.generate(
                        physiotherapists.length,
                        (index) => DoctorCard(
                          doctorName: physiotherapists[index].name!,
                          position: physiotherapists[index].position!,
                          imgUrl: physiotherapists[index].profilePic!,
                          email: physiotherapists[index].email!,
                          isAssignedPhysio: Get.find<AppUser>().assignedTo ==
                                  physiotherapists[index].uid
                              ? true
                              : false,
                          onTap: () {
                            appointmentViewModel.setChosenPhysiotherapist(
                              physiotherapist: physiotherapists[index],
                            );
                            Get.toNamed(
                                RouteHelper.getAppointmentBookingPage());
                          },
                        ),
                      ),
                    ]),
                SizedBox(height: 60.h),
              ],
            ),
          );
  }
}
