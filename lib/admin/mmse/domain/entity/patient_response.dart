import 'package:cloud_firestore/cloud_firestore.dart';

class PatientResponse {
  String patientId; // Unique ID of the response.
  String patientName; // Name of the patient who took the MMSE test.
  int score; // The score achieved by the patient in the MMSE test.
  DateTime timestamp; // The timestamp when the response was recorded.

  // Other relevant fields can be added based on your application's requirements.

  PatientResponse({
    required this.patientName,
    required this.score,
    required this.timestamp,
    this.patientId = '',
    // Add other fields as needed.
  });

  // You can add methods or constructors for parsing data, if necessary.

  factory PatientResponse.fromSnapshot(DocumentSnapshot snapshot, String uid) {
    final data = snapshot.data() as Map<String, dynamic>;
    return PatientResponse(
      patientId: uid,
      patientName: data['patientName'] ?? '',
      score: data['score'],
      timestamp: data['timestamp'].toDate(),
    );
  }
}
