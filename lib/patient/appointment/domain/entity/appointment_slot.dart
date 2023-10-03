import 'package:brain_training_app/patient/appointment/domain/entity/time_slot.dart';

class AppointmentSlots {
  DateTime? date;
  Map<String, TimeSlot>? timeSlots;

  AppointmentSlots({
    this.date,
    this.timeSlots,
  });

  factory AppointmentSlots.fromJson(Map<String, dynamic> json) {
    return AppointmentSlots(
      date: DateTime.parse(json['date']),
      timeSlots: json['timeSlots'] != null
          ? (json['timeSlots'] as Map<String, dynamic>).map((key, value) {
              return MapEntry(key, TimeSlot.fromJson(value));
            })
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date!.toIso8601String();
    if (this.timeSlots != null) {
      data['timeSlots'] =
          this.timeSlots!.map((key, value) => MapEntry(key, value.toJson()));
    }
    return data;
  }
}