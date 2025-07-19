import 'package:abaad/data/api/api_client.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class ZoneRepo {
  final ApiClient apiClient;
  ZoneRepo({required this.apiClient});

  Future<Response> getZoneList() async {
    return await apiClient.getData(AppConstants.ZONE_ALL, query: {}, headers: {});
  }

  Future<Response> getLandService() async {
    return await apiClient.getData(AppConstants.LAND_SERVICE_URL, query: {}, headers: {});
  }


  Future<Response> getRegionList() async {
    return await apiClient.getData(AppConstants.REGIONS, query: {}, headers: {});
  }

  Future<Response> getDistrictList(int parentID) async {
    return await apiClient.getData('${AppConstants.DISTRICT_BY_CITY}$parentID', query: {}, headers: {});
  }

  Future<Response> getCitiesList(int parentID) async {
    return await apiClient.getData('${AppConstants.CITIES_BY_REGIONS}$parentID', query: {}, headers: {});
  }


}