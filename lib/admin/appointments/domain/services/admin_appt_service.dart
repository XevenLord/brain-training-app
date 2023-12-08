import 'package:brain_training_app/admin/appointments/domain/entity/appointment.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/service/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdminAppointmentService {
  static Future<List<Appointment>> getAppointmentList() async {
    return FirebaseFirestore.instance
        .collection("appointments")
        .get()
        .then(
          (value) =>
              value.docs.map((e) => Appointment.fromJson(e.data())).toList(),
        )
        .then((appointments) {
      appointments.sort((a, b) {
        DateTime timeA = DateFormat.jm().parse(a.time!);
        DateTime timeB = DateFormat.jm().parse(b.time!);
        return timeA.compareTo(timeB); // for descending order
      });
      return appointments;
    });
  }

  static Future<List<Appointment>> getAppointmentListByPhysiotherapist(
      String physiotherapistID) async {
    final appUser = Get.find<AppUser>();
    return FirebaseFirestore.instance
        .collection("appointments")
        .where("physiotherapistID", isEqualTo: physiotherapistID)
        .get()
        .then(
          (value) =>
              value.docs.map((e) => Appointment.fromJson(e.data())).toList(),
        );
  }

  static Future<bool> updateAppointment(
      Appointment appointment, String oldDate) async {
    final appUser = Get.find<AppUser>();
    try {
      await Future.wait([
        FirebaseFirestore.instance
            .collection("appointments")
            .doc(appointment.appointmentID)
            .set(appointment.toJson(), SetOptions(merge: true)),
      ]);
      await FirebaseAuthRepository.getUserDetails(appUser.uid!);
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }
}
