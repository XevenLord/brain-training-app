import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentMainPage extends StatefulWidget {
  const AppointmentMainPage({super.key});

  @override
  State<AppointmentMainPage> createState() => _AppointmentMainPageState();
}

class _AppointmentMainPageState extends State<AppointmentMainPage> {
  late Map<DateTime, List<dynamic>> _events;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _events = {
      DateTime(2023, 12, 1): ['Appointment 1', 'Appointment 2'],
      DateTime(2023, 12, 5): ['Appointment 3'],
      DateTime(2023, 12, 15): ['Appointment 4'],
      // Add more appointments as needed
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text("Appointments", style: AppTextStyle.blackTextStyle),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(), // Or Get.back() if using GetX
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TableCalendar(
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2023, 12, 31),
              focusedDay: DateTime.utc(2023, 7, 4),
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  AppointmentCard(
                    name: 'Lee Sha She',
                    age: '50',
                    gender: 'Male',
                    reason: 'The head is pain',
                    time: '0800',
                  ),
                  AppointmentCard(
                    name: 'Daniel Lim',
                    age: '60',
                    gender: 'Male',
                    reason: "I can't think properly",
                    time: '1200',
                  ),
                  AppointmentCard(
                    name: 'Melissa Chia',
                    age: '55',
                    gender: 'Female',
                    reason: "I can't calculate for dimain",
                    time: '1400',
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
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              Icon(Icons.more_vert, color: Colors.black54),
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
      margin: EdgeInsets.only(top: 8.0),
      padding: EdgeInsets.all(16.0),
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
            style: TextStyle(
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '$title',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        Text(
          '$value',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
