import 'package:brain_training_app/patient/appointment/domain/entity/appointment.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppUser extends GetxController {
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
  }
}

class UserChat {
  UserChat({
    this.connection,
    this.chatId,
    this.lastTime,
    this.lastContent,
    this.lastSender,
    this.totalUnread,
  });

  String? connection;
  String? chatId;
  String? lastTime;
  String? lastContent;
  String? lastSender;
  int? totalUnread;

  factory UserChat.fromJson(Map<String, dynamic> json) => UserChat(
        connection: json["connection"] as String?,
        chatId: json["chatId"] as String?,
        lastTime: json["lastTime"] as String?,
        lastContent: json["lastContent"] as String?,
        lastSender: json["lastSender"] as String?,
        totalUnread: json["totalUnread"] as int?,
      );

  Map<String, dynamic> toJson() => {
        "connection": connection ?? "",
        "chatId": chatId ?? "",
        "lasTime": lastTime ?? "",
        "lastContent": lastContent ?? "",
        "lastSender": lastSender ?? "",
        "totalUnread": totalUnread ?? 0,
      };
}
