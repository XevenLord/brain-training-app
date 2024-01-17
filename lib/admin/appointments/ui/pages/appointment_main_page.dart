import 'dart:math';

import 'package:brain_training_app/admin/appointments/domain/entity/appointment.dart';
import 'package:brain_training_app/admin/appointments/ui/pages/appointment_edit_page.dart';
import 'package:brain_training_app/admin/appointments/ui/view_model/appointment_vmodel.dart';
import 'package:brain_training_app/common/domain/service/user_repo.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

typedef parentFunctionCallback = void Function();

class AdminAppointmentMainPage extends StatefulWidget {
  const AdminAppointmentMainPage({super.key});

  @override
  State<AdminAppointmentMainPage> createState() =>
      _AdminAppointmentMainPageState();
}

class _AdminAppointmentMainPageState extends State<AdminAppointmentMainPage> {
  late AdminAppointmentViewModel _appointmentViewModel;
  // List<AdminAppointment>? appointments;
  // List<AdminAppointment>? pendingAppointments;
  // List<AdminAppointment>? filteredAppointments;
  // List<AdminAppointment>? filteredMeAppointments;
  // List<AdminAppointment>? filteredMeAppointmentsByDay;
  // List<AdminAppointment>? myPendingAppointments;
  List<AppUser>? patients;
  List<AppUser>? admins;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  bool showAll = false;
  bool showMyAll = false;

  @override
  void initState() {
    _appointmentViewModel = Get.find<AdminAppointmentViewModel>();
    getAppointmentList();
    patients = UserRepository.patients;
    admins = UserRepository.admins;
    // fetchAllPatients();
    super.initState();
  }

  void fetchAllPatients() async {
    patients = await UserRepository.fetchAllPatients();
    setState(() {});
  }

  void getAppointmentList() async {
    await _appointmentViewModel.getAppointmentList();
    _appointmentViewModel.filterAppointmentsBySelectedDay(day: _selectedDay);
    _appointmentViewModel.filterMyAppointmentsBySelectedDay(day: _selectedDay);
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant AdminAppointmentMainPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    getAppointmentList();
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

  void navigateToEditPage(AdminAppointment appointment, AppUser patient) async {
    final result = await Get.toNamed(RouteHelper.getAdminAppointmentEditPage(),
            arguments: {
          "appointment": appointment,
          "patient": patient,
        })!
        .then((value) {
      getAppointmentList();
      setState(() {});
    });
  }

  void onCompleteAppointment(AdminAppointment appointment) {
    _appointmentViewModel.completeAppointment(appointment: appointment);
    appointment.status = "completed";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminAppointmentViewModel>(
        init: _appointmentViewModel,
        builder: (_) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                bottom: const TabBar(
                    unselectedLabelColor: AppColors.black,
                    labelColor: AppColors.brandBlue,
                    tabs: [Tab(text: "All"), Tab(text: "Me")]),
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Appointments",
                      style: AppTextStyle.brandBlueTextStyle
                          .merge(AppTextStyle.h2)),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Get.back(), // Or Get.back() if using GetX
                ),
                backgroundColor: Colors.white,
                foregroundColor: AppColors.brandBlue,
                elevation: 0,
              ),
              body: patients == null
                  ? const Center(child: CircularProgressIndicator())
                  : SafeArea(
                      child: Column(
                        children: [
                          TableCalendar(
                            headerStyle: HeaderStyle(
                              titleTextStyle: AppTextStyle.h3,
                              formatButtonVisible: false,
                              leftChevronIcon: const Icon(
                                Icons.chevron_left,
                                color: AppColors.brandBlue,
                              ),
                              rightChevronIcon: const Icon(
                                Icons.chevron_right,
                                color: AppColors.brandBlue,
                              ),
                            ),
                            firstDay: DateTime.utc(2022, 10, 16),
                            lastDay: DateTime.utc(2030, 3, 14),
                            focusedDay: _focusedDay,
                            calendarFormat: _calendarFormat,
                            availableCalendarFormats: const {
                              CalendarFormat.month: 'Week',
                              CalendarFormat.twoWeeks: 'Month',
                              CalendarFormat.week: '2 weeks',
                            },
                            onFormatChanged: (format) {
                              setState(() {
                                _calendarFormat = format;
                              });
                            },
                            selectedDayPredicate: (day) {
                              return isSameDay(_selectedDay, day);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay =
                                    focusedDay; // update `_focusedDay` here as well
                                _.filterAppointmentsBySelectedDay(
                                    day: _selectedDay);
                                _.filterMyAppointmentsBySelectedDay(
                                    day: _selectedDay);
                              });
                            },
                            calendarStyle: CalendarStyle(
                              isTodayHighlighted: true,
                              selectedDecoration: const BoxDecoration(
                                color: AppColors.brandBlue,
                                shape: BoxShape.circle,
                              ),
                              selectedTextStyle: AppTextStyle.h3
                                  .merge(AppTextStyle.whiteTextStyle),
                              todayDecoration: const BoxDecoration(
                                color: AppColors.lightBlue,
                                shape: BoxShape.circle,
                              ),
                              todayTextStyle: AppTextStyle.h3,
                              defaultTextStyle: AppTextStyle.h3
                                  .merge(AppTextStyle.blackTextStyle),
                              weekendTextStyle: AppTextStyle.h3
                                  .merge(AppTextStyle.blackTextStyle),
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                // All tab
                                Column(
                                  children: <Widget>[
                                    if (_.pendingAppointments!.isNotEmpty)
                                      Stack(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Get.toNamed(
                                                      RouteHelper
                                                          .getAdminAppointmentViewRequests(),
                                                      arguments: [
                                                    _.pendingAppointments,
                                                    patients
                                                  ])!
                                                  .then((value) async {
                                                await _.getAppointmentList();
                                                _.filterAppointmentsBySelectedDay(
                                                    day: _selectedDay);
                                                _.filterMyAppointmentsBySelectedDay(
                                                    day: _selectedDay);
                                                setState(() {});
                                              });
                                              setState(() {});
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              side: const BorderSide(
                                                color: AppColors.brandBlue,
                                                width: 1,
                                              ),
                                            ),
                                            child: Text(
                                              "All Appointment Requests",
                                              style: AppTextStyle.h4.merge(
                                                  AppTextStyle
                                                      .brandBlueTextStyle),
                                            ),
                                          ),
                                          Positioned(
                                            top:
                                                0, // Adjust the top position as needed
                                            right:
                                                0, // Adjust the right position as needed
                                            child: Container(
                                              padding: const EdgeInsets.all(
                                                  6), // Adjust the padding as needed
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Text(
                                                _.pendingAppointments!.length
                                                    .toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    Expanded(
                                      child: ListView(
                                        children: <Widget>[
                                          if (_.appointmentsBySelectedDay !=
                                                  null &&
                                              patients != null &&
                                              admins != null)
                                            ..._.appointmentsBySelectedDay!
                                                .map((appt) {
                                              AppUser patient = patients!
                                                  .firstWhere((element) =>
                                                      element.uid ==
                                                      appt.patientID);

                                              AppUser admin = admins!
                                                  .firstWhere((element) =>
                                                      element.uid ==
                                                      appt.physiotherapistID);
                                              return AppointmentCard(
                                                name: patient.name!,
                                                age: calculateAge(
                                                    patient.dateOfBirth),
                                                gender: patient.gender!,
                                                reason: appt.reason!,
                                                physio: admin.name!,
                                                time: appt.time!,
                                                appointment: appt,
                                                onEdit: () =>
                                                    navigateToEditPage(
                                                        appt, patient),
                                                onComplete: () =>
                                                    onCompleteAppointment(appt),
                                              );
                                            }).toList(),
                                          if (_.appointmentsBySelectedDay ==
                                                  null ||
                                              _.appointmentsBySelectedDay!
                                                  .isEmpty)
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 128.w),
                                              child: Center(
                                                  child: Text(
                                                      "No appointments for this day",
                                                      style: AppTextStyle.h2)),
                                            ),
                                          SizedBox(height: 20.w)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                // My tab
                                Column(
                                  children: <Widget>[
                                    SizedBox(height: 10.w),
                                    if (_.myPendingAppointments!.isNotEmpty)
                                      Stack(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Get.toNamed(
                                                      RouteHelper
                                                          .getAdminAppointmentViewRequests(),
                                                      arguments: [
                                                    _.myPendingAppointments,
                                                    patients,
                                                  ])!
                                                  .then((value) async {
                                                await _.getAppointmentList();
                                                _.filterAppointmentsBySelectedDay(
                                                    day: _selectedDay);
                                                _.filterMyAppointmentsBySelectedDay(
                                                    day: _selectedDay);
                                                setState(() {});
                                              });
                                              setState(() {});
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              side: const BorderSide(
                                                color: AppColors.brandBlue,
                                                width: 1,
                                              ),
                                            ),
                                            child: Text(
                                              "My Appointment Requests",
                                              style: AppTextStyle.h4.merge(
                                                  AppTextStyle
                                                      .brandBlueTextStyle),
                                            ),
                                          ),
                                          Positioned(
                                            top:
                                                0, // Adjust the top position as needed
                                            right:
                                                0, // Adjust the right position as needed
                                            child: Container(
                                              padding: const EdgeInsets.all(
                                                  6), // Adjust the padding as needed
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Text(
                                                _.myPendingAppointments!.length
                                                    .toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    Expanded(
                                      child: ListView(
                                        children: <Widget>[
                                          if (_.myAppointmentsBySelectedDay !=
                                                  null &&
                                              patients != null &&
                                              admins != null)
                                            ..._.myAppointmentsBySelectedDay!
                                                .map((appt) {
                                              AppUser patient = patients!
                                                  .firstWhere((element) =>
                                                      element.uid ==
                                                      appt.patientID);

                                              AppUser admin = admins!
                                                  .firstWhere((element) =>
                                                      element.uid ==
                                                      appt.physiotherapistID);
                                              return AppointmentCard(
                                                name: patient.name!,
                                                age: calculateAge(
                                                    patient.dateOfBirth),
                                                gender: patient.gender!,
                                                reason: appt.reason!,
                                                physio: admin.name!,
                                                time: appt.time!,
                                                appointment: appt,
                                                onEdit: () =>
                                                    navigateToEditPage(
                                                        appt, patient),
                                                onComplete: () =>
                                                    onCompleteAppointment(appt),
                                              );
                                            }).toList(),
                                          if (_.myAppointmentsBySelectedDay ==
                                                  null ||
                                              _.myAppointmentsBySelectedDay!
                                                  .isEmpty)
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 128.w),
                                              child: Center(
                                                  child: Text(
                                                      "No appointments for this day",
                                                      style: AppTextStyle.h2)),
                                            ),
                                          SizedBox(height: 20.w)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          );
        });
  }
}

class AppointmentCard extends StatelessWidget {
  final String name;
  final String age;
  final String gender;
  final String reason;
  final String time;
  final String physio;
  AdminAppointment appointment;
  Function()? onEdit;
  Function()? onComplete;
  Function()? onReject;

  AppointmentCard({
    required this.name,
    required this.age,
    required this.gender,
    required this.reason,
    required this.time,
    required this.physio,
    required this.appointment,
    this.onEdit,
    this.onComplete,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const Icon(Icons.more_vert, color: Colors.black54),
            ],
          ),
          CardWidget(
            name: name,
            age: age,
            gender: gender,
            reason: reason,
            status: appointment.status!,
            physio: physio,
            appointment: appointment,
            onEdit: onEdit,
            onComplete: onComplete,
            onReject: onReject,
          ),
        ],
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String name;
  final String age;
  final String gender;
  final String reason;
  final String status;
  final String physio;
  AdminAppointment appointment;
  Function()? onEdit;
  Function()? onComplete;
  Function()? onReject;

  CardWidget({
    required this.name,
    required this.age,
    required this.gender,
    required this.reason,
    required this.status,
    required this.physio,
    required this.appointment,
    this.onEdit,
    this.onComplete,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Text(
            name,
            style: AppTextStyle.h2,
          ),
          SizedBox(height: 8.w),
          InformationRow(title: 'Age', value: age),
          SizedBox(height: 2.w),
          InformationRow(title: 'Gender', value: gender),
          SizedBox(height: 2.w),
          if (reason.isNotEmpty) InformationRow(title: 'Reason', value: reason),
          SizedBox(height: 2.w),
          InformationRow(title: 'Status', value: status),
          SizedBox(height: 2.w),
          InformationRow(title: 'Physiotherapist', value: physio),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(10.w)),
                  child: IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, color: Colors.blue))),
              Container(
                  height: 50.w,
                  width: appointment.status == "completed" ? 50.w : 120.w,
                  decoration: BoxDecoration(
                      color: appointment.status == "completed"
                          ? Colors.green
                          : AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(20.w)),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: appointment.status == "completed"
                          ? Colors.green
                          : appointment.status == "expired"
                              ? AppColors.lightRed
                              : AppColors.lightBlue,
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: onComplete,
                    child: appointment.status == "completed"
                        ? const Icon(Icons.check, color: Colors.white)
                        : Text(
                            appointment.status == "expired"
                                ? "Complete (Expired)"
                                : "Complete",
                            textAlign: TextAlign.center,
                            style: AppTextStyle.h3.merge(
                                appointment.status == "expired"
                                    ? AppTextStyle.brandRedTextStyle
                                    : AppTextStyle.brandBlueTextStyle),
                          ),
                    // Icon(Icons.check,
                    //     color: appointment.status == "completed"
                    //         ? Colors.white
                    //         : Colors.blue),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class InformationRow extends StatelessWidget {
  final String title;
  final String value;
  bool isWrapped;

  InformationRow(
      {required this.title, required this.value, this.isWrapped = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('$title', style: AppTextStyle.h3),
          SizedBox(width: 10.w),
          Flexible(
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                '$value',
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.h3,
                softWrap: isWrapped,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
