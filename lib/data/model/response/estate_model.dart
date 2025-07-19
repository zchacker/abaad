class EstateModel {
  int? totalSize = 0;
  String? limit = "";
  int? offset = 0;
  List<Estate>? estates;

  EstateModel({  this.totalSize,   this.limit,   this.offset,   this.estates});

  EstateModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'].toString();
    offset = ((json['offset'] != null && json['offset'].toString().trim().isNotEmpty) ? int.parse(json['offset'].toString()) : null)!;
    if (json['estate'] != null) {
      estates = [];
      json['estate'].forEach((v) {
        estates?.add(Estate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    data['estate'] = estates?.map((v) => v.toJson()).toList();
      return data;
  }
}

class Estate {
  int? id = 0;
  String? address = "";
  String? title  = "";
  List<Property>?  property;
  String? space = "";
  int? categoryId = 0;
  String?   price = "";
  String? ownershipType = "";

  int? view = 0;
  String? status = "";
  String? districts = "";
  List<NetworkType>?  networkType;
  int? height = 0;
  int? width = 0;
  List<ServiceOffers>? serviceOffers;
  String? qr = "";
  List<String>? images;
  List<String>? planned;
  String? arPath = "";
  String? latitude = "";
  String? longitude = "";
  int? zoneId = 0;
  String? type_add = "";
  int? territoryId = 0;
  String?  ageEstate = "";
  String? shortDescription = "";
  String? longDescription = "";
  int? floors = 0;
  String? near = "";
  String? priceNegotiation = "";

  String? createdAt = "";
  String? updatedAt = "";
  int? adNumber = 0;
  int? advertiserNo = 0;
  String? nationalAddress = "";
  int? userId = 0;
  int? estate_id = 0;
  String? city = "";
  String? category = "";
  List<OtherAdvantages>? otherAdvantages;
  List<Interface>? interface;
  String? streetSpace = "";
  String? buildSpace = "";
  String? documentNumber = "";
  String? videoUrl = "";
  Users? users;
  String? categoryName = "";
  String? zoneName = "";
  String? categoryNameAr = "";
  String? zoneNameAr = "";
  String? property_type = "";
  String? skyView = "";
  String? estate_type = "";
  String? authorization_number = "";


  String? creationDate = "";
  String? endDate = "";
  String? adLicenseNumber = "";
  String? deedNumber = "";
  String? brokerageAndMarketingLicenseNumber = "";
  String? titleDeedTypeName = "";
  String? northLimit = "";
  String? eastLimit = "";
  String? westLimit = "";
  String? southLimit = "";
  String? streetWidth = "";
  String? propertyFace = "";
  String? advertisementType = "";
  String? totalPrice = "";
  String? licenseNumber = "";
  String? planNumber = "";

  String? obligationsOnTheProperty = "";
  String? guaranteesAndTheirDuration = "";
  String? locationDescriptionOnMOJDeed = "";
  String? numberOfRooms = "";
  String? mainLandUseTypeName = "";
  List<String>? propertyUtilities;
  String? landNumber = "";

  Estate({
     this.id,
     this.address,
     this.property,
     this.space,
     this.categoryId,
     this.price,
     this.ownershipType,
     this.planned,
     this.view,
     this.status,
     this.districts,
     this.networkType,
     this.height,
     this.width,
     this.serviceOffers,
     this.qr,
     this.images,
     this.arPath,
     this.latitude,
     this.longitude,
     this.zoneId,
     this.type_add,
     this.territoryId,
     this.ageEstate,
     this.shortDescription,
     this.longDescription,
     this.floors,
     this.near,
     this.priceNegotiation,
     this.adNumber,
     this.advertiserNo,
     this.nationalAddress,
     this.userId,
     this.createdAt,
     this.updatedAt,
     this.estate_id,
     this.city,
     this.title,
     this.category,
     this.otherAdvantages,
     this.interface,
     this.streetSpace,
     this.buildSpace,
     this.documentNumber,
     this.videoUrl,
     this.users,
     this.categoryName,
     this.categoryNameAr,
     this.zoneName,
     this.zoneNameAr,
     this.property_type,
     this.skyView,
     this.estate_type,
     this.authorization_number,
     this.creationDate,
     this.endDate,
     this.adLicenseNumber,
     this.deedNumber,
     this.brokerageAndMarketingLicenseNumber,
     this.titleDeedTypeName,
     this.northLimit,
     this.eastLimit,
     this.westLimit,
     this.southLimit,
     this.streetWidth,
     this.propertyFace,
     this.advertisementType,
     this.licenseNumber,
     this.planNumber,
     this.obligationsOnTheProperty,
     this.guaranteesAndTheirDuration,
     this.locationDescriptionOnMOJDeed,
     this.numberOfRooms,
     this.mainLandUseTypeName,
     this.propertyUtilities,
    this.landNumber,
  });

  Estate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    if (json['property'] != null) {
      property = <Property>[];
      json['property'].forEach((v) {
        property?.add(Property.fromJson(v));
      });
    }
    space = json['space'];
    categoryId = json['category_id'];
    price = json['price'];
    ownershipType = json['ownership_type'];

    view = json['view'];
    status = json['status'];
    districts = json['districts'];
    height = json['height'];
    estate_id=json['estate_id'];
    width = json['width'];
    if (json['service_offers'] != null) {
      serviceOffers = <ServiceOffers>[];
      json['service_offers'].forEach((v) {
        serviceOffers?.add(ServiceOffers.fromJson(v));
      });
    }
    qr = json['qr'];
    images = json['images'] != null ? json['images'].cast<String>() : [];
    planned = json['planned'] != null ? json['planned'].cast<String>() : [];
    arPath = json['ar_path'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    zoneId = json['zone_id'];
    type_add = json['type_add'];
    territoryId = json['territory_id'];
    ageEstate = json['age_estate'];
    shortDescription = json['short_description'];
    longDescription=json['long_description'];
    floors = json['floors'];
    near = json['near'];
    priceNegotiation=json['price_negotiation'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    advertiserNo = json['advertiser_no'];
    adNumber = json['ad_number'];
    nationalAddress=json['national_address'];
    city=json["city"];
    title=json["title"];
    category=json["category"];
    authorization_number=json["authorization_number"];

    userId=json['user_id'];
    if (json['network_type'] != null) {
      networkType = <NetworkType>[];
      json['network_type'].forEach((v) {
        networkType?.add(NetworkType.fromJson(v));
      });

    }

    if (json['other_advantages'] != null) {
      otherAdvantages = <OtherAdvantages>[];
      json['other_advantages'].forEach((v) {
        otherAdvantages?.add(OtherAdvantages.fromJson(v));
      });
    }

    if (json['interface'] != null) {
      interface = <Interface>[];
      json['interface'].forEach((v) {
        interface?.add(Interface.fromJson(v));
      });
    }
    streetSpace=json["street_space"];
    buildSpace=json["build_space"];
    documentNumber=json["document_number"];
    videoUrl=json['video_url'];
    users = json['users'] != null ? Users.fromJson(json['users']) : null;


    zoneName=json["zone_name"];
    zoneNameAr=json["zone_name_ar"];
    categoryNameAr=json["category_name_ar"];
    categoryName=json['category_name'];
    property_type= json['property_type'];
    skyView=json["skyview"];
    estate_type=json["estate_type"];



    creationDate = json['creation_date'];
    endDate = json['end_date'];
    adLicenseNumber = json['ad_license_number'];
    deedNumber = json['deed_number'];
    brokerageAndMarketingLicenseNumber = json['brokerageAndMarketingLicenseNumber'];
    titleDeedTypeName = json['titleDeedTypeName'];
    northLimit = json['north_limit'];
    eastLimit = json['east_limit'];
    westLimit = json['west_limit'];
    southLimit = json['south_limit'];
    streetWidth = json['street_width'];
    propertyFace = json['property_face'];
    advertisementType = json['advertisement_type'];
    totalPrice = json['total_price'];
    licenseNumber = json['license_number'];
    planNumber = json['plan_number'];

    obligationsOnTheProperty = json['obligationsOnTheProperty'];
    guaranteesAndTheirDuration = json['guaranteesAndTheirDuration'];
    locationDescriptionOnMOJDeed = json['locationDescriptionOnMOJDeed'];
    numberOfRooms = json['numberOfRooms'];
    mainLandUseTypeName = json['mainLandUseTypeName'];
    propertyUtilities = json['propertyUtilities'] != null ? List<String>.from(json['propertyUtilities']) : [];
    landNumber = json['landNumber'];





  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['address'] = address;
    data['property'] = property?.map((v) => v.toJson()).toList();
      data['space'] = space;
    data['category_id'] = categoryId;
    data['price'] = price;
    data['price_negotiation'] = priceNegotiation;
    data['ownership_type'] = ownershipType;
    data['planned'] = planned;
    data['view'] = view;
    data['status'] = status;
    data['districts'] = districts;
    data["city"]=city;

    data['height'] = height;
    data['width'] = width;
    data['service_offers'] =
        serviceOffers?.map((v) => v.toJson()).toList();
      data['qr'] = qr;
    data['images'] = images;
    data['ar_path'] = arPath;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['zone_id'] = zoneId;
    data['type_add'] = type_add;
    data['territory_id'] = territoryId;
    data['age_estate'] = ageEstate;
    data['short_description'] = shortDescription;
    data['long_description'] = longDescription;
    data['floors'] = floors;
    data['near'] = near;
    data['created_at'] = createdAt;
    data['advertiser_no'] = advertiserNo;
    data['ad_number'] = adNumber;
    data['updated_at'] = updatedAt;
    data['national_address']=nationalAddress;
    data['user_id']=userId;
    data['estate_id']=estate_id;
    data['title']=title;
    data['category']=category;
    data["build_space"]=buildSpace;
    data["document_number"]=documentNumber;
    data["video_url"]=videoUrl;
    data["estate_type"]=estate_type;
    data["authorization_number"]=authorization_number;
    data['network_type'] = networkType?.map((v) => v.toJson()).toList();
    data['other_advantages'] = otherAdvantages?.map((v) => v.toJson()).toList();
    data['interface'] = interface?.map((v) => v.toJson()).toList();
    data["street_space"]=streetSpace;
    data['users'] = users?.toJson();
    data['category_name']=categoryName;
    data["zone_name"]=zoneName;
    data["category_name_ar"]=categoryNameAr;
    data["zone_name_ar"]=zoneNameAr;
    data['property_type']=property_type;
    data['skyview']=skyView;
    data['creation_date'] = creationDate;
    data['end_date'] = endDate;
    data['ad_license_number'] = adLicenseNumber;
    data['deed_number'] = deedNumber;
    data['brokerageAndMarketingLicenseNumber'] = brokerageAndMarketingLicenseNumber;
    data['titleDeedTypeName'] = titleDeedTypeName;
    data['north_limit'] = northLimit;
    data['east_limit'] = eastLimit;
    data['west_limit'] = westLimit;
    data['south_limit'] = southLimit;
    data['street_width'] = streetWidth;
    data['property_face'] = propertyFace;
    data['advertisement_type'] = advertisementType;
    data['total_price'] = totalPrice;
    data['license_number'] = licenseNumber;
    data['plan_number'] = planNumber;
    data['obligationsOnTheProperty'] = obligationsOnTheProperty;
    data['guaranteesAndTheirDuration'] = guaranteesAndTheirDuration;
    data['locationDescriptionOnMOJDeed'] = locationDescriptionOnMOJDeed;
    data['numberOfRooms'] = numberOfRooms;
    data['mainLandUseTypeName'] = mainLandUseTypeName;
    data['propertyUtilities'] = propertyUtilities;
    data['landNumber'] = landNumber;


    return data;
  }
}


class EstateImages {
  int? id = 0;
  String? image = "";
  String? estateId = "";
  Null createdAt;
  Null updatedAt;

  EstateImages({ this.id,  this.image,  this.estateId,  this.createdAt,  this.updatedAt});

  EstateImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    estateId = json['estate_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['estate_id'] = estateId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}


class ServiceOffers {
  String? id  = "";
  String? title = "";
  String? expiryDate = "";
  String? servicePrice = "";
  String? description = "";
  String? discount = "";
  String? sendedAt = "";
  String? serviceTypeId = "";
  String? offerType = "";
  String? createdAt = "";
  String? updatedAt = "";
  String? image = "";
  String? phoneProvider = "";
  String? category_id = "";
  String? offer_id = "";
  String? provider_name = "";

  ServiceOffers({
     this.id,
     this.title,
     this.expiryDate,
     this.servicePrice,
     this.description,
     this.discount,
     this.sendedAt,
     this.serviceTypeId,
     this.offerType,
     this.createdAt,
     this.updatedAt,
     this.image,
     this.phoneProvider,
     this.category_id,
     this.offer_id,
     this.provider_name});

  ServiceOffers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    expiryDate = json['expiry_date'];
    servicePrice = json['service_price'];
    description = json['description'];
    discount = json['discount'];
    sendedAt = json['sended_at'];
    serviceTypeId = json['service_type_id'];
    offerType = json['offer_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    phoneProvider  =json['phone_provider']  ;
    offer_id =json['offer_id']  ;
    category_id =json['category_id']  ;
    provider_name =json['provider_name']  ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['expiry_date'] = expiryDate;
    data['service_price'] = servicePrice;
    data['description'] = description;
    data['discount'] = discount;
    data['sended_at'] = sendedAt;
    data['service_type_id'] = serviceTypeId;
    data['offer_type'] = offerType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['phone_provider']=phoneProvider;
    data['image'] = image;
    data['offer_id']=offer_id;
    data['category_id'] = category_id;

    data['provider_name'] = provider_name;



    return data;
  }
}



class Property {
  String? id = "";
  String? name = "";
  String? number = "";
  String? category_id = "";

  Property({ this.id,  this.name,  this.number, this.category_id});

  Property.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    number = json['number'];
    category_id = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['number'] = number;
    data['category_id'] = category_id;
    return data;
  }
}

class NetworkType {
  String? name = "";
  String? image = "";

  NetworkType({ this.name,  this.image});

  NetworkType.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
    return data;
  }


}


class OtherAdvantages {

  String? name = "";



  OtherAdvantages({ this.name });

  OtherAdvantages.fromJson(Map<String, dynamic> json) {
    name = json['name'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }


}

class Interface {
  String? name = "";
  String? space = "";


  Interface({ this.name, this.space});

  Interface.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    space =json['space'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['space']=space;
    return data;
  }


}



class Users {
  int? id = 0;
  String? name = "";
  String? email = "";
  String? phone = "";
  String? image = "";
  String? membershipType = "";
  String? advertiserNo = "";
  String? identity = "";
  String? falLicenseNumber = "";

  Users({ this.id , this.name,  this.email,  this.phone,  this.image, this.membershipType, this.advertiserNo, this.identity, this.falLicenseNumber});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    membershipType = json['membership_type'];
    advertiserNo=json['advertiser_no'];
    identity=json['identity'];
    falLicenseNumber=json['fal_license_number'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['image'] = image;
    data['membership_type'] = membershipType;
    data['advertiser_no']=advertiserNo;
    data['identity']=identity;
    data['fal_license_number']=falLicenseNumber;
    return data;
  }
}