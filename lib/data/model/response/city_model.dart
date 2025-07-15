class CityModel {
  int cityId;
  int regionId;
  String nameAr;
  String nameEn;

  CityModel({this.cityId, this.regionId, this.nameAr, this.nameEn});

  CityModel.fromJson(Map<String, dynamic> json) {
    cityId = json['city_id'];
    regionId = json['region_id'];
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city_id'] = cityId;
    data['region_id'] = regionId;
    data['name_ar'] = nameAr;
    data['name_en'] = nameEn;
    return data;
  }
}