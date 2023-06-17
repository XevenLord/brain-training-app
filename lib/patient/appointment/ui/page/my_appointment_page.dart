import 'package:brain_training_app/patient/appointment/ui/widget/appointment_tile.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyAppointmentPage extends StatefulWidget {
  const MyAppointmentPage({super.key});

  @override
  State<MyAppointmentPage> createState() => _MyAppointmentPageState();
}

class _MyAppointmentPageState extends State<MyAppointmentPage> {
  List<Map> appointmentList = [
    {
      "name": "Dr. John Doe",
      "doctorName": "Cardiologist",
      "date": "11/12/2021",
      "time": "10:00 AM",
      "type": AppointmentTileType.past,
    },
    {
      "name": "Dr. John Doe",
      "doctorName": "Cardiologist",
      "date": "12/12/2021",
      "time": "10:00 AM",
      "type": AppointmentTileType.current,
    },
    {
      "name": "Dr. John Doe",
      "doctorName": "Cardiologist",
      "date": "12/12/2021",
      "time": "11:00 AM",
      "type": AppointmentTileType.current,
    },
    {
      "name": "Dr. John Doe",
      "doctorName": "Cardiologist",
      "date": "12/12/2021",
      "time": "10:00 AM",
      "type": AppointmentTileType.current,
    },
    {
      "name": "Dr. John Doe",
      "doctorName": "Cardiologist",
      "date": "12/12/2021",
      "time": "12:00 PM",
      "type": AppointmentTileType.current,
    },
    {
      "name": "Dr. John Doe",
      "doctorName": "Cardiologist",
      "date": "13/12/2021",
      "time": "10:00 AM",
      "type": AppointmentTileType.upcoming,
    },
    {
      "name": "Dr. John Doe",
      "doctorName": "Cardiologist",
      "date": "14/12/2021",
      "time": "10:00 AM",
      "type": AppointmentTileType.upcoming,
    },
    {
      "name": "Dr. John Doe",
      "doctorName": "Cardiologist",
      "date": "12/12/2021",
      "time": "11:00 AM",
      "type": AppointmentTileType.upcoming,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Get.offAllNamed(RouteHelper.getPatientHome(), arguments: 2);
                    },
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                ),
                ...List.generate(
                  appointmentList.length,
                  (index) => AppointmentTile(
                    time: appointmentList[index]['time'],
                    doctorName: appointmentList[index]['doctorName'],
                    type: appointmentList[index]['type'],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


