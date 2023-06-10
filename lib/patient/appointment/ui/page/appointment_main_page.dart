import 'package:brain_training_app/patient/appointment/ui/page/appointment_booking_page.dart';
import 'package:brain_training_app/patient/appointment/ui/widget/doctor_card.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentMainPage extends StatefulWidget {
  const AppointmentMainPage({super.key});

  @override
  State<AppointmentMainPage> createState() => _AppointmentMainPageState();
}

class _AppointmentMainPageState extends State<AppointmentMainPage> {
  List appointments = [
    {
      "imgUrl":
          "https://image.shutterstock.com/image-illustration/mathematics-horizontal-banner-presentation-website-260nw-1798855321.jpg",
      "doctorName": "Joanne Lau",
      "position": "Pharmacist",
      "rating": 4.5,
    },
    {
      "imgUrl":
          "https://image.shutterstock.com/image-illustration/mathematics-horizontal-banner-presentation-website-260nw-1798855321.jpg",
      "doctorName": "Joanne Lau",
      "position": "Pharmacist Boss",
      "rating": 4.5,
    },
    {
      "imgUrl":
          "https://image.shutterstock.com/image-illustration/mathematics-horizontal-banner-presentation-website-260nw-1798855321.jpg",
      "doctorName": "Joanne Lau",
      "position": "Pharmacist Assistant",
      "rating": 4.5,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text("Select a practitioner", style: AppTextStyle.h3),
          SizedBox(height: 16.h),
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16.w,
            shrinkWrap: true, // Add this line
            // physics: NeverScrollableScrollPhysics(), // Add this line
            children: List.generate(
              appointments.length,
              (index) => DoctorCard(
                  doctorName: appointments[index]["doctorName"],
                  position: appointments[index]["position"],
                  imgUrl: appointments[index]["imgUrl"],
                  rating: appointments[index]["rating"],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppointmentBookingPage(
                          practitionerName: appointments[index]["doctorName"],
                          imgUrl: appointments[index]["imgUrl"],
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
