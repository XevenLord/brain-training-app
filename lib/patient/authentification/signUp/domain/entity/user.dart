import 'package:brain_training_app/patient/appointment/domain/entity/appointment.dart';
import 'package:intl/intl.dart';

class AppUser {
  String? uid;
  String? name;
  String? icNumber;
  String? email;
  String? phoneNumber;
  DateTime? dateOfBirth;
  String? gender;
  String? aboutMe;
  List<Appointment>? appointments;
  String? profilePic;
  String? role;
  String? position;
  DateTime? mentalQuizCompletedDate;

  AppUser({
    this.uid,
    this.name,
    this.icNumber,
    this.email,
    this.phoneNumber,
    this.dateOfBirth,
    this.gender,
    this.appointments,
    this.aboutMe,
    this.profilePic,
    this.role,
    this.position,
    this.mentalQuizCompletedDate,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json["uid"],
      name: json["name"],
      icNumber: json["icNumber"],
      email: json["email"],
      phoneNumber: json["phoneNumber"],
      dateOfBirth: json["dateOfBirth"] != null
          ? DateTime.parse(json["dateOfBirth"])
          : null,
      gender: json["gender"],
      appointments: json["appointments"] != null
          ? List<Appointment>.from(json["appointments"].map((appointment) {
              return Appointment.fromJson(appointment);
            }))
          : [],
      aboutMe: json["aboutMe"],
      profilePic: json["profilePic"],
      role: json["role"],
      position: json["position"],
      mentalQuizCompletedDate: json["mentalQuizCompletedDate"] != null
          ? DateTime.parse(json["mentalQuizCompletedDate"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'icNumber': icNumber,
      'email': email,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth != null
          ? DateFormat("yyyy-mm-dd").format(dateOfBirth!)
          : "",
      'gender': gender,
      'appointments': appointments != null
          ? List<dynamic>.from(appointments!.map((appointment) {
              return appointment.toJson();
            }))
          : [],
      'aboutMe': aboutMe,
      'profilePic': profilePic,
      'role': role,
      'position': position,
      'mentalQuizCompletedDate': mentalQuizCompletedDate != null
          ? DateFormat().format(mentalQuizCompletedDate!)
          : "",
    };
  }

  void setDetails({
    String? uid,
    String? name,
    String? icNumber,
    String? email,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? gender,
    String? aboutMe,
    List<Appointment>? appointments,
    String? profilePic,
    String? role,
    String? position,
    DateTime? mentalQuizCompletedDate,
  }) {
    this.uid = uid;
    this.name = name;
    this.icNumber = icNumber;
    this.email = email;
    this.phoneNumber = phoneNumber;
    this.dateOfBirth = dateOfBirth;
    this.gender = gender;
    this.appointments = appointments;
    this.aboutMe = aboutMe;
    this.profilePic = profilePic;
    this.role = role;
    this.position = position;
    this.mentalQuizCompletedDate = mentalQuizCompletedDate;
  }

  void clear() {
    uid = null;
    name = null;
    icNumber = null;
    email = null;
    phoneNumber = null;
    dateOfBirth = null;
    gender = null;
    appointments = null;
    aboutMe = null;
    profilePic = null;
    role = null;
    position = null;
    mentalQuizCompletedDate = null;
  }
}
