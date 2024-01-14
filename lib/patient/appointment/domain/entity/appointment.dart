import 'package:brain_training_app/patient/appointment/domain/entity/physiotherapist.dart';

class Appointment {
  String? appointmentID;
  String? patient;
  String? patientID;
  String? date;
  String? time;
  String? reason;
  String? physiotherapistID;
  String? status;
  bool? isRead;
  bool? isPhysioRead;

  Appointment({
    this.appointmentID,
    this.date,
    this.time,
    this.reason,
    this.patient,
    this.patientID,
    this.physiotherapistID,
    this.status,
    this.isRead = false,
    this.isPhysioRead = false,
  });

  Appointment.fromJson(Map<String, dynamic> json) {
    appointmentID = json['appointmentID'];
    patient = json['patient'];
    patientID = json['patientID'];
    date = json['date'];
    time = json['time'];
    reason = json['reason'];
    physiotherapistID = json['physiotherapistID'];
    status = json['status'];
    isRead = json['isRead'];
    isPhysioRead = json['isPhysioRead'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointmentID'] = this.appointmentID;
    data['patient'] = this.patient;
    data['patientID'] = this.patientID;
    data['date'] = this.date;
    data['time'] = this.time;
    data['reason'] = this.reason;
    data['physiotherapistID'] = this.physiotherapistID;
    data['status'] = this.status;
    data['isRead'] = this.isRead;
    data['isPhysioRead'] = this.isPhysioRead;
    return data;
  }

  static List<Appointment> fromJsonList(List<dynamic> json) {
    List<Appointment> appointments = [];
    for (var element in json) {
      appointments.add(Appointment.fromJson(element));
    }
    return appointments;
  }
}
