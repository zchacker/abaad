import 'package:abaad/data/api/api_client.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class CategoryRepo {
  final ApiClient apiClient;
  CategoryRepo({required this.apiClient});

  Future<Response> getCategoryList() async {
    return await apiClient.getData(AppConstants.CATEGORIES, query: {}, headers: {});
  }

  Future<Response> getCategoryProductList(int zoneId,String categoryID,int userId,String city,String districts,String space,typeAdd, String offset,int arPath,int sv,String type) async {
    return await apiClient.getData(
      '${AppConstants.CATEGORY_ESTATEURI}/all?zone_id=$zoneId&category_id=$categoryID&user_id=$userId&city=$city&districts=$districts&space=$space&type_add=$typeAdd&offset=$offset&ar_path=$arPath&sv=$sv&type=$type', query: {}, headers: {},
    );
  }

  Future<Response> getCategoryRestaurantList(String categoryID, int offset, String type) async {
    return await apiClient.getData('${AppConstants.CATEGORY_ESTATEURI}limit=10&offset=$offset&type=$type', query: {}, headers: {});
  }


  Future<Response> getProperties(int categoryID) async {
    return await apiClient.getData('${AppConstants.PROPERTIES_URI}?category_id=$categoryID', query: {}, headers: {});
  }

  Future<Response> getFacilities() async {
    return await apiClient.getData(AppConstants.FACILITIES, query: {}, headers: {});
  }



  Future<Response> getAdvantages() async {
    return await apiClient.getData(AppConstants.ADVANTAGES, query: {}, headers: {});
  }

}