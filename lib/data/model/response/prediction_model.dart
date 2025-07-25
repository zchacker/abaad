class PredictionModel {
  String description = "";
  String id = "";
  int distanceMeters = 0;
  String placeId = "";
  String reference = "";

  PredictionModel({
    required this.description,
    required this.id,
    required this.distanceMeters,
    required this.placeId,
    required this.reference
  });

  PredictionModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    id = json['id'];
    distanceMeters = json['distance_meters'];
    placeId = json['place_id'];
    reference = json['reference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['id'] = id;
    data['distance_meters'] = distanceMeters;
    data['place_id'] = placeId;
    data['reference'] = reference;
    return data;
  }
}