import 'package:brain_training_app/patient/appointment/domain/entity/physiotherapist.dart';

class AdminAppointment {
  String? appointmentID;
  String? patient;
  String? patientID;
  String? date;
  String? time;
  String? reason;
  Physiotherapist? physiotherapistInCharge;
  String? physiotherapistID;

  AdminAppointment(
      {this.appointmentID,
      this.date,
      this.time,
      this.reason,
      this.physiotherapistInCharge,
      this.patient,
      this.patientID,
      this.physiotherapistID});

  AdminAppointment.fromJson(Map<String, dynamic> json) {
    appointmentID = json['appointmentID'];
    patient = json['patient'];
    patientID = json['patientID'];
    date = json['date'];
    time = json['time'];
    reason = json['reason'];
    physiotherapistInCharge = json['physiotherapistInCharge'] != null
        ? new Physiotherapist.fromJson(json['physiotherapistInCharge'])
        : null;
    physiotherapistID = json['physiotherapistID'];
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
    if (this.physiotherapistInCharge != null) {
      data['physiotherapistInCharge'] = this.physiotherapistInCharge!.toJson();
    }
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
