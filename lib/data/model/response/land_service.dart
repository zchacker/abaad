class LandModel {
  bool exceededTransferLimit;
  List<Features> features;
  List<Fields> fields;
  String geometryType;
  SpatialReference spatialReference;
  String objectIdFieldName;
  bool hasZ;
  bool hasM;

  LandModel (
      {this.exceededTransferLimit,
        this.features,
        this.fields,
        this.geometryType,
        this.spatialReference,
        this.objectIdFieldName,
        this.hasZ,
        this.hasM});

  LandModel .fromJson(Map<String, dynamic> json) {
    exceededTransferLimit = json['exceededTransferLimit'];
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features.add(Features.fromJson(v));
      });
    }
    if (json['fields'] != null) {
      fields = <Fields>[];
      json['fields'].forEach((v) {
        fields.add(Fields.fromJson(v));
      });
    }
    geometryType = json['geometryType'];
    spatialReference = json['spatialReference'] != null
        ? SpatialReference.fromJson(json['spatialReference'])
        : null;
    objectIdFieldName = json['objectIdFieldName'];
    hasZ = json['hasZ'];
    hasM = json['hasM'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['exceededTransferLimit'] = exceededTransferLimit;
    data['features'] = features.map((v) => v.toJson()).toList();
      data['fields'] = fields.map((v) => v.toJson()).toList();
      data['geometryType'] = geometryType;
    data['spatialReference'] = spatialReference.toJson();
      data['objectIdFieldName'] = objectIdFieldName;
    data['hasZ'] = hasZ;
    data['hasM'] = hasM;
    return data;
  }
}

class Features {
  Attributes attributes;
  Geometry geometry;

  Features({this.attributes, this.geometry});

  Features.fromJson(Map<String, dynamic> json) {
    attributes = json['attributes'] != null
        ? Attributes.fromJson(json['attributes'])
        : null;
    geometry = json['geometry'] != null
        ? Geometry.fromJson(json['geometry'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attributes'] = attributes.toJson();
      data['geometry'] = geometry.toJson();
      return data;
  }
}

class Attributes {
  String systemId;

  Attributes({this.systemId});

  Attributes.fromJson(Map<String, dynamic> json) {
    systemId = json['system_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['system_id'] = systemId;
    return data;
  }
}

class Geometry {
  double x;
  double y;

  Geometry({this.x, this.y});

  Geometry.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['x'] = x;
    data['y'] = y;
    return data;
  }
}

class Fields {
  String name;
  String type;
  String alias;
  int length;
  Null defaultValue;
  String modelName;
  bool visible;

  Fields(
      {this.name,
        this.type,
        this.alias,
        this.length,
        this.defaultValue,
        this.modelName,
        this.visible});

  Fields.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    alias = json['alias'];
    length = json['length'];
    defaultValue = json['defaultValue'];
    modelName = json['modelName'];
    visible = json['visible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = type;
    data['alias'] = alias;
    data['length'] = length;
    data['defaultValue'] = defaultValue;
    data['modelName'] = modelName;
    data['visible'] = visible;
    return data;
  }
}

class SpatialReference {
  int wkid;
  int latestWkid;

  SpatialReference({this.wkid, this.latestWkid});

  SpatialReference.fromJson(Map<String, dynamic> json) {
    wkid = json['wkid'];
    latestWkid = json['latestWkid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wkid'] = wkid;
    data['latestWkid'] = latestWkid;
    return data;
  }
}