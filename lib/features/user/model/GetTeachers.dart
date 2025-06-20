import 'dart:convert';

List<GetTeachers> getTeachersFromJson(String str) => List<GetTeachers>.from(json.decode(str).map((x) => GetTeachers.fromJson(x)));

String getTeachersToJson(List<GetTeachers> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetTeachers {
  int id;
  String name;
  int subjectId;
  int price;
  List<String> images;
  DateTime createdAt;
  DateTime updatedAt;
  Subject subject;

  GetTeachers({
    required this.id,
    required this.name,
    required this.subjectId,
    required this.price,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
    required this.subject,
  });

  factory GetTeachers.fromJson(Map<String, dynamic> json) => GetTeachers(
    id: json["id"],
    name: json["name"],
    subjectId: json["subjectId"],
    price: json["price"],
    images: List<String>.from(json["images"].map((x) => x)),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    subject: Subject.fromJson(json["subject"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "subjectId": subjectId,
    "price": price,
    "images": List<dynamic>.from(images.map((x) => x)),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "subject": subject.toJson(),
  };
}

class Subject {
  String name;

  Subject({
    required this.name,
  });

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}
