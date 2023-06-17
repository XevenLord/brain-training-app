class UserChat {
  UserChat({
    this.connection,
    this.chatId,
    this.lastTime,
    this.lastContent,
    this.lastSender,
    this.totalUnread,
  });

  String? connection;
  String? chatId;
  String? lastTime;
  String? lastContent;
  String? lastSender;
  int? totalUnread;

  factory UserChat.fromJson(Map<String, dynamic> json) => UserChat(
        connection: json["connection"] as String?,
        chatId: json["chatId"] as String?,
        lastTime: json["lastTime"] as String?,
        lastContent: json["lastContent"] as String?,
        lastSender: json["lastSender"] as String?,
        totalUnread: json["totalUnread"] as int?,
      );

  Map<String, dynamic> toJson() => {
        "connection": connection ?? "",
        "chatId": chatId ?? "",
        "lasTime": lastTime ?? "",
        "lastContent": lastContent ?? "",
        "lastSender": lastSender ?? "",
        "totalUnread": totalUnread ?? 0,
      };
}