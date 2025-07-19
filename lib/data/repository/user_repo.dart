import 'package:abaad/data/api/api_client.dart';
import 'package:abaad/data/model/response/userinfo_model.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';

class UserRepo {
  final ApiClient apiClient;
  UserRepo({required this.apiClient});

  Future<Response> getUserInfo() async {
    return await apiClient.getData(AppConstants.CUSTOMER_INFO_URI, query: {}, headers: {});
  }


  Future<Response> getUserInfoById(int userId) async {
    return await apiClient.getData( '${AppConstants.AGENT_INFO}?user_id=$userId', query: {}, headers: {});

  }


  Future<Response> updateProfile(UserInfoModel userInfoModel, XFile data, String token) async {
    Map<String, String> body = {};
    body.addAll(<String, String>{
      'name': userInfoModel.name ?? "", 'email': userInfoModel.email ?? "",'youtube':userInfoModel.youtube!,'snapchat':userInfoModel.snapchat ?? "",'instagram':userInfoModel.instagram ?? "",'website':userInfoModel.website ?? "",'tiktok':userInfoModel.tiktok ?? "",'twitter':userInfoModel.twitter ?? ""
    });
    return await apiClient.postMultipartData(AppConstants.UPDATE_PROFILE_URI, body, [MultipartBody('image', data)], headers: {});
  }

  Future<Response>  getEstateList(int offset, String filterBy,int userId) async {
    return await apiClient.getData('${AppConstants.CATEGORY_ESTATEURI}/all?offset=$offset&user_id=$userId', query: {}, headers: {});
  }







  Future<Response> validateNafath(String idNumber) async {
    return await apiClient.postData(AppConstants.nafath, {"id_number": idNumber}, headers: {});
  }




  Future<Response> checkRequestStatus(String nationalId,String transId,String random ) async {
    return await apiClient.postData(AppConstants.check_request_status,
        {'nationalId': nationalId,
      'transId': transId,
      'random': random,}, headers: {});
  }

}