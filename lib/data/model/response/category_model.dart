class CategoryModel {
  int id;
  String name;
  String nameAr;
  String slug;
  String   position;
  String statusHome;
  String image;
  String createdAt;
  String updatedAt;

  CategoryModel(
      {this.id,
        this.name,
        this.nameAr,
        this.slug,
        this.position,
        this.statusHome,
        this.image,
        this.createdAt,
        this.updatedAt});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameAr=json['name_ar'];
    slug = json['slug'];
    position = json['position'];
    statusHome = json['status_home'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['name_ar'] = nameAr;
    data['slug'] = slug;
    data['position'] = position;
    data['status_home'] = statusHome;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
class Variation {
  String name;
  String type;
  String min;
  String max;
  String required;
  List<VariationOption> variationValues;

  Variation({this.name, this.type, this.min, this.max, this.required, this.variationValues});

  Variation.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    min = json['min'].toString();
    max = json['max'].toString();
    required = json['required'];
    if (json['values'] != null) {
      variationValues = [];
      json['values'].forEach((v) {
        variationValues.add(VariationOption.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = type;
    data['min'] = min;
    data['max'] = max;
    data['required'] = required;
    data['values'] = variationValues.map((v) => v.toJson()).toList();
      return data;
  }
}

class VariationOption {
  String level;
  String optionPrice;

  VariationOption({this.level, this.optionPrice});

  VariationOption.fromJson(Map<String, dynamic> json) {
    level = json['label'];
    optionPrice = json['optionPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = level;
    data['optionPrice'] = optionPrice;
    return data;
  }
}