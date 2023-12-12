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
    createdOn =
        json['createdOn'] != null ? DateTime.parse(json['createdOn']) : null;
    msg = json['msg'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = this.uid;
    data['createdOn'] = this.createdOn.toString();
    data['msg'] = this.msg;
    data['type'] = this.type;
    return data;
  }
}
