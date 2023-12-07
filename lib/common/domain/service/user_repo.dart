import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserRepository extends GetxService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<AppUser> _allUsers = [];
  List<AppUser> _patientUsers = [];
  List<AppUser> _adminUsers = [];
  List<AppUser> get getAllUsers => _allUsers;
  List<AppUser> get getPatientUsers => _patientUsers;
  List<AppUser> get getAdminUsers => _adminUsers;

  Future<List<AppUser>> fetchAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('users').get();
      _allUsers = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return AppUser.fromJson(data);
      }).toList();
      return _allUsers;
    } catch (e) {
      // Handle exceptions
      print(e);
      return [];
    }
  }

  Future<List<AppUser>> fetchAllPatients() async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('role', isEqualTo: 'patient')
          .get();

      _patientUsers = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return AppUser.fromJson(data);
      }).toList();
      return _patientUsers;
    } catch (e) {
      // Handle exceptions
      print(e);
      return [];
    }
  }

  Future<List<AppUser>> fetchAllAdmins() async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .get();

      _adminUsers = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return AppUser.fromJson(data);
      }).toList();
      return _adminUsers;
    } catch (e) {
      // Handle exceptions
      print(e);
      return [];
    }
  }
}
