import 'package:brain_training_app/patient/appointment/domain/entity/appointment.dart';
import 'package:brain_training_app/patient/appointment/domain/entity/appointment_slot.dart';
import 'package:brain_training_app/patient/appointment/domain/entity/physiotherapist.dart';
import 'package:brain_training_app/patient/appointment/domain/entity/time_slot.dart';
import 'package:brain_training_app/patient/appointment/domain/service/appointment_service.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentViewModel extends GetxController implements GetxService {
  AppointmentViewModel();
  List<Physiotherapist> physiotherapistList = [];
  List<Appointment> appointments = [];
  Physiotherapist? chosenPhysiotherapist;

  bool isAppointmentSet = false;

  Future<List<Appointment>> getAppointmentList() async {
    print("entering getAppointmentList");
    appointments = await AppointmentService.getAppointmentList();
    print("appointment list: ${appointments}");
    sortAppointmentByDate();
    print("sorted appointment list: ${appointments}");
    update();
    return appointments;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  setChosenPhysiotherapist({required Physiotherapist physiotherapist}) {
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

  Future<List<Physiotherapist>> getPhysiotherapistList() async {
    debugModePrint("entering getPhysiotherapistList");
    physiotherapistList = await AppointmentService.getPhysiotherapistList();
    return physiotherapistList;
  }

  Future<void> setAppointment(
      {required DateTime date,
      required String time,
      String? reason,
      String? patient}) async {
    Appointment appointment = Appointment(
      patient: Get.find<AppUser>().name,
      patientID: Get.find<AppUser>().uid,
      appointmentID: Get.find<AppUser>().uid! +
          DateFormat("yyyy-MM-dd").format(date.toLocal()) +
          time,
      date: DateFormat("yyyy-MM-dd").format(date.toLocal()),
      time: time,
      reason: reason,
      physiotherapistInCharge: Physiotherapist(
        name: chosenPhysiotherapist!.name,
        id: chosenPhysiotherapist!.id,
        email: chosenPhysiotherapist!.email,
        phone: chosenPhysiotherapist!.phone,
        speciality: chosenPhysiotherapist!.speciality,
        imgUrl: chosenPhysiotherapist!.imgUrl,
      ),
    );
    print("entering appointment service");

    AppointmentSlots appointmentSlots =
        AppointmentSlots(date: date, timeSlots: {
      time: TimeSlot(
        patientID: appointment.patientID,
        appointmentID: appointment.appointmentID,
      ),
    });

    isAppointmentSet = await AppointmentService.onSubmitAppointmentDetails(
        appointment, appointmentSlots);
    update();
  }

  Future<void> cancelAppointment({required Appointment appointment}) async {
    isAppointmentSet = await AppointmentService.deleteAppointment(appointment);
    update();
  }

  Future<void> updateAppointment({required Appointment appointment, required String date, required String time, required String reason}) {
    String oldDate  = appointment.date!;
    appointment.date = date;
    appointment.time = time;
    appointment.reason = reason;
    return AppointmentService.updateAppointment(appointment, oldDate);
  }

  // DateTime? appointmentDate;
  // String? appointmentTime;
  // String? appointmentReason;
  // String? doctorName;

  // void setAppointmentDate(DateTime? date) {
  //   appointmentDate = date;
  //   update();
  // }

  // void setAppointmentTime(String? time) {
  //   appointmentTime = time;
  //   update();
  // }

  // void setAppointmentReason(String? reason) {
  //   appointmentReason = reason;
  //   update();
  // }

  // void reset() {
  //   appointmentDate = null;
  //   appointmentTime = null;
  //   appointmentReason = null;
  //   update();
  // }
}
