// To parse this JSON data, do
//
//     final camp = campFromJson(jsonString);

import 'dart:convert';

Camp campFromJson(String str) => Camp.fromJson(json.decode(str));

String campToJson(Camp data) => json.encode(data.toJson());

class Camp {
  String id;
  String campName;
  String campDetail;
  String campPlace;
  String campTopic;
  int peopleCount;
  DateTime date;
  String time;
  //String? image;
  // DateTime createdAt;
  // DateTime updatedAt;

  Camp({
    required this.id,
    required this.campName,
    required this.campDetail,
    required this.campPlace,
    required this.campTopic,
    required this.peopleCount,
    required this.date,
    required this.time,
    //required this.image,
    // required this.createdAt,
    // required this.updatedAt,
  });

  factory Camp.fromJson(Map<String, dynamic> json) => Camp(
        id: json["_id"],
        campName: json["camp_name"],
        campDetail: json["camp_detail"],
        campPlace: json["camp_place"],
        campTopic: json["camp_topic"],
        peopleCount: json["people_count"],
        date: DateTime.parse(json["date"]),
        time: json["time"],
        //image: json["image"],
        // createdAt: DateTime.parse(json["createdAt"]),
        // updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "camp_name": campName,
        "camp_detail": campDetail,
        "camp_place": campPlace,
        "camp_topic": campTopic,
        "people_count": peopleCount,
        "date": date.toIso8601String(),
        "time": time,
        //"image": image,
        // "createdAt": createdAt.toIso8601String(),
        // "updatedAt": updatedAt.toIso8601String(),
      };
}
