import 'dart:convert';

ActiveOrderSubscriptionsModel activeOrderSubscriptionsModelFromJson(String str) => ActiveOrderSubscriptionsModel.fromJson(json.decode(str));

String activeOrderSubscriptionsModelToJson(ActiveOrderSubscriptionsModel data) => json.encode(data.toJson());

class ActiveOrderSubscriptionsModel {
  Pagination pagination;
  List<Subscription> subscriptions;

  ActiveOrderSubscriptionsModel({
    required this.pagination,
    required this.subscriptions,
  });

  factory ActiveOrderSubscriptionsModel.fromJson(Map<String, dynamic> json) => ActiveOrderSubscriptionsModel(
    pagination: Pagination.fromJson({
      "total": json["total"],
      "totalPages": json["totalPages"],
      "page": json["page"],
    }),
    subscriptions: List<Subscription>.from(json["subscriptions"].map((x) => Subscription.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": pagination.total,
    "totalPages": pagination.totalPages,
    "page": pagination.page,
    "subscriptions": List<dynamic>.from(subscriptions.map((x) => x.toJson())),
  };
}


class Pagination {
  int total;
  int totalPages;
  int page;

  Pagination({
    required this.total,
    required this.totalPages,
    required this.page,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    total: json["total"],
    totalPages: json["totalPages"],
    page: json["page"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "totalPages": totalPages,
    "page": page,
  };
}

class Subscription {
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

  Subscription({
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

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
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
