
import 'package:abaad/data/api/api_client.dart';
import 'package:abaad/helper/user_type.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  ChatRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getConversationList(int offset, String type) async {
    return apiClient.getData('${AppConstants.CONVERSATION_LIST_URI}?limit=10&offset=$offset&type=$type', query: {}, headers: {});
  }

  Future<Response> searchConversationList(String name) async {
    return apiClient.getData('${AppConstants.SEARCH_CONVERSATION_LIST_URI}?name=$name&limit=20&offset=1', query: {}, headers: {});
  }

  Future<Response> getMessages(int offset, int userID, UserType userType, int conversationID) async {
    return await apiClient.getData('${AppConstants.MESSAGE_LIST_URI}?${conversationID != null ? 'conversation_id' :userType == UserType.admin ? 'admin_id'
        : userType == UserType.vendor ? 'vendor_id' : 'delivery_man_id'}=${conversationID ?? userID}&offset=$offset&limit=10', query: {}, headers: {});
  }

  Future<Response> sendMessage(String message, List<MultipartBody> images, int userID, UserType userType, int conversationID,String  estateId) async {
    Map<String, String> fields = {};
    fields.addAll({'message': message, 'receiver_type': "vendor",'estate_id':estateId, 'offset': '1', 'limit': '10'});
    fields.addAll({'conversation_id': conversationID.toString()});
      return await apiClient.postMultipartData(AppConstants.SEND_MESSAGE_URI, fields, images, headers: {});
  }

}