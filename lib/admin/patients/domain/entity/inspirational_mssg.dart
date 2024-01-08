class InspirationalMessage {
  String? id;
  String? message;
  String? sender;
  String? receiverUid;
  DateTime? createdAt;
  String? imgUrl;

  InspirationalMessage({
    required this.message,
    this.id,
    this.sender,
    this.receiverUid,
    this.createdAt,
    this.imgUrl,
  });

  factory InspirationalMessage.fromJson(Map<String, dynamic> json) {
    return InspirationalMessage(
      id: json['id'],
      message: json['message'],
      sender: json['sender'],
      receiverUid: json['receiverUid'],
      createdAt: json['createdAt'] != null ? json['createdAt'].toDate() : null,
      imgUrl: json['imgUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'sender': sender,
      'receiverUid': receiverUid,
      'createdAt': createdAt,
      'imgUrl': imgUrl,
    };
  }

  // setter and getter
  String? get getId => id;
  String? get getMessage => message;
  String? get getSender => sender;
  String? get getReceiverUid => receiverUid;
  DateTime? get getCreatedAt => createdAt;
  String? get getImgUrl => imgUrl;

  set setId(String? id) => this.id = id;
  set setMessage(String? message) => this.message = message;
  set setSender(String? sender) => this.sender = sender;
  set setReceiverUid(String? receiverUid) => this.receiverUid = receiverUid;
  set setCreatedAt(DateTime? createdAt) => this.createdAt = createdAt;
  set setImgUrl(String? imgUrl) => this.imgUrl = imgUrl;
}
