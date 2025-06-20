import 'dart:convert';

List<PendingOrderSubscriptionsModel> pendingOrderSubscriptionsModelFromJson(String str) => List<PendingOrderSubscriptionsModel>.from(json.decode(str).map((x) => PendingOrderSubscriptionsModel.fromJson(x)));

String pendingOrderSubscriptionsModelToJson(List<PendingOrderSubscriptionsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PendingOrderSubscriptionsModel {
  int id;
  int studentId;
  int teacherId;
  String status;
  dynamic startDate;
  dynamic endDate;
  DateTime createdAt;
  DateTime updatedAt;
  Teacher teacher;
  Student student;

  PendingOrderSubscriptionsModel({
    required this.id,
    required this.studentId,
    required this.teacherId,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    required this.teacher,
    required this.student,
  });

  factory PendingOrderSubscriptionsModel.fromJson(Map<String, dynamic> json) => PendingOrderSubscriptionsModel(
    id: json["id"],
    studentId: json["studentId"],
    teacherId: json["teacherId"],
    status: json["status"],
    startDate: json["startDate"],
    endDate: json["endDate"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    teacher: Teacher.fromJson(json["teacher"]),
    student: Student.fromJson(json["student"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "studentId": studentId,
    "teacherId": teacherId,
    "status": status,
    "startDate": startDate,
    "endDate": endDate,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "teacher": teacher.toJson(),
    "student": student.toJson(),
  };
}

class Student {
  int id;
  String name;
  String phone;

  Student({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
  };
}

class Teacher {
  int id;
  String name;
  int subjectId;
  int price;
  List<String> images;
  DateTime createdAt;
  DateTime updatedAt;
  Subject subject;

  Teacher({
    required this.id,
    required this.name,
    required this.subjectId,
    required this.price,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
    required this.subject,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
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
  int id;
  String name;
  int classId;
  Class subjectClass;

  Subject({
    required this.id,
    required this.name,
    required this.classId,
    required this.subjectClass,
  });

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
    id: json["id"],
    name: json["name"],
    classId: json["classId"],
    subjectClass: Class.fromJson(json["class"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "classId": classId,
    "class": subjectClass.toJson(),
  };
}

class Class {
  int id;
  String name;

  Class({
    required this.id,
    required this.name,
  });

  factory Class.fromJson(Map<String, dynamic> json) => Class(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
