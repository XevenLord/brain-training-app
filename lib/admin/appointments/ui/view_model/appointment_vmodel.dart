import 'package:brain_training_app/admin/appointments/domain/entity/appointment.dart';
import 'package:brain_training_app/admin/appointments/domain/entity/physiotherapist.dart';
import 'package:brain_training_app/admin/appointments/domain/services/admin_appt_service.dart';
import 'package:brain_training_app/common/domain/service/notification_api.dart';
import 'package:brain_training_app/common/domain/service/user_repo.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AdminAppointmentViewModel extends GetxController implements GetxService {
  List<AdminAppointment> appointments = [];
  List<AppUser> physiotherapistList = [];
  List<AppUser> patientList = [];
  bool isAppointmentSet = false;

  Future<List<AdminAppointment>> getAppointmentList() async {
    appointments = await AdminAppointmentService.getAppointmentList();
    List<AdminAppointment> myAppointments = filterAppointmentByMe();
    List<AdminAppointment> readAppointments = [];
    for (var element in myAppointments) {
      if (element.isPhysioRead != null &&
          !element.isPhysioRead! &&
          element.status == "pending") {
        readAppointments.add(element);
        NotificationAPI.showNotification(
          id: element.appointmentID.hashCode,
          title: "New Appointment on ${element.date}",
          body: "You have a new appointment from ${element.patient}",
          payload: "This is the payload of the notification",
        );
      }
    }
    updateIsPhysioRead(readAppointments);
    sortAppointmentByDate();
    update();
    return appointments.reversed.toList();
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
    return physiotherapistList;
  }

  Future<List<AppUser>> getPatientList() async {
    patientList = await UserRepository.fetchAllPatients();
    return patientList;
  }

  List<AdminAppointment> filterAppointmentByMe() {
    return appointments
        .where(
            (element) => element.physiotherapistID == Get.find<AppUser>().uid)
        .toList();
  }

  List<AdminAppointment> filterAppointmentByDay(
      {required DateTime day, required List<AdminAppointment> appts}) {
    if (appts.isNotEmpty) {
      return appts
          .where((element) => isSameDay(DateTime.parse(element.date!), day))
          .toList();
    }
    return [];
  }

  Future<void> updateAppointment(
      {required AdminAppointment appointment,
      required String date,
      required String time,
      required String reason,
      String? remark}) async {
    String oldDate = appointment.date!;
    appointment.date = date;
    appointment.time = time;
    appointment.reason = reason;
    if (remark != null && remark.isNotEmpty) {
      appointment.remark = remark;
      await updateStatusAppointment(appointment: appointment);
    }
    await AdminAppointmentService.updateAppointment(appointment, oldDate);
    AppUser patient = patientList
        .firstWhere((element) => element.uid == appointment.patientID);
    DateTime newDate = DateFormat('yyyy-MM-dd').parse(date);
    if (newDate.isAfter(DateTime.now())) {
      NotificationAPI.showScheduledNotification(
        id: appointment.appointmentID.hashCode,
        title: "Appointment with ${patient.name}",
        body: "Meet you on ${formatDateTime(newDate)}, ${time}",
        payload: "This is the payload of the notification",
        // scheduledDate:
        //     createDateWithTimeSlot(date: DateTime.now(), timeSlot: "9:30 PM"),
        scheduledDate: createDateWithTimeSlot(
            date: newDate.subtract(const Duration(days: 1)),
            timeSlot: "9:00 AM"),
      );
    }
  }

  Future<void> updateStatusAppointment(
      {required AdminAppointment appointment}) async {
    if (appointment.remark != null && appointment.remark!.isNotEmpty) {
      appointment.status = "completed";
    }
  }

  Future<void> approveAppointment(
      {required AdminAppointment appointment}) async {
    await AdminAppointmentService.approveAppointment(appointment);
    AppUser patient = patientList
        .firstWhere((element) => element.uid == appointment.patientID);
    DateTime newDate = DateFormat('yyyy-MM-dd').parse(appointment.date!);
    NotificationAPI.showScheduledNotification(
      id: appointment.appointmentID.hashCode,
      title: "Appointment with ${patient.name}",
      body: "Meet you on ${formatDateTime(newDate)}, ${appointment.time}",
      payload: "This is the payload of the notification",
      // scheduledDate:
      //     createDateWithTimeSlot(date: DateTime.now(), timeSlot: "9:30 PM"),
      scheduledDate: createDateWithTimeSlot(
          date: newDate.subtract(const Duration(days: 1)), timeSlot: "9:00 AM"),
    );
  }

  Future<void> completeAppointment({required AdminAppointment appointment}) {
    return AdminAppointmentService.completeAppointment(appointment);
  }

  Future<void> declineAppointment({required AdminAppointment appointment}) {
    return AdminAppointmentService.declineAppointment(appointment);
  }

  Future<void> cancelAppointment(
      {required AdminAppointment appointment}) async {
    isAppointmentSet =
        await AdminAppointmentService.deleteAppointment(appointment);
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

  void updateIsPhysioRead(List<AdminAppointment> readAppointments) async {
    readAppointments.forEach((element) async {
      await AdminAppointmentService.updateIsPhysioRead(element);
    });
  }
}
