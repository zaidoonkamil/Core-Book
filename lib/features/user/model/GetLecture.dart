import 'dart:convert';

List<GetLecture> getLectureFromJson(String str) => List<GetLecture>.from(json.decode(str).map((x) => GetLecture.fromJson(x)));

String getLectureToJson(List<GetLecture> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetLecture {
  int id;
  String title;
  int teacherId;
  DateTime createdAt;
  DateTime updatedAt;

  GetLecture({
    required this.id,
    required this.title,
    required this.teacherId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GetLecture.fromJson(Map<String, dynamic> json) => GetLecture(
    id: json["id"],
    title: json["title"],
    teacherId: json["teacherId"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "teacherId": teacherId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
