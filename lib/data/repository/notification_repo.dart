
import 'package:abaad/data/api/api_client.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  NotificationRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getNotificationList() async {
    return await apiClient.getData(AppConstants.NOTIFICATION_URI, query: {}, headers: {});
  }

  // void saveSeenNotificationCount(int count) {
  //   sharedPreferences.setInt(AppConstants.NOTIFICATION_COUNT, count);
  // }
  //
  // int getSeenNotificationCount() {
  //   return sharedPreferences.getInt(AppConstants.NOTIFICATION_COUNT);
  // }

}
