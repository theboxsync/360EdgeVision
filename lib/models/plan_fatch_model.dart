// To parse this JSON data, do
//
//     final planFetchModel = planFetchModelFromJson(jsonString);

import 'dart:convert';

PlanFetchModel planFetchModelFromJson(String str) => PlanFetchModel.fromJson(json.decode(str));

String planFetchModelToJson(PlanFetchModel data) => json.encode(data.toJson());

class PlanFetchModel {
  bool? success;
  String? image;
  String? planId;

  PlanFetchModel({this.success, this.image, this.planId});

  factory PlanFetchModel.fromJson(Map<String, dynamic> json) =>
      PlanFetchModel(success: json["success"], image: json["image"], planId: json["plan_id"]);

  Map<String, dynamic> toJson() => {"success": success, "image": image, "plan_id": planId};
}
