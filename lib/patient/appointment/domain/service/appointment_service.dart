import 'package:brain_training_app/patient/appointment/domain/entity/appointment.dart';
import 'package:brain_training_app/patient/appointment/domain/entity/appointment_slot.dart';
import 'package:brain_training_app/patient/appointment/domain/entity/physiotherapist.dart';
import 'package:brain_training_app/patient/appointment/domain/entity/time_slot.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/service/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppointmentService {
  static Future<bool> onSubmitAppointmentDetails(
      Appointment appointment) async {
    final appUser = Get.find<AppUser>();
    try {
      await Future.wait([
        // FirebaseFirestore.instance
        //     .collection("users")
        //     .doc(appUser.uid)
        //     .get()
        //     .then((docSnapshot) {
        //   if (docSnapshot.exists) {
        //     var data = docSnapshot.data();
        //     List<dynamic> appointments = data?['appointments'] ?? [];

        //     // Check if an appointment with the same ID exists in the appointments list
        //     int index = appointments.indexWhere(
        //         (appt) =>

        //         ['appointmentID'] == appointment.appointmentID);

        //     print("found index : " + index.toString());
        //     if (index != -1) {
        //       // Update the existing appointment
        //       appointments[index] = appointment.toJson();
        //     } else {
        //       // Append the appointment to the appointments list
        //       appointments.add(appointment.toJson());
        //     }

        //     // Update the 'appointments' field in Firestore
        //     FirebaseFirestore.instance
        //         .collection("users")
        //         .doc(appUser.uid)
        //         .update({
        //       "appointments": appointments,
        //     }).then((_) {
        //       print("Appointment added/updated successfully.");
        //     }).catchError((error) {
        //       print("Failed to add/update appointment: $error");
        //     });
        //   } else {
        //     print("User document does not exist.");
        //   }
        // }).catchError((error) {
        //   print("Failed to retrieve user document: $error");
        // }),
        // FirebaseFirestore.instance
        //     .collection("physiotherapists")
        //     .doc(appointment.physiotherapistInCharge?.id)
        //     .collection("appointmentSlots")
        //     .doc(appointment.date)
        //     .set(appointmentSlots.toJson(), SetOptions(merge: true)),

        FirebaseFirestore.instance
            .collection("appointments")
            .doc(appointment.appointmentID)
            .set(appointment.toJson(), SetOptions(merge: true)),
      ]);
      await FirebaseAuthRepository.getUserDetails(appUser.uid!);
      print("See appointmentssssssssssssss");
      // print(Get.find<AppUser>().appointments.toString());
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  static Future<List<Physiotherapist>> getPhysiotherapistList() {
    return FirebaseFirestore.instance.collection("physiotherapists").get().then(
          (value) => value.docs
              .map((e) => Physiotherapist.fromJson(e.data()))
              .toList(),
        );
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
            .collection("users")
            .doc(appUser.uid)
            .get()
            .then((docSnapshot) {
          if (docSnapshot.exists) {
            var data = docSnapshot.data();
            List<dynamic> appointments = data?['appointments'] ?? [];

            // Check if an appointment with the same ID exists in the appointments list
            int index = appointments.indexWhere(
                (appt) => appt['appointmentID'] == appointment.appointmentID);

            print("found index : " + index.toString());
            if (index != -1) {
              // Update the existing appointment
              appointments[index] = appointment.toJson();
            }

            // Update the 'appointments' field in Firestore
            FirebaseFirestore.instance
                .collection("users")
                .doc(appUser.uid)
                .update({
              "appointments": appointments,
            }).then((_) {
              print("Appointment updated successfully.");
            }).catchError((error) {
              print("Failed to update appointment: $error");
            });
          } else {
            print("User document does not exist.");
          }
        }).catchError((error) {
          print("Failed to retrieve user document: $error");
        }),

        //4/10/2023 - comment useless codes

        // condition: (1) date same (2) date different
        if (oldDate == appointment.date)
          FirebaseFirestore.instance
              .collection("physiotherapists")
              .doc(appointment.physiotherapistInCharge?.id)
              .collection("appointmentSlots")
              .doc(oldDate)
              .get()
              .then(
            (docSnapshot) {
              if (docSnapshot.exists) {
                var data = docSnapshot.data();

                Map<String, dynamic> timeslots = data?['timeSlots'] ?? {};

                timeslots.forEach((key, value) {
                  if (value["appointmentID"] == appointment.appointmentID) {
                    if (key != appointment.time) {
                      timeslots[appointment.time!] = {
                        "appointmentID": appointment.appointmentID,
                        "patientID": appointment.patientID,
                      };
                      timeslots.remove(key);
                    }
                  }
                });

                // Check if an appointment with the same ID exists in the timeslots lis

                // Update the 'timeslots' field in Firestore
                FirebaseFirestore.instance
                    .collection("physiotherapists")
                    .doc(appointment.physiotherapistInCharge?.id)
                    .collection("appointmentSlots")
                    .doc(oldDate)
                    .update({
                  "timeSlots": timeslots,
                }).then((_) {
                  print("Appointment updated successfully. (old date)");
                }).catchError((error) {
                  print("Failed to upda te appointment: $error");
                });
              } else {
                print("appointment date document does not exist.");
              }
            },
          ),
        if (oldDate != appointment.date)
          FirebaseFirestore.instance
              .collection("physiotherapists")
              .doc(appointment.physiotherapistInCharge?.id)
              .collection("appointmentSlots")
              .doc(oldDate)
              .get()
              .then(
            (docSnapshot) {
              if (docSnapshot.exists) {
                var data = docSnapshot.data();

                Map<String, dynamic> timeslots = data?['timeSlots'] ?? {};

                timeslots.forEach((key, value) {
                  if (value["appointmentID"] == appointment.appointmentID) {
                    timeslots.remove(key);
                  }
                });

                // Check if an appointment with the same ID exists in the timeslots lis

                // Update the 'timeslots' field in Firestore
                FirebaseFirestore.instance
                    .collection("physiotherapists")
                    .doc(appointment.physiotherapistInCharge?.id)
                    .collection("appointmentSlots")
                    .doc(oldDate)
                    .update({
                  "timeSlots": timeslots,
                }).then((_) {
                  print("Appointment updated successfully. (new date)");
                }).catchError((error) {
                  print("Failed to update appointment: $error");
                });

                AppointmentSlots appointmentSlots = AppointmentSlots(
                  date: DateTime.parse(appointment.date!),
                  timeSlots: {
                    appointment.time!: TimeSlot(
                      appointmentID: appointment.appointmentID,
                      patientID: appointment.patientID,
                    )
                  },
                );

                print("Check appointment slots: ");
                print(appointmentSlots.toJson());

                //TODO : check if this works
                // FirebaseFirestore.instance
                //     .collection("physiotherapists")
                //     .doc(appointment.physiotherapistInCharge?.id)
                //     .collection("appointmentSlots")
                //     .doc(appointment.date)
                //     .set(appointmentSlots.toJson(), SetOptions(merge: true));
                FirebaseFirestore.instance
                    .collection("physiotherapists")
                    .doc(appointment.physiotherapistInCharge?.id)
                    .collection("appointmentSlots")
                    .doc(appointment.date)
                    .update({
                  "timeSlots": {
                    appointment.time!: {
                      "appointmentID": appointment.appointmentID,
                      "patientID": appointment.patientID,
                    }
                  }
                });
              } else {
                print("appointment date document does not exist.");
              }
            },
          ),

        FirebaseFirestore.instance
            .collection("appointments")
            .doc(appointment.appointmentID)
            .set(appointment.toJson(), SetOptions(merge: true)),
      ]);
      await FirebaseAuthRepository.getUserDetails(appUser.uid!);
      print("See appointmentssssssssssssss");
      // print(Get.find<AppUser>().appointments.toString());
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  static Future<bool> deleteAppointment(Appointment appointment) async {
    final appUser = Get.find<AppUser>();
    try {
      await Future.wait([
        FirebaseFirestore.instance
            .collection("users")
            .doc(appUser.uid)
            .get()
            .then((docSnapshot) {
          if (docSnapshot.exists) {
            var data = docSnapshot.data();
            List<dynamic> appointments = data?['appointments'] ?? [];

            int index = appointments.indexWhere(
                (appt) => appt['appointmentID'] == appointment.appointmentID);

            if (index != -1) {
              appointments.removeAt(index);
            }

            FirebaseFirestore.instance
                .collection("users")
                .doc(appUser.uid)
                .update({
              "appointments": appointments,
            }).then((_) {
              print("Appointment deleted successfully.");
            }).catchError((error) {
              print("Failed to delete appointment: $error");
            });
          } else {
            print("User document does not exist.");
          }
        }).catchError((error) {
          print("Failed to retrieve user document: $error");
        }),
        // double check on this : create date map, and inside with time map stores bool value and appointment id
        FirebaseFirestore.instance
            .collection("physiotherapists")
            .doc(appointment.physiotherapistInCharge?.id)
            .collection("appointmentSlots")
            .doc(appointment.date)
            .set({
          appointment.time!: FieldValue.delete(),
        }, SetOptions(merge: true)),

        FirebaseFirestore.instance
            .collection("appointments")
            .doc(appointment.appointmentID)
            .delete(),
      ]);
      await FirebaseAuthRepository.getUserDetails(appUser.uid!);
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }
}
