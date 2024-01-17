import 'package:brain_training_app/patient/appointment/domain/entity/appointment.dart';
import 'package:brain_training_app/patient/appointment/ui/view_model/appointment_vmodel.dart';
import 'package:brain_training_app/patient/appointment/ui/widget/appointment_tile.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class PatientAppointmentPage extends StatefulWidget {
  AppUser patient;
  PatientAppointmentPage({super.key, required this.patient});

  @override
  State<PatientAppointmentPage> createState() => _PatientAppointmentPageState();
}

class _PatientAppointmentPageState extends State<PatientAppointmentPage> {
  late AppointmentViewModel appointmentViewModel;
  List<Appointment>? appointments;

  @override
  void initState() {
    super.initState();
    appointmentViewModel = Get.find<AppointmentViewModel>();
    if (appointmentViewModel.physiotherapistList.isEmpty) {
      getPhysiotherapistList();
    }
    callDataInit();
  }

  Future getAppointmentList() async {
    List<Appointment> appts =
        await appointmentViewModel.getAppointmentsByID(widget.patient.uid!);
    return appts;
  }

  void getPhysiotherapistList() async {
    await appointmentViewModel.getPhysiotherapistList();
    setState(() {});
  }

  callDataInit() async {
    await getAppointmentList().then(
      (value) => {
        setState(() {
          appointments = value;
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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: appointments == null
              ? displayLoadingData()
              : appointments!.isEmpty
                  ? displayEmptyDataLoaded("No appointment found", onBack: () {
                      Get.back();
                    })
                  : SingleChildScrollView(
                      // check Future.delayed is useful for me or not
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: Icon(Icons.arrow_back_ios),
                                ),
                              ),
                              Text("Appointments", style: AppTextStyle.h2),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Align(
                            alignment: Alignment.center,
                            child: Text("${widget.patient.name}",
                                style: AppTextStyle.h2
                                    .merge(AppTextStyle.brandBlueTextStyle)),
                          ),
                          SizedBox(height: 24.h),
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
                                            appointments![index - 1].date ==
                                                appointments![index].date)
                                          SizedBox()
                                        else
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                                todayText(
                                                    appointments![index].date!),
                                                style: AppTextStyle.h2),
                                          ),
                                        AppointmentTile(
                                            time: appointments![index].time!,
                                            status:
                                                appointments![index].status!,
                                            doctorName: appointmentViewModel
                                                .physiotherapistList
                                                .firstWhere((element) =>
                                                    element.uid ==
                                                    appointments![index]
                                                        .physiotherapistID!)
                                                .name!,
                                            type: checkAppointmentTileType(DateTime.parse(
                                                appointments![index].date!)),
                                            img: appointmentViewModel
                                                .physiotherapistList
                                                .firstWhere((element) =>
                                                    element.uid ==
                                                    appointments![index]
                                                        .physiotherapistID!)
                                                .profilePic!,
                                            onEdit: () => Get.toNamed(
                                                RouteHelper.getAppointmentEditPage(),
                                                arguments: appointments![index]),
                                            onDelete: () => showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title: Text(
                                                        "Appointment Date ${appointments![index].date!} ${appointments![index].time!} with ${appointmentViewModel.physiotherapistList.firstWhere((element) => element.uid == appointments![index].physiotherapistID!).name!}",
                                                        style: AppTextStyle.h3),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child: Text('Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
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
                                                        child: Text('Delete'),
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
