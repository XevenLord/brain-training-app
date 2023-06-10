import 'package:brain_training_app/common/ui/widget/empty_box.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentCalendarPage extends StatefulWidget {
  const AppointmentCalendarPage({super.key});

  @override
  State<AppointmentCalendarPage> createState() =>
      _AppointmentCalendarPageState();
}

class _AppointmentCalendarPageState extends State<AppointmentCalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  List timeSlots = [
    "09:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "01:00 PM",
    "02:00 PM",
    "03:00 PM",
    "04:00 PM",
    "05:00 PM",
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // shadowColor: AppColors.white,
          foregroundColor: AppColors.brandBlue,
          backgroundColor: AppColors.white,
          centerTitle: true,
          title: Text(
            'New Appointment',
            style: AppTextStyle.h2,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    if (selectedDay.compareTo(
                            DateTime.now().subtract(const Duration(days: 1))) <
                        0) return;
                    _selectedDay = selectedDay;
                    _focusedDay =
                        focusedDay; // update `_focusedDay` here as well
                  });
                },
                // weekNumbersVisible: false,
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                calendarStyle: CalendarStyle(
                  isTodayHighlighted: true,
                  selectedDecoration: BoxDecoration(
                    color: AppColors.brandBlue,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle:
                      AppTextStyle.h3.merge(AppTextStyle.whiteTextStyle),
                  todayDecoration: BoxDecoration(
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
              SizedBox(height: 30.h),
              Text("Available Time Slot",
                  style:
                      AppTextStyle.h2.merge(AppTextStyle.brandBlueTextStyle)),
              SizedBox(height: 20.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    timeSlots.length,
                    (index) => Container(
                      margin: EdgeInsets.only(right: 10.w),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: AppColors.lightBlue,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(timeSlots[index], style: AppTextStyle.h3),
                    ),
                  ),
                ),
              ),
              EmptyBox(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: AppColors.brandBlue,
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppointmentCalendarPage(),
                      ),
                    );
                  },
                  child: Text(
                    "Set Appointment",
                    style: AppTextStyle.h3.merge(AppTextStyle.whiteTextStyle),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
