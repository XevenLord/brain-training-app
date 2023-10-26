import 'dart:convert';
import 'dart:math';

import 'package:brain_training_app/main.dart';
import 'package:brain_training_app/patient/appointment/domain/entity/appointment.dart';
import 'package:brain_training_app/patient/appointment/domain/entity/physiotherapist.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/home/domain/service/home_service.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This repo enables:
// 1. sign up
// 2. init user data
// 3. sign in
// 4. get user details

class FirebaseAuthRepository extends GetxController{
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static FirebaseAuth get firebaseAuth => _firebaseAuth;
  User? get currentUser => _firebaseAuth.currentUser;

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  static subscribeIDTokenListening() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      if (user == null) {
        debugModePrint("user is signed out");
      } else {
        debugModePrint("user is signed in");
        debugModePrint("uid: ${user.uid}");

        user.reauthenticateWithCredential(EmailAuthProvider.credential(
            email: user.email!, password: user.email!));
      }
    });
  }

  static Future<void> storeCredentials(String email, String password) async {
    debugModePrint("storeCredentials: start writing...");
    await secureStorage.write(key: 'email', value: email);
    await secureStorage.write(key: 'password', value: password);
    debugModePrint("storeCredentials: done writing...");
  }

  static Future<String?> getEmail() async {
    return await secureStorage.read(key: 'email');
  }

  static Future<String?> getPassword() async {
    return await secureStorage.read(key: 'password');
  }

  static User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  static Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      debugModePrint("entering signInWithEmailAndPassword");
      UserCredential res = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      debugModePrint("entering storeCredentials");
      await storeCredentials(email, password);
      debugModePrint("entering getUserDetails");
      await getUserDetails(res.user!.uid);
      print("sign in : " + Get.find<AppUser>().name!);
      return res;
    } on FirebaseAuthException catch (e) {
      throw Error();
    }
  }

  static Future<void> signInWithStoredCredentials() async {
    final email = await getEmail();
    final password = await getPassword();

    if (email != null && password != null) {
      try {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        print('User reauthenticated successfully');
      } catch (e) {
        print('Error reauthenticating user: $e');
      }
    } else {
      print('Stored credentials not found');
      await HomeService.signOut();
      // Prompt the user to log in again
    }
  }

  static Future<UserCredential> signUpWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      debugModePrint("check sign up password passed in: $password");
      UserCredential res = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return res;
    } on FirebaseAuthException catch (e) {
      throw Error();
    }
  }

  Future<List<Appointment>> getAppointments() async {
    List<Appointment> appointments = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('appointments').get();

    appointments = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      debugModePrint("checking Appointment retrieved from firebase...");
      return Appointment(
        date: data['date'],
        reason: data['reason'],
        patientID: data['patientID'],
        appointmentID: data['appointmentID'],
        patient: data['patient'],
        physiotherapistInCharge: Physiotherapist(
          imgUrl: data['physiotherapistInCharge']['imgUrl'],
          speciality: data['physiotherapistInCharge']['speciality'],
          phone: data['physiotherapistInCharge']['phone'],
          about: data['physiotherapistInCharge']['about'],
          name: data['physiotherapistInCharge']['name'],
          id: data['physiotherapistInCharge']['id'],
          email: data['physiotherapistInCharge']['email'],
        ),
        time: data['time'],
      );
    }).toList();
    return appointments;
  }

  // data map must contain uid, name, icNumber, email ...
  Future<bool> initUserDataWithUID(
      String uid, Map<String, dynamic> data) async {
    debugModePrint("entering init process...");
    final appUser = Get.find<AppUser>();
    try {
      debugModePrint("init process started...");
      await userCollection.doc(uid).set({
        "uid": uid,
        "name": data["name"],
        "icNumber": data["ic"],
        "email": data["email"],
        "phoneNumber": data["phone"],
        "dateOfBirth": data["dob"],
        "gender": data["gender"],
        "registeredOn": FieldValue.serverTimestamp(),
        // "appointments": [],
      });
      debugModePrint("init set firebase done...");
      appUser.setDetails(
        uid: data["uid"],
        name: data["name"],
        icNumber: data["icNumber"],
        email: data["email"],
        phoneNumber: data["phoneNumber"],
        dateOfBirth: data["dateOfBirth"],
        gender: data["gender"],
        // appointments: [],
      );
      debugModePrint("init process done...");
      return true;
    } catch (e) {
      debugModePrint("init process failed...");
      debugModePrint(e.toString());
      return false;
    }
  }

  static Future<bool> getUserDetails(String uid) async {
    final appUser = Get.find<AppUser>();
    try {
      debugModePrint("auth repo: getting user details...");
      dynamic data = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get(GetOptions(source: Source.server))
          .then((doc) => doc.exists ? doc.data() : null);

      if (data == null) {
        debugModePrint("No doc found");
        throw Error();
      }

      print("check the appointments (1)");

      appUser.setDetails(
        uid: data["uid"],
        name: data["name"],
        icNumber: data["icNumber"],
        email: data["email"],
        phoneNumber: data["phoneNumber"],
        dateOfBirth: DateTime.parse(data["dateOfBirth"]),
        gender: data["gender"],
        aboutMe: data["aboutMe"],
        appointments: data["appointments"] != null
            ? List<Appointment>.from(data["appointments"].map((appointment) {
                return Appointment.fromJson(appointment);
              }))
            : [],
      );

      // store uid in shared preference
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (appUser.uid != null) {
        await prefs.setString('uid', appUser.uid!);
      }

      return true;
    } on FirebaseException catch (e) {
      return false;
    } catch (e) {
      return false;
    }
  }
}
