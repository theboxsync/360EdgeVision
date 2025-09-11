// To parse this JSON data, do
//
//     final planModel = planModelFromJson(jsonString);

import 'dart:convert';

PlanModel planModelFromJson(String str) => PlanModel.fromJson(json.decode(str));

String planModelToJson(PlanModel data) => json.encode(data.toJson());

class PlanModel {
  List<Plan>? plan;

  PlanModel({this.plan});

  factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(plan: List<Plan>.from(json["plan"].map((x) => Plan.fromJson(x))));

  Map<String, dynamic> toJson() => {"plan": List<dynamic>.from(plan!.map((x) => x.toJson()))};
}

class Plan {
  int? collectionId;
  String? image;
  String? name;
  int? userId;
  String? projectName;
  String? imagePath;

  Plan({this.collectionId, this.image, this.name, this.userId, this.projectName, this.imagePath});

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
    collectionId: json["collection_id"],
    image: json["image"],
    name: json["name"],
    userId: json["user_id"],
    projectName: json["project_name"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "collection_id": collectionId,
    "image": image,
    "name": name,
    "user_id": userId,
    "project_name": projectName,
    "image_path": imagePath,
  };
}
