import 'package:brain_training_app/admin/appointments/domain/entity/appointment.dart';
import 'package:brain_training_app/admin/appointments/ui/view_model/appointment_vmodel.dart';
import 'package:brain_training_app/common/domain/service/user_repo.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentMainPage extends StatefulWidget {
  const AppointmentMainPage({super.key});

  @override
  State<AppointmentMainPage> createState() => _AppointmentMainPageState();
}

class _AppointmentMainPageState extends State<AppointmentMainPage> {
  late AdminAppointmentViewModel _appointmentViewModel;
  late UserRepository? _userRepo;
  List<Appointment>? appointments;
  List<Appointment>? filteredAppointments;
  List<AppUser>? patients;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  void initState() {
    _appointmentViewModel = Get.find<AdminAppointmentViewModel>();
    _userRepo = Get.find<UserRepository>();
    getAppointmentList();
    patients = _userRepo!.getPatientUsers;
    super.initState();
  }

  void getAppointmentList() async {
    appointments = await _appointmentViewModel.getAppointmentList();
    filterAppointmentByDay();
    setState(() {});
  }

  void filterAppointmentByDay() {
    print("filtering appointments");
    filteredAppointments = _appointmentViewModel.filterAppointmentByDay(
        day: _selectedDay, appts: appointments!);
    filteredAppointments = filteredAppointments!.reversed.toList();
    print("filtered appointments");
    print(filteredAppointments);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
                children: <Widget>[
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
                    child: ListView(
                      children: <Widget>[
                        if (filteredAppointments != null && patients != null)
                          ...filteredAppointments!.map((appt) {
                            AppUser patient = patients!.firstWhere(
                                (element) => element.uid == appt.patientID);
                            return AppointmentCard(
                              name: patient.name!,
                              age: calculateAge(patient.dateOfBirth),
                              gender: patient.gender!,
                              reason: appt.reason!,
                              time: appt.time!,
                            );
                          }).toList(),
                        if (filteredAppointments!.isEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 128.w),
                            child: Center(
                                child: Text("No appointments for this day",
                                    style: AppTextStyle.h2)),
                          ),
                        SizedBox(height: 20.w)
                      ],
                    ),
                  )
                ],
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

  AppointmentCard({
    required this.name,
    required this.age,
    required this.gender,
    required this.reason,
    required this.time,
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
          CardWidget(name: name, age: age, gender: gender, reason: reason),
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

  CardWidget({
    required this.name,
    required this.age,
    required this.gender,
    required this.reason,
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
                  child: Icon(Icons.edit, color: Colors.blue)),
              Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(10.w)),
                  child: Icon(Icons.check, color: Colors.blue)),
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

  InformationRow({required this.title, required this.value});

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
          ),
        ],
      ),
    );
  }
}
