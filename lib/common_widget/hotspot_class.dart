class HotspotPosition {
  final String? id;
  final double? x; // percentage (0–100)
  final double? y; // percentage (0–100)
  final String? linkedImageId;

  HotspotPosition({this.id, this.x, this.y, this.linkedImageId});

  factory HotspotPosition.fromJson(Map<String, dynamic> json) {
    return HotspotPosition(
      id: json['id'].toString(),
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      linkedImageId: json['linked_image_id'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'x': x, 'y': y, 'linked_image_id': linkedImageId};
  }
}
