import 'dart:convert';

List<Line> lineFromJson(String str) =>
    List<Line>.from(json.decode(str).map((x) => Line.fromJson(x)));

String lineToJson(List<Line> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Line {
  String line;
  String model;
  String linePart;
  final String part;
  bool containerExpanded;

  Line({
    required this.line,
    required this.model,
    required this.linePart,
    required this.part,
    required this.containerExpanded,
  });

  factory Line.fromJson(Map<String, dynamic> json) => Line(
        line: json["line"],
        model: json["model"],
        linePart: json["part"],
        part: '',
        containerExpanded: false, // Set the initial value of containerExpanded
      );

  Map<String, dynamic> toJson() => {
        "line": [line],
        "model": [model],
        "part": linePart,
      };

  String getModelPart() {
    return '$model $part';
  }
}
