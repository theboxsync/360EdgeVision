// To parse this JSON data, do
//
//     final galleryModel = galleryModelFromJson(jsonString);

import 'dart:convert';

GalleryModel galleryModelFromJson(String str) => GalleryModel.fromJson(json.decode(str));

String galleryModelToJson(GalleryModel data) => json.encode(data.toJson());

class GalleryModel {
  bool? success;
  List<Datum>? data;

  GalleryModel({this.success, this.data});

  factory GalleryModel.fromJson(Map<String, dynamic> json) =>
      GalleryModel(success: json["success"], data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))));

  Map<String, dynamic> toJson() => {"success": success, "data": List<dynamic>.from(data!.map((x) => x.toJson()))};
}

class Datum {
  String? userId;
  String? imageName;
  String? path;

  Datum({this.userId, this.imageName, this.path});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(userId: json["user_id"], imageName: json["image_name"], path: json["path"]);

  Map<String, dynamic> toJson() => {"user_id": userId, "image_name": imageName, "path": path};
}
