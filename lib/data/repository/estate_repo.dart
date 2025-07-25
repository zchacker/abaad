import 'package:abaad/data/api/api_client.dart';
import 'package:abaad/data/model/body/estate_body.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class EstateRepo {
  final ApiClient apiClient;
  EstateRepo({ required this.apiClient});

  Future<Response>  getEstateList(int offset, String filterBy,int userId,categoryId) async {
    return await apiClient.getData('${AppConstants.CATEGORY_ESTATEURI}/all?category_id=$categoryId&offset=$offset&user_id=$userId', query: {}, headers: {});
  }


  Future<Response> getLatestEstateList(String type) async {
    return await apiClient.getData('${AppConstants.CATEGORY_ESTATEURI}?type=$type', query: {}, headers: {});
  }


  Future<Response> getCategorisEstateList( int offset, int categoryID, String type) async {
    return await apiClient.getData(
      '${AppConstants.CATEGORY_ESTATEURI}/all?category_id=$categoryID&offset=$offset&limit=10&type=$type', query: {}, headers: {},
    );
  }


  Future<Response> getEstateDetails(String estateID) async {
    return await apiClient.getData('${AppConstants.ESTATE_DETAILS_URI}$estateID', query: {}, headers: {});
  }


  Future<Response> createEstate(EstateBody estate,List<MultipartBody> multiParts) async {
    Map<String, String> body = {};
    body.addAll(<String, String>{
      'address': estate.address ?? "",
      'property': estate.property ?? "",
      'space': estate.space ?? "",
      'category_id': estate.categoryId ?? "",
      'price': estate.price ?? "",
      'long_description':estate.longDescription ?? "",
      'national_address':estate.nationalAddress ?? "",
      "zone_id":estate.zoneId ?? "",
      "districts":estate.districts ?? "",
      "network_type":estate.networkType ?? "",
      "latitude":estate.latitude ?? "",
      "longitude":estate.longitude ?? "",
      "short_description":estate.shortDescription ?? "",
      "ownership_type":estate.ownershipType ?? "",
      "user_id":estate.user_id ?? "",
      'price_negotiation':estate.priceNegotiation ?? "",
      "facilities":estate.facilities ?? "",
      "city":estate.city ?? "",
      "other_advantages":estate.otherAdvantages ?? "",
      "interface":estate.interface ?? "",
      "street_space":estate.streetSpace ?? "",
      "build_space":estate.buildSpace ?? "",
      "document_number":estate.documentNumber ?? "",
      "ad_number":estate.adNumber ?? "",
      "feature":estate.feature ?? "",
      "ar_path":estate.arPath ?? "",
      "age_estate":estate.ageEstate ?? "",
      "estate_type":estate.estate_type ?? "",
      "authorization_number":estate.authorization_number ?? "",

      "license_number": estate.licenseNumber ?? "",
      "advertiser_number": estate.advertiserNumber ?? "",
      "id_type": estate.idType ?? "",



    });
    return apiClient.postMultipartData(AppConstants.CREATE_ESATE_URI, body,multiParts, headers: {});
    // return apiClient.postMultipartData(AppConstants.CREATE_ESATE_URI, _body,multiParts);
  }




  Future<Response> updateEstate(EstateBody estate) async {
    Map<String, String> body = {};
    body.addAll(<String, String>{
      'id': estate.id ?? "",
      'address': estate.address ?? "",
      'property': estate.property ?? "",
      'space': estate.space ?? "",
      'category_id': estate.categoryId ?? "",
      'price': estate.price ?? "",
      'long_description':estate.longDescription ?? "",
      'national_address':estate.nationalAddress ?? "",
      "zone_id":estate.zoneId ?? "",
      "districts":estate.districts ?? "",
      "network_type":estate.networkType ?? "",
      "latitude":estate.latitude ?? "",
      "longitude":estate.longitude ?? "",
      "short_description":estate.shortDescription ?? "",
      "ownership_type":estate.ownershipType ?? "",
      "user_id":estate.user_id ?? "",
      'price_negotiation':estate.priceNegotiation ?? "",
      "facilities":estate.facilities ?? "",
      "city":estate.city ?? "",
      "other_advantages":estate.otherAdvantages ?? "",
      "interface":estate.interface ?? "",
      "street_space":estate.streetSpace ?? "",
      "build_space":estate.buildSpace ?? "",
      "document_number":estate.documentNumber ?? "",
      "ad_number":estate.adNumber ?? "",
      "ar_path":estate.arPath ?? "",
      "age_estate":estate.ageEstate ?? "",
      "estate_type":estate.estate_type ?? "",
      "authorization_number":estate.authorization_number  ?? ""



    });

    return apiClient.postData(AppConstants.UPDATE_ESATE_URI, body, headers: {});
  }



  Future<Response> addEstate(EstateBody estate,List<MultipartBody> multiParts) async {
    Map<String, String> body = {};
    body.addAll(<String, String>{
      'id':estate.id ?? "",
      'address': estate.address ?? "",
      'property': estate.property ?? "",
      'space': estate.space ?? "",
      'category_id': estate.categoryId ?? "",
      'price': estate.price ?? "" ,
      'long_description':estate.longDescription ?? "" ,
      'national_address':estate.nationalAddress ?? "" ,
      "zone_id":estate.zoneId ?? "" ,
      "districts":estate.districts ?? "" ,
      "network_type":estate.networkType ?? "" ,
      "latitude":estate.latitude ?? "" ,
      "longitude":estate.longitude ?? "" ,
      "short_description":estate.shortDescription ?? "" ,
      "ownership_type":estate.ownershipType ?? "" ,
      "user_id":estate.user_id ?? "" ,
      'price_negotiation':estate.priceNegotiation ?? "" ,
      "facilities":estate.facilities ?? "" ,
      "city":estate.city ?? "" ,
      "other_advantages":estate.otherAdvantages ?? "" ,
      "interface":estate.interface ?? "" ,
      "street_space":estate.streetSpace ?? "" ,
      "build_space":estate.buildSpace ?? "" ,
      "document_number":estate.documentNumber ?? "" ,
      "ad_number":estate.adNumber ?? "" ,
      "ar_path":estate.arPath ?? "" ,
      "age_estate":estate.ageEstate ?? "" ,
      "estate_type":estate.estate_type ?? "" ,
      "authorization_number":estate.authorization_number  ?? ""
,

       // ✅ الحقول الجديدة
      "property_face": estate.propertyFace ?? "" ,
      "deed_number": estate.deedNumber ?? "" ,
      "category_name": estate.categoryName ?? "" ,
      "total_price": estate.totalPrice ?? "" ,
      "advertisement_type": estate.advertisementType ?? "" ,
      "postal_code": estate.postalCode ?? "" ,
      "plan_number": estate.planNumber ?? "" ,
      "north_limit": estate.northLimit ?? "" ,
      "east_limit": estate.eastLimit ?? "" ,
      "west_limit": estate.westLimit ?? "" ,
      "south_limit": estate.southLimit ?? "" ,


      "license_number": estate.licenseNumber ?? "" ,
      "advertiser_number": estate.advertiserNumber ?? "" ,
      "idType": estate.idType ?? "" ,

    });

    return await apiClient.postData(AppConstants.CREATE_ESATE_URI, body, headers: {});
   // return apiClient.postMultipartData(AppConstants.CREATE_ESATE_URI, _body,multiParts);

  }



  Future<Response> Report( estate) async {
    Map<String, String> body = {};
    body.addAll(<String, String>{
      'id':estate.id,
      'address': estate.address,
      'property': estate.property,
      'space': estate.space,
      'category_id': estate.categoryId,
      'price': estate.price,
      'long_description':estate.longDescription,
      'national_address':estate.nationalAddress,
      "zone_id":estate.zoneId,
      "districts":estate.districts,
      "network_type":estate.networkType,
      "latitude":estate.latitude,
      "longitude":estate.longitude,
      "short_description":estate.shortDescription,
      "ownership_type":estate.ownershipType,
      "user_id":estate.user_id,
      'price_negotiation':estate.priceNegotiation,
      "facilities":estate.facilities,
      "city":estate.city,
      "other_advantages":estate.otherAdvantages,
      "interface":estate.interface,
      "street_space":estate.streetSpace,
      "build_space":estate.buildSpace,
      "document_number":estate.documentNumber,
      "ad_number":estate.adNumber



    });

    return apiClient.postData(AppConstants.UPDATE_ESATE_URI, body, headers: {});
  }

  Future<Response> getZoneList() async {
    return await apiClient.getData(AppConstants.ZONE_ALL, query: {}, headers: {});
  }




  Future<Response> deleteEstate(int id) async {
    return await apiClient.deleteData('${AppConstants.DELETE_ESTATE_URI}?id=$id', headers: {});
  }
  Future<Response> getCategoryList() async {
    return await apiClient.getData(AppConstants.CATEGORIES, query: {}, headers: {});
  }




  Future<Response> verifyLicense(String licenseNumber,String advertiserId,int entityType) async {
    return await apiClient.postData(AppConstants.verifyLicense,
      {
        'adLicenseNumber': licenseNumber,
        'advertiserId': advertiserId,
        'entityType': entityType

      }, headers: {}, // البيانات المرسلة
    );
  }





  Future<Response> addWishList(int id, bool isRestaurant) async {
    return await apiClient.postData('${AppConstants.ADD_WISH_LIST_URI}estate_id=$id', null, headers: {});
  }




}