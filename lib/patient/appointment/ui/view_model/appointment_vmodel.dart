import 'package:brain_training_app/patient/appointment/domain/entity/appointment.dart';
import 'package:brain_training_app/patient/appointment/domain/entity/physiotherapist.dart';
import 'package:brain_training_app/patient/appointment/domain/service/appointment_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppointmentViewModel extends GetxController implements GetxService {
  AppointmentViewModel();
  List<Physiotherapist> physiotherapistList = [];
  Physiotherapist? chosenPhysiotherapist;

  bool isAppointmentSet = false;

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

  Future<List<Physiotherapist>> getPhysiotherapistList() async {
    physiotherapistList = await AppointmentService.getPhysiotherapistList();
    return physiotherapistList;
  }

  Future<void> setAppointment(
      {required DateTime date,
      required String time,
      String? reason,
      String? patient}) async {
    Appointment appointment = Appointment(
        appointmentID: DateTime.now().toString(),
        date: DateFormat("yyyy-MM-dd").format(date.toLocal()),
        time: time,
        reason: reason,
        physiotherapistInCharge: chosenPhysiotherapist);
    print("entering appointment service");
    isAppointmentSet =
        await AppointmentService.onSubmitAppointmentDetails(appointment);
    update();
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
