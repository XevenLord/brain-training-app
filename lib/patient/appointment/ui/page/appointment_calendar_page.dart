import 'package:brain_training_app/common/ui/widget/empty_box.dart';
import 'package:brain_training_app/patient/appointment/domain/entity/appointment.dart';
import 'package:brain_training_app/patient/appointment/ui/view_model/appointment_vmodel.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentCalendarPage extends StatefulWidget {
  AppointmentCalendarPage({super.key});

  @override
  State<AppointmentCalendarPage> createState() =>
      _AppointmentCalendarPageState();
}

class _AppointmentCalendarPageState extends State<AppointmentCalendarPage> {
  late AppointmentViewModel _appointmentViewModel;
  List<Appointment> appts = [];

  @override
  void initState() {
    _appointmentViewModel = Get.find<AppointmentViewModel>();
    _appointmentViewModel.getAppointmentsByPhysiotherapistID().then((value) {
      setState(() {
        appts = value;
        updateTimeSlots();
      });
    });
    super.initState();
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now().add(const Duration(days: 1));
  DateTime _selectedDay = DateTime.now().add(const Duration(days: 1));
  String storedTimeSlot = "";
  int timeSlotIndex = -1;

  final TextEditingController _commentController = TextEditingController();

  List timeSlots = [];

  List timeSlotsTemplate = [
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

  void updateTimeSlots() {
    timeSlots = List.from(timeSlotsTemplate);
    for (int i = 0; i < appts.length; i++) {
      if (appts[i].date != null &&
          appts[i].date! == DateFormat('yyyy-MM-dd').format(_selectedDay)) {
        timeSlots.remove(appts[i].time);
      }
    }
    setState(() {});
  }

  List<dynamic> checkCurrentDateWithTimeSlot(
      {required List<dynamic> timeSlots}) {
    if (DateFormat('yyyy-MM-dd').format(_selectedDay) ==
        DateFormat('yyyy-MM-dd').format(DateTime.now())) {
      final currentTime = DateTime.now();
      final currentHour = currentTime.hour;
      final currentMinute = currentTime.minute;
      List<dynamic> slots = List.from(timeSlots);
      for (int i = 0; i < slots.length; i++) {
        final timeParts = slots[i].split(' ');
        final time = timeParts[0];
        final period = timeParts[1];

        final hourMinute = time.split(':');
        var hour = int.parse(hourMinute[0]);
        final minute = int.parse(hourMinute[1]);

        // Adjust hour for PM time slots
        if (period == 'PM' && hour != 12) {
          hour += 12;
        }

        if (hour < currentHour) {
          timeSlots.remove(slots[i]);
        } else if (hour == currentHour && minute < currentMinute) {
          timeSlots.remove(slots[i]);
        }
      }
    }
    return timeSlots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // shadowColor: AppColors.white,
        foregroundColor: AppColors.brandBlue,
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'New Appointment',
          style: AppTextStyle.h2,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      timeSlots = timeSlotsTemplate;
                      if (selectedDay.compareTo(DateTime.now()
                              .subtract(const Duration(days: 0))) <
                          0) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  "Invalid Date",
                                  style: AppTextStyle.h2,
                                ),
                                content: Text(
                                  "Please select a valid date",
                                  style: AppTextStyle.h3,
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text("OK"))
                                ],
                              );
                            });
                        return;
                      }
                      _selectedDay = selectedDay;
                      _focusedDay =
                          focusedDay; // update `_focusedDay` here as well
                    });
                    updateTimeSlots();
                  },
                  // weekNumbersVisible: false,
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
                  calendarStyle: CalendarStyle(
                    isTodayHighlighted: false,
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
                      (index) => InkWell(
                        onTap: () {
                          setState(() {
                            timeSlotIndex = index;
                            storedTimeSlot = timeSlots[index];
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10.w),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: timeSlotIndex == index
                                ? AppColors.brandBlue
                                : AppColors.lightBlue,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            timeSlots[index],
                            style: AppTextStyle.h3.merge(timeSlotIndex == index
                                ? AppTextStyle.whiteTextStyle
                                : AppTextStyle.blackTextStyle),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                Text("Comments",
                    style:
                        AppTextStyle.h2.merge(AppTextStyle.brandBlueTextStyle)),
                TextField(
                  keyboardType: TextInputType.multiline,
                  controller: _commentController,
                  maxLines: null,
                  style: AppTextStyle.h3.merge(AppTextStyle.lightGreyTextStyle),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: InkWell(
                    onTap: () async {
                      if (storedTimeSlot.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  "No time slot is picked!",
                                  style: AppTextStyle.h2,
                                ),
                                content: Text(
                                  "Please select a time slot",
                                  style: AppTextStyle.h3,
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text("OK"))
                                ],
                              );
                            });
                        return;
                      }
                      await _appointmentViewModel.setAppointment(
                        date: _selectedDay,
                        time: storedTimeSlot,
                        reason: _commentController.text,
                        patient: Get.find<AppUser>().name,
                      );
                      setState(() {});
                      if (_appointmentViewModel.isAppointmentSet) {
                        _appointmentViewModel.isAppointmentSet = false;
                        Get.toNamed(RouteHelper.getAppointmentSuccessPage());
                      } else {
                        Get.snackbar(
                          "Fail to set appointment",
                          "Please select a time slot",
                          backgroundColor: AppColors.brandRed,
                          colorText: AppColors.white,
                          snackPosition: SnackPosition.TOP,
                        );
                      }
                    },
                    child: EmptyBox(
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                      decoration: BoxDecoration(
                        color: AppColors.brandBlue,
                        borderRadius: BorderRadius.all(Radius.circular(10.r)),
                      ),
                      child: Text(
                        "Set Appointment",
                        style:
                            AppTextStyle.h3.merge(AppTextStyle.whiteTextStyle),
                      ),
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
