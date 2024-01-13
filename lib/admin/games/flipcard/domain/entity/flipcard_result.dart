class FlipCardResult {
  int second;
  String level;
  DateTime timestamp;

  FlipCardResult({
    required this.second,
    required this.level,
    required this.timestamp,
  });

  factory FlipCardResult.fromJson(Map<String, dynamic> json) {
    return FlipCardResult(
      second: json["second"],
      level: json["level"],
      timestamp: json["timestamp"].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'second': second,
      'level': level,
      'timestamp': timestamp,
    };
  }

  static List<FlipCardResult> fromJsonList(List<dynamic> json) {
    List<FlipCardResult> flipCardResults = [];
    json.forEach((element) {
      flipCardResults.add(FlipCardResult.fromJson(element));
    });
    return flipCardResults;
  }
}
