import 'package:google_maps_flutter/google_maps_flutter.dart';

class ZoneModel {
  int id;
  String name;
  Coordinates coordinates;
  String  status;
  String nameAr;
  String latitude;
  String longitude;
  String createdAt;
  int  territory_id;
  String     estate_count;
  String image;
  String updatedAt;


  ZoneModel({this.id, this.name,this.nameAr, this.coordinates, this.status, this.createdAt, this.updatedAt ,this.latitude,
    this.longitude,this.image});

  ZoneModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    coordinates = json['coordinates'] != null ? Coordinates.fromJson(json['coordinates']) : null;
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    territory_id = json['territory_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    estate_count = json['estate_count'];
    nameAr=json['name_ar'];
    image=json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    // if (this.coordinates != null) {
    //   data['coordinates'] = this.coordinates.toJson();
    // }
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['territory_id'] = territory_id;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['estate_count'] = estate_count;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}

class Coordinates {
  String type;
  List<LatLng> coordinates;

  Coordinates({this.type, this.coordinates});

  Coordinates.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['coordinates'] != null) {
      coordinates = <LatLng>[];
      json['coordinates'][0].forEach((v) {
        coordinates.add(LatLng(double.parse(v[0].toString()), double.parse(v[1].toString())));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates.map((v) => v.toJson()).toList();
      return data;
  }
}
