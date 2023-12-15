import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserRepository extends GetxService {
  static Future<List<AppUser>> fetchAllUsers() async {
    try {
      List<AppUser> allUsers = [];
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      allUsers = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return AppUser.fromJson(data);
      }).toList();
      return allUsers;
    } catch (e) {
      // Handle exceptions
      print(e);
      return [];
    }
  }

  static Future<List<AppUser>> fetchAllPatients() async {
    try {
      List<AppUser> patientUsers = [];
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'patient')
          .get();

      patientUsers = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return AppUser.fromJson(data);
      }).toList();
      return patientUsers;
    } catch (e) {
      // Handle exceptions
      print(e);
      return [];
    }
  }

  static Future<List<AppUser>> fetchAllAdmins() async {
    try {
      List<AppUser> adminUsers = [];
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .get();

      adminUsers = querySnapshot.docs.map((doc) {
        return AppUser.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
      return adminUsers;
    } catch (e) {
      // Handle exceptions
      print("Error User Repo: " + e.toString());
      return [];
    }
  }
}
