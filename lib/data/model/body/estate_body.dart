class EstateBody {
  String? id ;
  String? address;
  String? property;
  String? space;
  String? categoryId;
  String? price;
  String? ownershipType;
  String? districts;
  String? networkType;
  String? serviceOffers;
  String? arPath;
  String? latitude;
  String? longitude;
  String? zoneId;
  String? territoryId;
  String? ageEstate;
  String? shortDescription;
  String? longDescription;
  String? floors;
  String? near;
  String? priceNegotiation;
  String? nationalAddress;
  String? facilities;
  String? user_id;
  String? adNumber;
  String? advertiserNo;
  String? city;
  String? otherAdvantages;
  String? interface;
  String? streetSpace;
  String? buildSpace;
  String? documentNumber;
  String? feature;
  String? property_type;
  String? estate_type;
  String?  authorization_number;
  String? propertyFace;
  String? deedNumber;
  String? categoryName;
  String? totalPrice;
  String? advertisementType;
  String? postalCode;
  String? planNumber;
  String? northLimit;
  String? eastLimit;
  String? westLimit;
  String? southLimit;

   String? licenseNumber;
   String? advertiserNumber;
   String? idType;



  EstateBody(
      {
        required this.id,
        required this.address,
        required this.property,
        required this.space,
        required this.categoryId,
        required this.price,
        required this.ownershipType,
        required this.districts,
        required this.networkType,
        required this.serviceOffers,
        required this.arPath,
        required this.latitude,
        required this.longitude,
        required this.zoneId,
        required this.territoryId,
        required this.ageEstate,
        required this.shortDescription,
        required this.longDescription,
        required this.floors,
        required this.near,
        required this.priceNegotiation,
        required this.nationalAddress,
        required this.facilities,
        required this.user_id,
        required this.adNumber,
        required this.advertiserNo,
        required this.city,
        required this.otherAdvantages,
        required this.interface,
        required this.streetSpace,
        required this.buildSpace,
        required this.documentNumber,
        required this.feature,
        required this.property_type,
        required this.estate_type,
        required this.authorization_number,

        required this.propertyFace,
        required this.deedNumber,
        required this.categoryName,
        required this.totalPrice,
        required this.advertisementType,
        required this.postalCode,
        required this.planNumber,
        required this.northLimit,
        required this.eastLimit,
        required this.westLimit,
        required this.southLimit,
        required this.licenseNumber,
        required this.advertiserNumber,
        required this.idType

      });

  EstateBody.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    address = json['address'];
    property = json['property'];

    space = json['space'];
    categoryId = json['category_id'];
    price = json['price'];
    ownershipType = json['ownership_type'];
    districts = json['districts'];
    networkType = json['network_type'];
    serviceOffers = json['service_offers'];


    arPath = json['ar_path'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    zoneId = json['zone_id'];
    territoryId = json['territory_id'];
    ageEstate = json['age_estate'];
    shortDescription = json['short_description'];
    longDescription=json['long_description'];
    floors = json['floors'];
    near = json['near'];
    priceNegotiation=json['price_negotiation'];
    nationalAddress=json['national_address'];
    user_id=json['user_id'];
    facilities=json['facilities'];
    advertiserNo = json['advertiser_no'];
    adNumber = json['ad_number'];
    city=json["city"];
    otherAdvantages=json["other_advantages"];
    streetSpace=json["street_space"];
    interface=json["interface"];
    buildSpace=json["build_space"];
    documentNumber=json["document_number"];
    feature= json['feature'];
    property_type= json['property_type'];
    estate_type=json['estate_type'];
    authorization_number=json["authorization_number"];


    propertyFace = json['property_face'];
    deedNumber = json['deed_number'];
    categoryName = json['category_name'];
    totalPrice = json['total_price'];
    advertisementType = json['advertisement_type'];
    postalCode = json['postal_code'];
    planNumber = json['plan_number'];
    northLimit = json['north_limit'];
    eastLimit = json['east_limit'];
    westLimit = json['west_limit'];
    southLimit = json['south_limit'];

    licenseNumber = json['license_number'];
    advertiserNumber = json['advertiser_number'];
    idType = json['idType'];




  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['address'] = address;

    data['property'] = property;
    data['space'] = space;
    data['category_id'] = categoryId;
    data['price'] = price;
    data['price_negotiation'] = priceNegotiation;
    data['ownership_type'] = ownershipType;
    data['districts'] = districts;
    data['network_type'] = networkType;
    data['service_offers'] = serviceOffers;

    data['ar_path'] = arPath;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['zone_id'] = zoneId;
    data['territory_id'] = territoryId;
    data['age_estate'] = ageEstate;
    data['short_description'] = shortDescription;
    data['floors'] = floors;
    data['near'] = near;
    data['long_description']=longDescription;
    data['national_address']=nationalAddress;
    data['facilities']=facilities;
    data['user_id']=user_id;
    data['advertiser_no'] = advertiserNo;
    data['ad_number'] = adNumber;
    data['city']=city;
    data["other_advantages"]=otherAdvantages;
    data["interface"]=interface;
    data["street_space"]=streetSpace;
    data["build_space"]=buildSpace;
    data["document_number"]=documentNumber;
    data['feature']=feature;
    data['property_type']=property_type;
    data['estate_type']=estate_type;
    data["authorization_number"]=authorization_number;

    data['property_face'] = propertyFace;
    data['deed_number'] = deedNumber;
    data['category_name'] = categoryName;
    data['total_price'] = totalPrice;
    data['advertisement_type'] = advertisementType;
    data['postal_code'] = postalCode;
    data['plan_number'] = planNumber;
    data['north_limit'] = northLimit;
    data['east_limit'] = eastLimit;
    data['west_limit'] = westLimit;
    data['south_limit'] = southLimit;



    data['license_number'] = licenseNumber;
    data['advertiser_number'] = advertiserNumber;
    data['idType'] = idType;

    return data;
  }
}
