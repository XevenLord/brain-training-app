import 'package:cloud_firestore/cloud_firestore.dart';

class MessageChat {
  String? uid;
  DateTime? createdOn;
  String? msg;
  int? type;

  MessageChat({
    this.uid,
    this.createdOn,
    this.msg,
    this.type,
  }); 

  MessageChat.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    createdOn = json["createdOn"] != null
        ? DateTime.fromMillisecondsSinceEpoch(json["createdOn"] * 1000)
        : null;
    msg = json['msg'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = this.uid;
    data['createdOn'] = Timestamp.fromDate(this.createdOn!);
    data['msg'] = this.msg;
    data['type'] = this.type;
    return data;
  }

  // getter and setter
  String? get getUid => uid;
  setUid(String? uid) => this.uid = uid;

  DateTime? get getCreatedOn => createdOn;
  setCreatedOn(DateTime? createdOn) => this.createdOn = createdOn;

  String? get getMsg => msg;
  setMsg(String? msg) => this.msg = msg;

  int? get getType => type;
  setType(int? type) => this.type = type;
}
