import 'package:brain_training_app/patient/appointment/domain/entity/appointment.dart';
import 'package:brain_training_app/patient/appointment/ui/view_model/appointment_vmodel.dart';
import 'package:brain_training_app/patient/appointment/ui/widget/appointment_tile.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class MyAppointmentPage extends StatefulWidget {
  const MyAppointmentPage({super.key});

  @override
  State<MyAppointmentPage> createState() => _MyAppointmentPageState();
}

class _MyAppointmentPageState extends State<MyAppointmentPage> {
  late AppointmentViewModel appointmentViewModel;
  List<Appointment>? appointments;
  List<Appointment>? pendingAppointments;

  @override
  void initState() {
    super.initState();
    appointmentViewModel = Get.find<AppointmentViewModel>();
    callDataInit();
  }

  Future getAppointmentList() async {
    List<Appointment> appts = await appointmentViewModel.getAppointmentList();
    return appts;
  }

  callDataInit() async {
    await getAppointmentList().then(
      (value) => {
        setState(() {
          appointments = value;
          pendingAppointments = appointments!
              .where((element) => element.status == "pending")
              .toList();
        })
      },
    );
  }

  AppointmentTileType checkAppointmentTileType(DateTime date) {
    if (date.isBefore(DateTime.now().toLocal().getDateOnly())) {
      return AppointmentTileType.past;
    } else if (date.isAfter(DateTime.now().toLocal().getDateOnly())) {
      return AppointmentTileType.upcoming;
    } else {
      return AppointmentTileType.current;
    }
  }

  String todayText(String datetime) {
    bool same = isSameDay(
        DateTime.parse(
            DateFormat("yyyy-MM-dd").format(DateTime.now().toLocal())),
        DateTime.parse(datetime));
    return same ? ("Today, " + datetime) : datetime;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          bottom: const TabBar(
              unselectedLabelColor: AppColors.black,
              labelColor: AppColors.brandBlue,
              tabs: [Tab(text: "Pending"), Tab(text: "Timeline")]),
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text("My Appointments",
                style: AppTextStyle.blackTextStyle.merge(AppTextStyle.h2)),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () =>
                Get.offAllNamed(RouteHelper.getPatientHome(), arguments: 2),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: appointments == null
                ? displayLoadingData()
                : appointments!.isEmpty
                    ? displayEmptyDataLoaded("No appointment found", () {
                        Get.offAllNamed(RouteHelper.getPatientHome(),
                            arguments: 2);
                      })
                    : TabBarView(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: 16.h),
                                ...List.generate(
                                  pendingAppointments?.length ?? 0,
                                  (index) => pendingAppointments == null
                                      ? Container()
                                      : Align(
                                          alignment: Alignment.centerRight,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              if (index - 1 != -1 &&
                                                  pendingAppointments![index - 1]
                                                          .date ==
                                                      pendingAppointments![index].date)
                                                SizedBox()
                                              else
                                                Text(
                                                    todayText(
                                                        pendingAppointments![index]
                                                            .date!),
                                                    style: AppTextStyle.h2),
                                              AppointmentTile(
                                                  time: pendingAppointments![index]
                                                      .time!,
                                                  doctorName: appointmentViewModel
                                                      .physiotherapistList
                                                      .firstWhere((element) =>
                                                          element.uid ==
                                                          pendingAppointments![index]
                                                              .physiotherapistID!)
                                                      .name!,
                                                  type: checkAppointmentTileType(
                                                      DateTime.parse(pendingAppointments![index]
                                                          .date!)),
                                                  status: pendingAppointments![index]
                                                      .status,
                                                  img: appointmentViewModel
                                                      .physiotherapistList
                                                      .firstWhere((element) =>
                                                          element.uid ==
                                                          pendingAppointments![index]
                                                              .physiotherapistID!)
                                                      .profilePic!,
                                                  onEdit: () =>
                                                      Get.toNamed(RouteHelper.getAppointmentEditPage(), arguments: pendingAppointments![index]),
                                                  onDelete: () => showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertDialog(
                                                          title: Text(
                                                              "Appointment Date ${pendingAppointments![index].date!} ${pendingAppointments![index].time!} with ${appointmentViewModel.physiotherapistList.firstWhere((element) => element.uid == pendingAppointments![index].physiotherapistID!).name!}",
                                                              style:
                                                                  AppTextStyle
                                                                      .h3),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                Get.back();
                                                              },
                                                              child: const Text(
                                                                  'Cancel'),
                                                            ),
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                Get.back();
                                                                await appointmentViewModel
                                                                    .cancelAppointment(
                                                                        appointment:
                                                                            pendingAppointments![
                                                                                index])
                                                                    .then((value) =>
                                                                        callDataInit());
                                                                setState(() {});
                                                              },
                                                              child: Text(
                                                                  'Delete'),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                            ],
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            // check Future.delayed is useful for me or not
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 16.h),
                                ...List.generate(
                                  appointments?.length ?? 0,
                                  (index) => appointments == null
                                      ? Container()
                                      : Align(
                                          alignment: Alignment.centerRight,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              //         style: AppTextStyle.blackTextStyle)),
                                              if (index - 1 != -1 &&
                                                  appointments![index - 1]
                                                          .date ==
                                                      appointments![index].date)
                                                SizedBox()
                                              else
                                                Text(
                                                    todayText(
                                                        appointments![index]
                                                            .date!),
                                                    style: AppTextStyle.h2),
                                              AppointmentTile(
                                                  time: appointments![index]
                                                      .time!,
                                                  doctorName: appointmentViewModel
                                                      .physiotherapistList
                                                      .firstWhere((element) =>
                                                          element.uid ==
                                                          appointments![index]
                                                              .physiotherapistID!)
                                                      .name!,
                                                  type: checkAppointmentTileType(
                                                      DateTime.parse(appointments![index]
                                                          .date!)),
                                                  status: appointments![index]
                                                      .status,
                                                  img: appointmentViewModel
                                                      .physiotherapistList
                                                      .firstWhere((element) =>
                                                          element.uid ==
                                                          appointments![index]
                                                              .physiotherapistID!)
                                                      .profilePic!,
                                                  onEdit: () =>
                                                      Get.toNamed(RouteHelper.getAppointmentEditPage(), arguments: appointments![index]),
                                                  onDelete: () => showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertDialog(
                                                          title: Text(
                                                              "Appointment Date ${appointments![index].date!} ${appointments![index].time!} with ${appointmentViewModel.physiotherapistList.firstWhere((element) => element.uid == appointments![index].physiotherapistID!).name!}",
                                                              style:
                                                                  AppTextStyle
                                                                      .h3),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                Get.back();
                                                              },
                                                              child: Text(
                                                                  'Cancel'),
                                                            ),
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                Get.back();
                                                                await appointmentViewModel
                                                                    .cancelAppointment(
                                                                        appointment:
                                                                            appointments![
                                                                                index])
                                                                    .then((value) =>
                                                                        callDataInit());
                                                                setState(() {});
                                                              },
                                                              child: Text(
                                                                  'Delete'),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                            ],
                                          ),
                                        ),
                                ),
                              ],
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

extension DateTimeExtension on DateTime {
  DateTime getDateOnly() {
    return DateTime(this.year, this.month, this.day);
  }
}
