
import 'dart:convert';
import 'dart:typed_data';
import 'package:abaad/data/model/response/address_model.dart';
import 'package:abaad/data/model/response/error_response.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as Http;

class ApiClient extends GetxService {
  final String? appBaseUrl;
  final SharedPreferences? sharedPreferences;
  static final String? noInternetMessage = 'Connection to API server failed due to internet connection';
  final int timeoutInSeconds = 30;

  String? token;
  Map<String, String>? _mainHeaders;

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    token = sharedPreferences?.getString(AppConstants.TOKEN)!;
    debugPrint('Token: $token');

    try {
      AddressModel addressModel;
      addressModel = AddressModel.fromJson(jsonDecode(sharedPreferences!.getString(AppConstants.userAddress)!));
      print( addressModel.toJson());

      updateHeader(
          token!, addressModel.zoneIds!,
          sharedPreferences!.getString(AppConstants.languageCode)!, addressModel.latitude!,
          addressModel.longitude!
      );
    }catch(e) {}

  }


  void updateHeader(String token, List<int> zoneIDs, String languageCode, String latitude, String longitude) {
    _mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      AppConstants.zoneId: zoneIDs != null ? jsonEncode(zoneIDs) : '',
      AppConstants.localizationKey: languageCode ?? AppConstants.languages[0].languageCode,
      AppConstants.latitude: latitude != null ? jsonEncode(latitude) : '',
      AppConstants.longitude: longitude != null ? jsonEncode(longitude) : '',
      'Authorization': 'Bearer $token'
    };
  }

  Future<Response> getData(String uri, {required Map<String, dynamic> query, required Map<String, String> headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      Http.Response response = await Http.get(
        Uri.parse(appBaseUrl!+uri),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage!);
    }
  }

  Future<Response> postData(String uri, dynamic body, {required Map<String, String> headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      debugPrint('====> API Body: $body');
      Http.Response response = await Http.post(
        Uri.parse(appBaseUrl!+uri),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage!);
    }
  }

  Future<Response> postMultipartData(String uri, Map<String, String> body, List<MultipartBody> multipartBody, {required Map<String, String> headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      debugPrint('====> API Body: $body with ${multipartBody.length} files');
      Http.MultipartRequest request = Http.MultipartRequest('POST', Uri.parse(appBaseUrl!+uri));
      request.headers.addAll(headers ?? _mainHeaders!);
      for(MultipartBody multipart in multipartBody) {
        Uint8List list = await multipart.file.readAsBytes();
        request.files.add(Http.MultipartFile(
          multipart.key, multipart.file.readAsBytes().asStream(), list.length,
          filename: '${DateTime.now().toString()}.png',
        ));
            }
      request.fields.addAll(body);
      Http.Response response = await Http.Response.fromStream(await request.send());
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage!);
    }
  }

  Future<Response> putData(String uri, dynamic body, {required Map<String, String> headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      debugPrint('====> API Body: $body');
      Http.Response response = await Http.put(
        Uri.parse(appBaseUrl!+uri),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage!);
    }
  }

  Future<Response> deleteData(String uri, {required Map<String, String> headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      Http.Response response = await Http.delete(
        Uri.parse(appBaseUrl!+uri),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage!);
    }
  }

  Response handleResponse(Http.Response response, String uri) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    }catch(e) {}
    Response response0 = Response(
      body: body ?? response.body, bodyString: response.body.toString(),
      request: Request(headers: response.request!.headers, method: response.request!.method, url: response.request!.url),
      headers: response.headers, statusCode: response.statusCode, statusText: response.reasonPhrase!,
    );
    if(response0.statusCode != 200 && response0.body != null && response0.body is !String) {
      if(response0.body.toString().startsWith('{errors: [{code:')) {
        ErrorResponse errorResponse = ErrorResponse.fromJson(response0.body);
        response0 = Response(statusCode: response0.statusCode, body: response0.body, statusText: errorResponse.errors![0].message);
      }else if(response0.body.toString().startsWith('{message')) {
        response0 = Response(statusCode: response0.statusCode, body: response0.body, statusText: response0.body['message']);
      }
    }else if(response0.statusCode != 200 && response0.body == null) {
      response0 = Response(statusCode: 0, statusText: noInternetMessage!);
    }
    debugPrint('====> API Response: [${response0.statusCode}] $uri\n${response0.body}');
    return response0;
  }
}

class MultipartBody {
  String key;
  XFile file;

  MultipartBody(this.key, this.file);
}
