import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
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

class FirebaseAuthRepository {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  static subscribeIDTokenListening() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      if (user == null) {
        debugPrint("user is signed out");
      } else {
        debugPrint("user is signed in");
        debugPrint("uid: ${user.uid}");
      }
    });
  }

  static User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  static Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    final appUser = Get.find<AppUser>();
    try {
      UserCredential res = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      await getUserDetails(res.user!.uid);
      return res;
    } on FirebaseAuthException catch (e) {
      throw Error();
    }
  }

  static Future<UserCredential> signUpWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential res = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return res;
    } on FirebaseAuthException catch (e) {
      throw Error();
    }
  }

  // data map must contain uid, name, icNumber, email ...
  Future<bool> initUserDataWithUID(
      String uid, Map<String, dynamic> data) async {
    final appUser = Get.find<AppUser>();
    try {
      await userCollection.doc(uid).set({
        "uid": uid,
        "name": data["name"],
        "icNumber": data["ic"],
        "email": data["email"],
        "phoneNumber": data["phone"],
        "dateOfBirth": data["dob"],
        "gender": data["gender"],
        "registeredOn": FieldValue.serverTimestamp(),
      });
      appUser.setDetails(
        uid: data["uid"],
        name: data["name"],
        icNumber: data["icNumber"],
        email: data["email"],
        phoneNumber: data["phoneNumber"],
        dateOfBirth: data["dateOfBirth"],
        gender: data["gender"],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getUserDetails(String uid) async {
    final appUser = Get.find<AppUser>();
    try {
      dynamic data = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get()
          .then((doc) => doc.exists ? doc.data() : null);

      print("LOOOOOOOOOOOKKKKK " + data.toString());

      if (data == null) {
        debugPrint("No doc found");
        throw Error();
      }

      appUser.setDetails(
        uid: data["uid"],
        name: data["name"],
        icNumber: data["icNumber"],
        email: data["email"],
        phoneNumber: data["phoneNumber"],
        dateOfBirth: DateTime.parse(data["dateOfBirth"]),
        gender: data["gender"],
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
