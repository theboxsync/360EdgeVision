class HotspotModel {
  String? hotspotId;
  double? pitch;
  double? yaw;
  String? linkedImageId;

  HotspotModel({this.hotspotId, this.pitch, this.yaw, this.linkedImageId});

  factory HotspotModel.fromJson(Map<String, dynamic> json) => HotspotModel(
    hotspotId: json["hotspot_id"].toString(),
    pitch: json["pitch"]?.toDouble(),
    yaw: json["yaw"]?.toDouble(),
    linkedImageId: json["linked_image_id"].toString(),
  );

  Map<String, dynamic> toJson() => {"hotspot_id": hotspotId, "pitch": pitch, "yaw": yaw, "linked_image_id": linkedImageId};
}
