// To parse this JSON data, do
//
//     final siteProjectModel = siteProjectModelFromJson(jsonString);

import 'dart:convert';

List<SiteProjectModel> siteProjectModelFromJson(String str) => List<SiteProjectModel>.from(json.decode(str).map((x) => SiteProjectModel.fromJson(x)));

String siteProjectModelToJson(List<SiteProjectModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SiteProjectModel {
  String? projectId;
  String? projectName;
  String? projectDescription;
  String? userId;
  String? imageFile;
  String? projectType;
  String? sequenceId;
  String? encryptedId;
  String? path;

  SiteProjectModel({
    this.projectId,
    this.projectName,
    this.projectDescription,
    this.userId,
    this.imageFile,
    this.projectType,
    this.sequenceId,
    this.encryptedId,
    this.path,
  });

  factory SiteProjectModel.fromJson(Map<String, dynamic> json) => SiteProjectModel(
    projectId: json["project_id"],
    projectName: json["project_name"],
    projectDescription: json["project_description"],
    userId: json["user_id"],
    imageFile: json["image_file"],
    projectType: json["project_type"],
    sequenceId: json["sequence_id"],
    encryptedId: json["encrypted_id"],
    path: json["path"],
  );

  Map<String, dynamic> toJson() => {
    "project_id": projectId,
    "project_name": projectName,
    "projectDescription": projectDescription,
    "user_id": userId,
    "image_file": imageFile,
    "project_type": projectType,
    "sequence_id": sequenceId,
    "encrypted_id": encryptedId,
    "path": path,
  };
}
