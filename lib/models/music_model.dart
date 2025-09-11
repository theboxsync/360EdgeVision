// To parse this JSON data, do
//
//     final musicModel = musicModelFromJson(jsonString);

import 'dart:convert';

MusicModel musicModelFromJson(String str) => MusicModel.fromJson(json.decode(str));

String musicModelToJson(MusicModel data) => json.encode(data.toJson());

class MusicModel {
  String? status;
  String? audioPath;

  MusicModel({this.status, this.audioPath});

  factory MusicModel.fromJson(Map<String, dynamic> json) => MusicModel(status: json["status"], audioPath: json["audioPath"]);

  Map<String, dynamic> toJson() => {"status": status, "audioPath": audioPath};
}
