class Option {
  final String text;
  bool isSelected;

  Option({required this.text, this.isSelected = false});

  factory Option.fromMap(Map<String, dynamic> map) {
    print("Enter from map option");
    return Option(
      text: map['text'],
      isSelected: map['isSelected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isSelected': isSelected,
    };
  }
}