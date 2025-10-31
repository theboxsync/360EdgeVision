// To parse this JSON data, do
//
//     final planHotspotModel = planHotspotModelFromJson(jsonString);

import 'dart:convert';

List<PlanHotspotModel> planHotspotModelFromJson(String str) => List<PlanHotspotModel>.from(json.decode(str).map((x) => PlanHotspotModel.fromJson(x)));

String planHotspotModelToJson(List<PlanHotspotModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlanHotspotModel {
  int id;
  double x;
  double y;
  String linkedImageId;

  PlanHotspotModel({required this.id, required this.x, required this.y, required this.linkedImageId});

  factory PlanHotspotModel.fromJson(Map<String, dynamic> json) =>
      PlanHotspotModel(id: json["id"], x: json["x"]?.toDouble(), y: json["y"]?.toDouble(), linkedImageId: json["linked_image_id"]);

  Map<String, dynamic> toJson() => {"id": id, "x": x, "y": y, "linked_image_id": linkedImageId};
}
