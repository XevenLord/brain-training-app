import 'package:brain_training_app/main.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/home/domain/service/home_service.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This repo enables:
// 1. sign up
// 2. init user data
// 3. sign in
// 4. get user details

class FirebaseAuthRepository extends GetxController {
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

  static void showMessage(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Image.asset(AppConstant.ERROR_IMG, width: 100.w),
              SizedBox(height: 10.h),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: AppTextStyle.h3,
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<UserCredential> signInWithEmailAndPassword(BuildContext context,
      {required String email, required String password}) async {
    try {
      debugModePrint("entering signInWithEmailAndPassword");
      UserCredential res = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      debugModePrint("entering storeCredentials");
      await storeCredentials(email, password);
      debugModePrint("entering getUserDetails");
      await getUserDetails(res.user!.uid);
      print("successfully get user details");
      return res;
    } on FirebaseAuthException catch (e) {
      Get.back();
      switch (e.code) {
        case 'invalid-email':
          showMessage(context, "Invalid email. Please try again.");
          break;
        case 'wrong-password':
          showMessage(context, "Wrong password. Please try again.");
          break;
        case 'user-not-found':
          showMessage(context, "User not found. Please sign up first.");
          break;
        case 'user-disabled':
          showMessage(context, "User has been disabled.");
          break;
      }
      throw e;
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

  static Future<UserCredential?> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      debugModePrint("check sign up password passed in: $password");
      UserCredential res = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return res;
    } on FirebaseAuthException catch (e) {
      // Handle the FirebaseAuthException and show an error dialog
      showDialog(
        context: Get.context!,
        // Your dialog configuration here
        // You can use Flutter's built-in dialogs or a custom dialog widget
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Sign Up Error"),
            content: Text(e.toString()), // Display the error message
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      throw e;
    }
  }

  static Future<UserCredential> registerAdmin(
      {required String email, required String password}) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    try {
      UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);
      await app.delete();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Do something with exception. This try/catch is here to make sure
      // that even if the user creation fails, app.delete() runs, if is not,
      // next time Firebase.initializeApp() will fail as the previous one was
      // not deleted.
      await app.delete();
      throw Error();
    }
  }

  // data map must contain uid, name, icNumber, email ...
  Future<bool> initUserDataWithUID(String uid, Map<String, dynamic> data,
      {bool setUserDetails = true}) async {
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
        "role": data["role"] ?? "patient",
        "profilePic": data["profilePic"],
        "aboutMe": data["aboutMe"],
        "lastOnline": FieldValue.serverTimestamp(),
        "lastInspired": FieldValue.serverTimestamp(),
        "strokeType": data["strokeType"],
        "mentalQuiz": data["mentalQuiz"],
        "assignedTo": data["assignedTo"],
        // "appointments": [],
      });
      if (data["role"] == "admin") {
        await userCollection.doc(uid).update({
          "position": data["position"],
        });
      }
      debugModePrint("init set firebase done...");
      if (setUserDetails)
        appUser.setDetails(
          uid: data["uid"],
          name: data["name"],
          icNumber: data["icNumber"],
          email: data["email"],
          phoneNumber: data["phoneNumber"],
          dateOfBirth: data["dateOfBirth"],
          gender: data["gender"],
          role: "patient",
          profilePic: data["profilePic"],
          aboutMe: data["aboutMe"],
          lastOnline: DateTime.now(),
          lastInspired: DateTime.now(),
          strokeType: data["strokeType"],
          mentalQuiz: data["mentalQuiz"],
          assignedTo: data["assignedTo"],
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

  static Future<void> updateLastOnline(String userId) async {
    try {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      await userRef.update({'lastOnline': FieldValue.serverTimestamp()});
    } catch (e) {
      throw e;
    }
  }

  static Future<bool> getUserDetails(String uid) async {
    final appUser = Get.find<AppUser>();
    try {
      dynamic data = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get(GetOptions(source: Source.server))
          .then((doc) => doc.exists ? doc.data() : null);

      if (data == null) {
        debugModePrint("No doc found");
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
        aboutMe: data["aboutMe"],
        profilePic: data["profilePic"],
        role: data["role"],
        position: data["position"],
        lastOnline: data["lastOnline"] != null
            ? (data["lastOnline"] as Timestamp).toDate()
            : null,
        lastInspired: data["lastInspired"] != null
            ? (data["lastInspired"] as Timestamp).toDate()
            : null,
        // Here got error at below 16/12/2023
        mentalQuiz: data["mentalQuiz"] != null
            ? DateTime.parse(data["mentalQuiz"])
            : null,
        assignedTo: data["assignedTo"],
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

  static Future<void> sendPasswordResetEmail({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
