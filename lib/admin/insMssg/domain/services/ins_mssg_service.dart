import 'package:brain_training_app/admin/patients/domain/entity/inspirational_mssg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InspirationalMssgService {
  static Future<List<InspirationalMessage>>
      getGeneralInspirationalMessages() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('inspirationalMssg')
          .doc('general')
          .collection('inspirationalMssg')
          .get();

      final inspirationalMessages = snapshot.docs
          .map((doc) => InspirationalMessage.fromJson(doc.data()))
          .toList();

      return inspirationalMessages;
    } catch (e) {
      return [];
    }
  }

  static Future<bool> onPushGeneralInspirationalMessage(
      InspirationalMessage mssg) async {
    try {
      DocumentReference ref = await FirebaseFirestore.instance
          .collection('inspirationalMssg')
          .doc('general')
          .collection('inspirationalMssg')
          .add(mssg.toJson());

      mssg.id = ref.id;
      await ref.update(mssg.toJson());

      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  static Future<bool> onDeleteGeneralInspirationalMessage(
      InspirationalMessage mssg) async {
    try {
      await FirebaseFirestore.instance
          .collection('inspirationalMssg')
          .doc('general')
          .collection('inspirationalMssg')
          .doc(mssg.id)
          .delete();

      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  static Future<bool> onUpdateGeneralInspirationalMessage(
      InspirationalMessage mssg) async {
    try {
      await FirebaseFirestore.instance
          .collection('inspirationalMssg')
          .doc('general')
          .collection('inspirationalMssg')
          .doc(mssg.id)
          .update(mssg.toJson());

      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }
}
