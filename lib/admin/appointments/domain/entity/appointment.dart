import 'package:brain_training_app/patient/appointment/domain/entity/physiotherapist.dart';
import 'package:intl/intl.dart';

class AdminAppointment {
  String? appointmentID;
  String? patient;
  String? patientID;
  String? date;
  String? time;
  String? reason;
  String? physiotherapistID;
  String? status;
  String? remark;
  bool? isRead;
  bool? isPhysioRead;

  AdminAppointment({
    this.appointmentID,
    this.date,
    this.time,
    this.reason,
    this.patient,
    this.patientID,
    this.physiotherapistID,
    this.status,
    this.remark,
    this.isRead = false,
    this.isPhysioRead = false,
  });

  AdminAppointment.fromJson(Map<String, dynamic> json) {
    appointmentID = json['appointmentID'];
    patient = json['patient'];
    patientID = json['patientID'];
    date = json['date'];
    time = json['time'];
    reason = json['reason'];
    physiotherapistID = json['physiotherapistID'];
    status = json['status'];
    remark = json['remark'];
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
    data['remark'] = this.remark;
    data['isRead'] = this.isRead;
    data['isPhysioRead'] = this.isPhysioRead;
    return data;
  }

  static List<AdminAppointment> fromJsonList(List<dynamic> json) {
    List<AdminAppointment> appointments = [];
    for (var element in json) {
      appointments.add(AdminAppointment.fromJson(element));
    }
    return appointments;
  }

  bool get isExpired {
    DateTime appointmentDate = DateFormat('yyyy-MM-dd').parse(date!);
    return appointmentDate.isBefore(DateTime.now());
  }

  void updateStatusIfExpired() {
    if (status == "approved" && isExpired) {
      status = "expired";
    }
  }
}
