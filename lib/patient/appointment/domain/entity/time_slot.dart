class TimeSlot {
  String? appointmentID;
  String? patientID;

  TimeSlot({this.appointmentID, this.patientID});

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      appointmentID: json['id'],
      patientID: json['patientID'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointmentID'] = this.appointmentID;
    data['patientID'] = this.patientID;
    return data;
  }
}
