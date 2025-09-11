class HotspotPosition {
  final int id;
  final double x; // percentage
  final double y; // percentage
  final int linkedImageId;

  HotspotPosition({required this.id, required this.x, required this.y, required this.linkedImageId});

  factory HotspotPosition.fromJson(Map<String, dynamic> json) {
    return HotspotPosition(
      id: json['id'],
      x: json['x'] * 0.01, // convert percentage to 0-1 scale
      y: json['y'] * 0.01,
      linkedImageId: json['linked_image_id'],
    );
  }
}
