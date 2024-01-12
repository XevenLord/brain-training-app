import 'package:brain_training_app/patient/appointment/domain/entity/appointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String? profilePic;
  String? role;
  String? position;
  DateTime? mentalQuiz;
  String? lastOnline;
  String? strokeType;

  AppUser({
    this.uid,
    this.name,
    this.icNumber,
    this.email,
    this.phoneNumber,
    this.dateOfBirth,
    this.gender,
    this.aboutMe,
    this.profilePic,
    this.role,
    this.position,
    this.mentalQuiz,
    this.lastOnline,
    this.strokeType,
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
      aboutMe: json["aboutMe"],
      profilePic: json["profilePic"],
      role: json["role"],
      position: json["position"],
      mentalQuiz: json["mentalQuiz"] != null
          ? DateTime.parse(json["mentalQuiz"])
          : null,
      lastOnline: json["lastOnline"],
      strokeType: json["strokeType"],
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
      'aboutMe': aboutMe,
      'profilePic': profilePic,
      'role': role,
      'position': position,
      'mentalQuiz': mentalQuiz != null ? Timestamp.fromDate(mentalQuiz!) : null,
      'lastOnline': lastOnline,
      'strokeType': strokeType,
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
    String? profilePic,
    String? role,
    String? position,
    DateTime? mentalQuiz,
    String? lastOnline,
    String? strokeType,
  }) {
    this.uid = uid;
    this.name = name;
    this.icNumber = icNumber;
    this.email = email;
    this.phoneNumber = phoneNumber;
    this.dateOfBirth = dateOfBirth;
    this.gender = gender;
    this.aboutMe = aboutMe;
    this.profilePic = profilePic;
    this.role = role;
    this.position = position;
    this.mentalQuiz = mentalQuiz;
    this.lastOnline = lastOnline;
    this.strokeType = strokeType;
  }

  void clear() {
    uid = null;
    name = null;
    icNumber = null;
    email = null;
    phoneNumber = null;
    dateOfBirth = null;
    gender = null;
    aboutMe = null;
    profilePic = null;
    role = null;
    position = null;
    mentalQuiz = null;
    lastOnline = null;
    strokeType = null;
  }
}
