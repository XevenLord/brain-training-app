import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserRepository extends GetxService {
  static List<AppUser> _admins = [].obs as List<AppUser>;
  static List<AppUser> _patients = [].obs as List<AppUser>;
  //getter
  static List<AppUser> get admins => _admins.obs as List<AppUser>;
  static List<AppUser> get patients => _patients;

  static Future<List<AppUser>> fetchAllUsers() async {
    try {
      List<AppUser> allUsers = [];
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      allUsers = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return AppUser.fromJson(data);
      }).toList();
      _admins = allUsers.where((user) => user.role == 'admin').toList();
      _patients = allUsers.where((user) => user.role == 'patient').toList();
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

      print("Check fetch patients data");
      patientUsers = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return AppUser.fromJson(data);
      }).toList();
      _patients = patientUsers;
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
      _admins = adminUsers;
      return adminUsers;
    } catch (e) {
      // Handle exceptions
      print("Error User Repo: " + e.toString());
      return [];
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

  static Future<void> fetchSpecificAdmin(String uid) async {
    try {
      AppUser user;
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          user =
              AppUser.fromJson(documentSnapshot.data() as Map<String, dynamic>);
          _admins.add(user);
        } else {
          print('Document does not exist on the database');
        }
      });
    } catch (e) {
      // Handle exceptions
      print(e);
    }
  }
}
