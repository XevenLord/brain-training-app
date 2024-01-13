import 'package:brain_training_app/common/domain/entity/math_ans.dart';

class MathSet {
  String? id;
  List<MathAnswer>? maths;

  MathSet({this.maths, this.id});

  factory MathSet.fromJson(Map<String, dynamic> json, String? id) {
    return MathSet(
      id: id,
      maths: MathAnswer.fromJsonList(json["answers"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'maths': maths,
    };
  }

  setMaths(List<MathAnswer> maths) {
    this.maths = maths;
  }
}
