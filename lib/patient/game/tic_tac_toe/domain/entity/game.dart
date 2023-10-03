class Game {
  String? gameID;
  String? gameName;
  num? duration;
  String? description;
  num? maxScore;

  Game({
    this.gameID,
    this.gameName,
    this.duration,
    this.description,
    this.maxScore,
  });

  Game.fromJson(Map<String, dynamic> json) {
    gameID = json['gameID'];
    gameName = json['gameName'];
    duration = json['duration'];
    description = json['description'];
    maxScore = json['maxScore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gameID'] = this.gameID;
    data['gameName'] = this.gameName;
    data['duration'] = this.duration;
    data['description'] = this.description;
    data['maxScore'] = this.maxScore;
    return data;
  }
}