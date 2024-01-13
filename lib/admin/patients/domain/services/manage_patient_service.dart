import 'package:brain_training_app/admin/patients/domain/entity/inspirational_mssg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManagePatientService {
  static Future<bool> onPushInspirationalMessage(
      InspirationalMessage inspirationalMssg) async {
    try {
      final insMssgCollectionRef =
          FirebaseFirestore.instance.collection('inspirationalMssg');

      insMssgCollectionRef
          .doc(inspirationalMssg.receiverUid)
          .set({'uid': inspirationalMssg.receiverUid});

      final insMssgDocRef = insMssgCollectionRef
          .doc(inspirationalMssg.receiverUid)
          .collection('inspirationalMssg')
          .doc();

      insMssgDocRef.set(inspirationalMssg.toJson());

      inspirationalMssg.id = insMssgDocRef.id;
      insMssgDocRef.update(inspirationalMssg.toJson());

      return Future.value(true);
    } catch (e) {
      return Future.value(false);
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

  static Future<List<InspirationalMessage>> getInspirationalMessagesByUser(
      String userId) async {
    try {
      print("Enter Manage Patient Ins Mssg service");
      final snapshot = await FirebaseFirestore.instance
          .collection('inspirationalMssg')
          .doc(userId)
          .collection('inspirationalMssg')
          .get();

      final inspirationalMessages = snapshot.docs.map((doc) {
        print(doc.data());
        return InspirationalMessage.fromJson(doc.data());
      }).toList();

      return inspirationalMessages;
    } catch (e) {
      return [];
    }
  }

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

  static Future<bool> updateInspirationalMessage(
      InspirationalMessage inspirationalMssg) async {
    try {
      if (inspirationalMssg.message == null ||
          inspirationalMssg.message!.isEmpty) {
        await deleteInspirationalMessage(inspirationalMssg);
      } else if (inspirationalMssg.receiverUid != null) {
        await FirebaseFirestore.instance
            .collection('inspirationalMssg')
            .doc(inspirationalMssg.receiverUid)
            .collection('inspirationalMssg')
            .doc(inspirationalMssg.id)
            .update(inspirationalMssg.toJson());
      } else {
        await FirebaseFirestore.instance
            .collection('inspirationalMssg')
            .doc('general')
            .collection('inspirationalMssg')
            .doc(inspirationalMssg.id)
            .update(inspirationalMssg.toJson());
      }

      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  static Future<bool> deleteInspirationalMessage(
      InspirationalMessage inspirationalMssg) async {
    try {
      if (inspirationalMssg.receiverUid != null) {
        await FirebaseFirestore.instance
            .collection('inspirationalMssg')
            .doc(inspirationalMssg.receiverUid)
            .collection('inspirationalMssg')
            .doc(inspirationalMssg.id)
            .delete();
      } else {
        await FirebaseFirestore.instance
            .collection('inspirationalMssg')
            .doc('general')
            .collection('inspirationalMssg')
            .doc(inspirationalMssg.id)
            .delete();
      }

      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }
}
