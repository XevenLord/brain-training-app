import 'package:brain_training_app/common/domain/service/notification_api.dart';
import 'package:brain_training_app/common/domain/service/user_repo.dart';
import 'package:brain_training_app/patient/appointment/domain/entity/appointment.dart';
import 'package:brain_training_app/patient/appointment/domain/service/appointment_service.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentViewModel extends GetxController implements GetxService {
  AppointmentViewModel();
  List<AppUser> physiotherapistList = [];
  List<Appointment> appointments = [];
  List<Appointment> appointmentsByID = [];
  AppUser? chosenPhysiotherapist;

  String? apptRef;
  bool isAppointmentSet = false;

  Future<List<Appointment>> getAppointmentList() async {
    print("Enter here fetchinggggg");
    List<Appointment> readAppointments = [];
    appointments = await AppointmentService.getAppointmentList();
    appointments.forEach((element) {
      if (element.status == "approved" &&
          element.isRead != null &&
          !element.isRead!) {
        print("Enter here");
        AppUser physio = physiotherapistList
            .firstWhere((physio) => physio.uid == element.physiotherapistID);
        NotificationAPI.showNotification(
          id: element.appointmentID.hashCode,
          title: "Dr ${physio.name} approved your appointment",
          body: "Meet you on ${element.date}, ${element.time}",
          payload: "This is the payload of the notification",
        );
        NotificationAPI.showScheduledNotification(
          id: element.appointmentID.hashCode,
          title: "Appointment with Dr ${physio.name}",
          body: "Meet you on ${element.date}, ${element.time}",
          payload: "This is the payload of the notification",
          scheduledDate: createDateWithTimeSlot(
              date: DateTime.now(), timeSlot: element.time!),
        );
        readAppointments.add(element);
      } else if (element.status == "declined" &&
          element.isRead != null &&
          !element.isRead!) {
        AppUser physio = physiotherapistList
            .firstWhere((physio) => physio.uid == element.physiotherapistID);
        NotificationAPI.showNotification(
          id: element.appointmentID.hashCode,
          title: "Your appointment with Dr ${physio.name} has been declined",
          body: "Please kindly reschedule your appointment",
          payload: "This is the payload of the notification",
        );
        readAppointments.add(element);
      }
    });
    updateIsRead(readAppointments);
    sortAppointmentByDate();
    update();
    return appointments.reversed.toList();
  }

  Future<List<Appointment>> getAppointmentsByID(String uid) async {
    appointments = await AppointmentService.getAppointmentsByID(uid);
    sortAppointmentByDate();
    update();
    return appointments.reversed.toList();
  }

  Future<List<Appointment>> getAppointmentsByPhysiotherapistID() async {
    appointments = await AppointmentService.getAppointmentListByPhysiotherapist(
        chosenPhysiotherapist!.uid!);
    update();
    return appointments;
  }

  setChosenPhysiotherapist({required AppUser physiotherapist}) {
    chosenPhysiotherapist = physiotherapist;
    update();
  }

  void sortAppointmentByDate() {
    DateTime today = DateTime.now();
    appointments.sort((a, b) {
      // Check if appointment date is today
      bool isTodayA = isSameDay(DateTime.parse(a.date!), today);
      bool isTodayB = isSameDay(DateTime.parse(b.date!), today);

      // Sort by appointment date
      if (isTodayA && isTodayB) {
        // Both appointments are today, sort by time
        return a.time!.compareTo(b.time!);
      } else if (isTodayA) {
        // Appointment A is today, prioritize it
        return -1;
      } else if (isTodayB) {
        // Appointment B is today, prioritize it
        return 1;
      } else {
        // Both appointments are in the future or past, sort by date
        return a.date!.compareTo(b.date!);
      }
    });

    update();
  }

  Future<List<AppUser>> getPhysiotherapistList() async {
    physiotherapistList = await UserRepository.fetchAllAdmins();
    update();
    return physiotherapistList;
  }

  Future<void> setAppointment(
      {required DateTime date,
      required String time,
      String? reason,
      String? patient}) async {
    print("Chosen physiotherapist: ${chosenPhysiotherapist!.name}");
    Appointment appointment = Appointment(
      patient: Get.find<AppUser>().name,
      patientID: Get.find<AppUser>().uid,
      appointmentID: Get.find<AppUser>().uid! +
          DateFormat("yyyy-MM-dd").format(date.toLocal()) +
          time,
      date: DateFormat("yyyy-MM-dd").format(date.toLocal()),
      time: time,
      reason: reason == null || reason.isEmpty ? "N/A" : reason,
      physiotherapistID: chosenPhysiotherapist!.uid,
      status: "pending",
    );
    apptRef = await AppointmentService.onSubmitAppointmentDetails(appointment);
    NotificationAPI.showNotification(
      id: apptRef.hashCode,
      title: "Appointment with Dr ${chosenPhysiotherapist!.name!}",
      body: "Please kindly wait for the approval of your appointment.",
      payload: "This is the payload of the notification",
    );
    isAppointmentSet = true;
    update();
  }

  Future<void> updateAppointment(
      {required Appointment appointment,
      required String date,
      required String time,
      required String reason}) async {
    String oldDate = appointment.date!;
    bool isDateAndTimeChanged =
        appointment.date != date || appointment.time != time;
    if (isDateAndTimeChanged) {
      appointment.status = "pending";
    }
    appointment.date = date;
    appointment.time = time;
    appointment.reason = reason;

    await AppointmentService.updateAppointment(appointment, oldDate);
    AppUser physio = physiotherapistList
        .firstWhere((physio) => physio.uid == appointment.physiotherapistID);
    DateTime newDate = DateFormat('yyyy-MM-dd').parse(date);
    if (newDate.isAfter(DateTime.now())) {
      NotificationAPI.showNotification(
        id: appointment.appointmentID.hashCode,
        title: "Appointment with Dr ${physio.name}",
        body: "Please kindly wait for the approval of your appointment.",
        payload: "This is the payload of the notification",
        // scheduledDate:
        //     createDateWithTimeSlot(date: DateTime.now(), timeSlot: "9:30 PM"),
      );
    }
  }

  Future<void> cancelAppointment({required Appointment appointment}) async {
    isAppointmentSet = await AppointmentService.deleteAppointment(appointment);
    NotificationAPI.cancel(appointment.appointmentID.hashCode);
    update();
  }

  DateTime createDateWithTimeSlot(
      {required DateTime date, required String timeSlot}) {
    final timeParts = timeSlot.split(' ');
    final time = timeParts[0];
    final period = timeParts[1];

    final hourMinute = time.split(':');
    var hour = int.parse(hourMinute[0]);
    final minute = int.parse(hourMinute[1]);

    // Adjust hour for PM time slots
    if (period == 'PM' && hour != 12) {
      hour += 12;
    }
    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(dateTime);
  }

  void updateIsRead(List<Appointment> readAppointments) async {
    readAppointments.forEach((element) async {
      await AppointmentService.updateIsRead(element);
    });
  }
}
