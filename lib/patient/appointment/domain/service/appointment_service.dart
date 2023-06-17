import 'package:brain_training_app/patient/appointment/domain/entity/appointment.dart';
import 'package:brain_training_app/patient/appointment/domain/entity/physiotherapist.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/service/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

class AppointmentService {
  static Future<bool> onSubmitAppointmentDetails(
      Appointment appointment) async {
    final appUser = Get.find<AppUser>();
    try {
      await Future.wait([
        FirebaseFirestore.instance
            .collection("users")
            .doc(appUser.uid).update({"appointments": FieldValue.arrayUnion([appointment.toJson()])}),
        FirebaseAuthRepository.getUserDetails(appUser.uid!),

        // double check on this : create date map, and inside with time map stores bool value and appointment id
        FirebaseFirestore.instance
            .collection("physiotherapists")
            .doc(appointment.physiotherapistInCharge?.id)
            .collection("appointmentSlots")
            .doc(appointment.date)
            .collection("timeSlots")
            .doc(appointment.time)
            .set(
                {"isBooked": true, "appointmentID": appointment.appointmentID}),
        FirebaseFirestore.instance
            .collection("appointments")
            .add(appointment.toJson())
            .then(
              (documentSnapshot) =>
                  print("Added Data with ID: ${documentSnapshot.id}"),
            ),
      ]);
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  static Future<List<Physiotherapist>> getPhysiotherapistList() {
    return FirebaseFirestore.instance.collection("physiotherapists").get().then(
          (value) =>
              value.docs
                  .map((e) => Physiotherapist.fromJson(e.data()))
                  .toList() ??
              [],
        );
  }

  static Future<List<Appointment>> getAppointmentList() async {
    final appUser = Get.find<AppUser>();
    return FirebaseFirestore.instance
        .collection("users")
        .doc(appUser.uid)
        .get()
        .then(
          (value) => value.data()?["appointments"] != null
              ? (value.data()?["appointments"] as List)
                  .map((e) => Appointment.fromJson(e))
                  .toList()
              : [],
        );
  }
}
