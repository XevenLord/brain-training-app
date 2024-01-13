import 'package:brain_training_app/patient/appointment/domain/entity/appointment.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppointmentService {
  static Future<String?> onSubmitAppointmentDetails(
    Appointment appointment,
  ) async {
    try {
      final appointmentDocRef = FirebaseFirestore.instance
          .collection("appointments")
          .doc(appointment.appointmentID);

      await appointmentDocRef.set(
          appointment.toJson(), SetOptions(merge: true));

      return appointmentDocRef.id;
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static Future<List<Appointment>> getAppointmentList() async {
    final appUser = Get.find<AppUser>();
    return FirebaseFirestore.instance
        .collection("appointments")
        .where("patientID", isEqualTo: appUser.uid)
        .get()
        .then(
          (value) =>
              value.docs.map((e) => Appointment.fromJson(e.data())).toList(),
        )
        .then((appointments) {
      // Sort the appointments based on time
      appointments.sort((a, b) {
        print("entering the checking sorting time slots");
        // Convert time strings to DateTime objects for comparison
        DateTime timeA = DateFormat.jm().parse(a.time!);
        DateTime timeB = DateFormat.jm().parse(b.time!);
        return timeA.compareTo(timeB); // for descending order
      });
      return appointments;
    });
  }

  static Future<List<Appointment>> getAppointmentsByID(String uid) async {
    final appUser = Get.find<AppUser>();
    return FirebaseFirestore.instance
        .collection("appointments")
        .where("patientID", isEqualTo: uid)
        .get()
        .then(
          (value) =>
              value.docs.map((e) => Appointment.fromJson(e.data())).toList(),
        )
        .then((appointments) {
      // Sort the appointments based on time
      appointments.sort((a, b) {
        print("entering the checking sorting time slots");
        // Convert time strings to DateTime objects for comparison
        DateTime timeA = DateFormat.jm().parse(a.time!);
        DateTime timeB = DateFormat.jm().parse(b.time!);
        return timeA.compareTo(timeB); // for descending order
      });
      return appointments;
    });
  }

  static Future<List<Appointment>> getAppointmentListByPhysiotherapist(
      String physiotherapistID) async {
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
    try {
      await Future.wait([
        FirebaseFirestore.instance
            .collection("appointments")
            .doc(appointment.appointmentID)
            .set(appointment.toJson(), SetOptions(merge: true)),
      ]);
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  static Future<bool> deleteAppointment(Appointment appointment) async {
    try {
      await Future.wait([
        FirebaseFirestore.instance
            .collection("appointments")
            .doc(appointment.appointmentID)
            .delete(),
      ]);
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }
}
