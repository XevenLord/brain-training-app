import 'package:brain_training_app/patient/appointment/domain/entity/physiotherapist.dart';

class AdminAppointment {
  String? appointmentID;
  String? patient;
  String? patientID;
  String? date;
  String? time;
  String? reason;
  String? physiotherapistID;
  String? status;

  AdminAppointment(
      {this.appointmentID,
      this.date,
      this.time,
      this.reason,
      this.patient,
      this.patientID,
      this.physiotherapistID,
      this.status});

  AdminAppointment.fromJson(Map<String, dynamic> json) {
    appointmentID = json['appointmentID'];
    patient = json['patient'];
    patientID = json['patientID'];
    date = json['date'];
    time = json['time'];
    reason = json['reason'];
    physiotherapistID = json['physiotherapistID'];
    status = json['status'];
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
    return data;
  }

  static List<AdminAppointment> fromJsonList(List<dynamic> json) {
    List<AdminAppointment> appointments = [];
    for(var element in json) {
      appointments.add(AdminAppointment.fromJson(element));
    }
    return appointments;
  }
}
