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
  late UserRepository? _userRepo;
  List<AdminAppointment>? appointments;
  List<AdminAppointment>? filteredAppointments;
  List<AdminAppointment>? filteredMeAppointments;
  List<AdminAppointment>? filteredMeAppointmentsByDay;
  List<AdminAppointment>? pendingAppointments;
  List<AppUser>? patients;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  void initState() {
    _appointmentViewModel = Get.find<AdminAppointmentViewModel>();
    getAppointmentList();
    fetchAllPatients();
    super.initState();
  }

  void fetchAllPatients() async {
    patients = await UserRepository.fetchAllPatients();
    setState(() {});
  }

  void getAppointmentList() async {
    appointments = await _appointmentViewModel.getAppointmentList();
    filterAppointmentByDay();
    filteredMeAppointments = _appointmentViewModel.filterAppointmentByMe();
    pendingAppointments = filteredAppointments!
        .where((element) => element.status == "pending")
        .toList();
    filterMeAppointmentByDay();
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant AdminAppointmentMainPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    getAppointmentList();
  }

  void filterAppointmentByDay() {
    filteredAppointments = _appointmentViewModel.filterAppointmentByDay(
        day: _selectedDay, appts: appointments!);
    filteredAppointments = filteredAppointments!.reversed.toList();
    setState(() {});
  }

  void filterMeAppointmentByDay() {
    filteredMeAppointmentsByDay = _appointmentViewModel.filterAppointmentByDay(
        day: _selectedDay, appts: filteredMeAppointments!);
    filteredMeAppointmentsByDay =
        filteredMeAppointmentsByDay!.reversed.toList();
    setState(() {});
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

  void navigateToEditPage(AdminAppointment appointment) async {
    final result = await Get.to(
      AdminAppointmentEditPage(appointment: appointment),
    );

    // Check if the result is true (operation was successful)
    if (result == true) {
      getAppointmentList(); // Fetch updated data
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          bottom: const TabBar(
              unselectedLabelColor: AppColors.brandBlue,
              labelColor: AppColors.black,
              tabs: [Tab(text: "All"), Tab(text: "Me")]),
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text("Appointments",
                style: AppTextStyle.blackTextStyle.merge(AppTextStyle.h2)),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(), // Or Get.back() if using GetX
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: appointments == null || patients == null
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Column(
                  children: [
                    TableCalendar(
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
                          filteredAppointments =
                              _appointmentViewModel.filterAppointmentByDay(
                                  day: _selectedDay, appts: appointments!);
                          filteredMeAppointmentsByDay =
                              _appointmentViewModel.filterAppointmentByDay(
                                  day: _selectedDay,
                                  appts: filteredMeAppointments!);
                        });
                      },
                      calendarStyle: CalendarStyle(
                        isTodayHighlighted: true,
                        selectedDecoration: const BoxDecoration(
                          color: AppColors.brandBlue,
                          shape: BoxShape.circle,
                        ),
                        selectedTextStyle:
                            AppTextStyle.h3.merge(AppTextStyle.whiteTextStyle),
                        todayDecoration: const BoxDecoration(
                          color: AppColors.lightBlue,
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: AppTextStyle.h3,
                        defaultTextStyle:
                            AppTextStyle.h3.merge(AppTextStyle.blackTextStyle),
                        weekendTextStyle:
                            AppTextStyle.h3.merge(AppTextStyle.blackTextStyle),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // All tab
                          Column(
                            children: <Widget>[
                              Expanded(
                                child: ListView(
                                  children: <Widget>[
                                    if (filteredAppointments != null &&
                                        patients != null)
                                      ...filteredAppointments!.map((appt) {
                                        AppUser patient = patients!.firstWhere(
                                            (element) =>
                                                element.uid == appt.patientID);
                                        return AppointmentCard(
                                          name: patient.name!,
                                          age:
                                              calculateAge(patient.dateOfBirth),
                                          gender: patient.gender!,
                                          reason: appt.reason!,
                                          time: appt.time!,
                                          appointment: appt,
                                          onEdit: () =>
                                              navigateToEditPage(appt),
                                        );
                                      }).toList(),
                                    if (filteredAppointments!.isEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(top: 128.w),
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
                              Stack(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side: const BorderSide(
                                        color: AppColors.brandBlue,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      "Appointment Requests",
                                      style: AppTextStyle.h4.merge(
                                          AppTextStyle.brandBlueTextStyle),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0, // Adjust the top position as needed
                                    right:
                                        0, // Adjust the right position as needed
                                    child: Container(
                                      padding: EdgeInsets.all(
                                          6), // Adjust the padding as needed
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        "2",
                                        style: TextStyle(
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
                                    if (filteredMeAppointmentsByDay != null &&
                                        patients != null)
                                      ...filteredMeAppointmentsByDay!
                                          .map((appt) {
                                        AppUser patient = patients!.firstWhere(
                                            (element) =>
                                                element.uid == appt.patientID);
                                        return AppointmentCard(
                                          name: patient.name!,
                                          age:
                                              calculateAge(patient.dateOfBirth),
                                          gender: patient.gender!,
                                          reason: appt.reason!,
                                          time: appt.time!,
                                          appointment: appt,
                                          onEdit: () =>
                                              navigateToEditPage(appt),
                                        );
                                      }).toList(),
                                    if (filteredMeAppointmentsByDay!.isEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(top: 128.w),
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
  }
}

class AppointmentCard extends StatelessWidget {
  final String name;
  final String age;
  final String gender;
  final String reason;
  final String time;
  AdminAppointment appointment;
  Function()? onEdit;

  AppointmentCard({
    required this.name,
    required this.age,
    required this.gender,
    required this.reason,
    required this.time,
    required this.appointment,
    this.onEdit,
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
              appointment: appointment,
              onEdit: onEdit),
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
  AdminAppointment appointment;
  Function()? onEdit;

  CardWidget({
    required this.name,
    required this.age,
    required this.gender,
    required this.reason,
    required this.appointment,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    DateTime apptDate = DateFormat('yyyy-MM-dd').parse(appointment.date!);
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
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.w),
          InformationRow(title: 'Age', value: age),
          SizedBox(height: 4.w),
          InformationRow(title: 'Gender', value: gender),
          SizedBox(height: 4.w),
          InformationRow(title: 'Reason', value: reason),
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
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                      color: apptDate.isBefore(DateTime.now())
                          ? Colors.green
                          : AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(10.w)),
                  child: Icon(Icons.check,
                      color: apptDate.isBefore(DateTime.now())
                          ? Colors.white
                          : Colors.blue)),
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
          Text(
            '$title',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            softWrap: isWrapped,
          ),
        ],
      ),
    );
  }
}
