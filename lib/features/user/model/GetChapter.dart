import 'dart:convert';

List<GetChapter> getChapterFromJson(String str) => List<GetChapter>.from(json.decode(str).map((x) => GetChapter.fromJson(x)));

String getChapterToJson(List<GetChapter> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetChapter {
  int id;
  String videoUrl;
  String attachment;
  String summary;
  int lectureId;
  DateTime createdAt;
  DateTime updatedAt;

  GetChapter({
    required this.id,
    required this.videoUrl,
    required this.attachment,
    required this.summary,
    required this.lectureId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GetChapter.fromJson(Map<String, dynamic> json) => GetChapter(
    id: json["id"],
    videoUrl: json["videoUrl"]??'',
    attachment: json["attachment"]??'',
    summary: json["summary"]??'',
    lectureId: json["lectureId"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "videoUrl": videoUrl,
    "attachment": attachment,
    "summary": summary,
    "lectureId": lectureId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
