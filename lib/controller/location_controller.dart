import 'dart:convert';
import 'dart:math';

import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/data/api/api_checker.dart';
import 'package:abaad/data/model/response/address_model.dart';
import 'package:abaad/data/model/response/place_details_model.dart';
import 'package:abaad/data/model/response/prediction_model.dart';
import 'package:abaad/data/model/response/response_model.dart';
import 'package:abaad/data/model/response/zone_model.dart';
import 'package:abaad/data/model/response/zone_response_model.dart';
import 'package:abaad/data/repository/location_repo.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class LocationController extends GetxController implements GetxService {
  final LocationRepo locationRepo;
  LocationController({required this.locationRepo});

  Position _position = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, headingAccuracy: 0.0, altitudeAccuracy: 0.0);
  Position _pickPosition = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1,  headingAccuracy: 0.0, altitudeAccuracy: 0.0);
  bool _loading = false;
  String _address = '';
  String _pickAddress = '';
  final List<Marker> _markers = <Marker>[];
  List<AddressModel>? _addressList;
  List<AddressModel>? _allAddressList;
  int _addressTypeIndex = 0;
  final List<String> _addressTypeList = ['home', 'office', 'others'];
  bool _isLoading = false;
  bool _inZone = false;
  int _zoneID = 0;
  bool _buttonDisabled = true;
  bool _changeAddress = true;
  GoogleMapController? _mapController;
  List<PredictionModel> _predictionList = [];
  bool _updateAddAddressData = true;
  List<int> _zoneIds = [];
  List<int> _cityIds = [];
  List<ZoneModel>? _categoryList;
  int _categoryIndex = 0;

  RxString city = RxString("");
  RxString district = RxString("");


  List<PredictionModel> get predictionList => _predictionList;
  bool get isLoading => _isLoading;
  bool get loading => _loading;
  Position get position => _position;
  Position get pickPosition => _pickPosition;
  String get address => _address;
  String get pickAddress => _pickAddress;
  List<Marker> get markers => _markers;
  List<AddressModel>? get addressList => _addressList;
  List<String> get addressTypeList => _addressTypeList;
  int get addressTypeIndex => _addressTypeIndex;
  bool get inZone => _inZone;
  int get zoneID => _zoneID;
  bool get buttonDisabled => _buttonDisabled;
  GoogleMapController? get mapController => _mapController;
  List<int> get zoneIds => _zoneIds;
  List<int> get cityIds => _cityIds;
  List<ZoneModel>? get categoryList => _categoryList;
  int get categoryIndex => _categoryIndex;
  Future<AddressModel> getCurrentLocation(bool fromAddress, {required GoogleMapController mapController, required LatLng defaultLatLng, bool notify = true}) async {
    _loading = true;
    if(notify) {
      update();
    }
    AddressModel addressModel;
    Position myPosition;
    try {
      Position newLocalData = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      myPosition = newLocalData;
    }catch(e) {
      myPosition = Position(
        latitude: defaultLatLng != null ? defaultLatLng.latitude : double.parse(Get.find<SplashController>().configModel?.defaultLocation?.lat ?? '0'),
        longitude: defaultLatLng != null ? defaultLatLng.longitude : double.parse(Get.find<SplashController>().configModel?.defaultLocation?.lng ?? '0'),
        timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1,
          headingAccuracy: 0.0, altitudeAccuracy: 0.0
      );
    }
    if(fromAddress) {
      _position = myPosition;
    }else {
      _pickPosition = myPosition;
    }
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(myPosition.latitude, myPosition.longitude), zoom: 16),
    ));
      String addressFromGeocode = await getAddressFromGeocode(LatLng(myPosition.latitude, myPosition.longitude));
    fromAddress ? _address = addressFromGeocode : _pickAddress = addressFromGeocode;
    ZoneResponseModel responseModel = await getZone(myPosition.latitude.toString(), myPosition.longitude.toString(), true);
    _buttonDisabled = !responseModel.isSuccess;
    addressModel = AddressModel(
      latitude: myPosition.latitude.toString(), longitude: myPosition.longitude.toString(), addressType: 'others',
      zoneId: responseModel.isSuccess ? responseModel.zoneIds![0] : 0, zoneIds: responseModel.zoneIds,
      address: addressFromGeocode, zoneData: responseModel.zoneData, id: 0, contactPersonNumber: '', method: '', contactPersonName: '', road: '', house: '', floor: '',
    );
    _loading = false;
    update();
    return addressModel;
  }

  Future<ZoneResponseModel> getZone(String lat, String long, bool markerLoad, {bool updateInAddress = false}) async    {
    if(markerLoad) {
      _loading = true;
    }else {
      _isLoading = true;
    }
    //print('problem start');
    if(!updateInAddress){
      update();
    }
    ZoneResponseModel responseModel;
    Response response = await locationRepo.getZone(lat, long,pickAddress);
    if(response.statusCode == 200) {
      _inZone = true;
      _zoneID = int.parse(jsonDecode(response.body['zone_id'])[0].toString());
      List<int> zoneIds = [];
      jsonDecode(response.body['zone_id']).forEach((zoneId){
        zoneIds.add(int.parse(zoneId.toString()));
      });
      List<ZoneData> zoneData = [];
      //response.body['zone_data'].forEach((zoneData) => zoneData.add(ZoneData.fromJson(zoneData)));
      response.body['zone_data'].forEach((item) { zoneData.add(ZoneData.fromJson(item)); });
      responseModel = ZoneResponseModel(true, '' , zoneIds, zoneData);
      if(updateInAddress) {
        //print('here problem');
        AddressModel? address = getUserAddress();
        address?.zoneData = zoneData;
        saveUserAddress(address!);
      }
    }else {
      _inZone = false;
      responseModel = ZoneResponseModel(false, response.statusText, [], []);
    }
    if(markerLoad) {
      _loading = false;
    }else {
      _isLoading = false;
    }
    update();
    return responseModel;
  }

  void updatePosition(CameraPosition position, bool fromAddress) async {
    if(_updateAddAddressData) {
      _loading = true;
      update();
      try {
        if (fromAddress) {
          _position = Position(
            latitude: position.target.latitude, longitude: position.target.longitude, timestamp: DateTime.now(),
            heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1,
              headingAccuracy: 0.0, altitudeAccuracy: 0.0
          );
        } else {
          _pickPosition = Position(
            latitude: position.target.latitude, longitude: position.target.longitude, timestamp: DateTime.now(),
            heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1,
              headingAccuracy: 0.0, altitudeAccuracy: 0.0
          );
        }
        ZoneResponseModel responseModel = await getZone(position.target.latitude.toString(), position.target.longitude.toString(), true);
        _buttonDisabled = !responseModel.isSuccess;
        if (_changeAddress) {
          String addressFromGeocode = await getAddressFromGeocode(LatLng(position.target.latitude, position.target.longitude));
          fromAddress ? _address = addressFromGeocode : _pickAddress = addressFromGeocode;
        } else {
          _changeAddress = true;
        }
      } catch (e) {}
      _loading = false;
      update();
    }else {
      _updateAddAddressData = true;
    }
  }

  Future<ResponseModel> deleteUserAddressByID(int id, int index) async {
    Response response = await locationRepo.removeAddressByID(id);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      _addressList?.removeAt(index);
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    update();
    return responseModel;
  }

  Future<void> getAddressList() async {
    Response response = await locationRepo.getAllAddress();
    if (response.statusCode == 200) {
      _addressList = [];
      _allAddressList = [];
      response.body['addresses'].forEach((address) {
        _addressList?.add(AddressModel.fromJson(address));
        _allAddressList?.add(AddressModel.fromJson(address));
      });
    } else {
      ApiChecker.checkApi(response, showToaster: true);
    }
    update();
  }

  void filterAddresses(String queryText) {
    _addressList = [];
    if (queryText.isEmpty) {
      _addressList?.addAll(_allAddressList as Iterable<AddressModel>);
    } else {
      for (var address in _allAddressList!) {
        if (address.address!.toLowerCase().contains(queryText.toLowerCase())) {
          _addressList?.add(address);
        }
      }
    }
    update();
    }


  Future<ResponseModel> updateAddress(AddressModel addressModel, int addressId) async {
    _isLoading = true;
    update();
    Response response = await locationRepo.updateAddress(addressModel, addressId);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      getAddressList();
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<bool> saveUserAddress(AddressModel address) async {
    String userAddress = jsonEncode(address.toJson());
    return await locationRepo.saveUserAddress(userAddress, address.zoneIds!, address.latitude!, address.longitude!);
  }

  AddressModel? getUserAddress() {
    AddressModel? addressModel;
    try {
      addressModel = AddressModel.fromJson(jsonDecode(locationRepo.getUserAddress() ?? ""));
    }catch(e) {}
    return addressModel;
  }

  void setAddressTypeIndex(int index) {
    _addressTypeIndex = index;
    update();
  }

  Future<Position> setLocation(String placeID, String address, GoogleMapController mapController) async {
    _loading = true;
    update();

    LatLng latLng = LatLng(0, 0);
    Response response = await locationRepo.getPlaceDetails(placeID);
    if(response.statusCode == 200) {
      PlaceDetailsModel placeDetails = PlaceDetailsModel.fromJson(response.body);
      if(placeDetails.status == 'OK') {
        latLng = LatLng(placeDetails.result!.geometry!.location!.lat, placeDetails.result!.geometry!.location!.lng);
      }
    }

    _pickPosition = Position(
      latitude: latLng.latitude, longitude: latLng.longitude,
      timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1,
      headingAccuracy: 0.0, altitudeAccuracy: 0.0
    );

    _pickAddress = address;
    _changeAddress = false;

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: latLng, zoom: 16)));
      _loading = false;
    update();
    return _pickPosition;
  }

  void disableButton() {
    _buttonDisabled = true;
    _inZone = true;
    update();
  }

  void setAddAddressData() {
    _position = _pickPosition;
    _address = _pickAddress;
    _updateAddAddressData = false;
    update();
  }

  void setUpdateAddress(AddressModel address){
    _position = Position(
      latitude: double.parse(address.latitude!), longitude: double.parse(address.longitude!), timestamp: DateTime.now(),
      altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, floor: 1, accuracy: 1,
      headingAccuracy: 0.0, altitudeAccuracy: 0.0
    );
    _address = address.address!;
    _addressTypeIndex = _addressTypeList.indexOf(address.addressType!);
  }

  void setPickData() {
    _pickPosition = _position;
    _pickAddress = _address;
  }

  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;
  }

  Future<String> getAddressFromGeocode(LatLng latLng) async {
    Response response = await locationRepo.getAddressFromGeocode(latLng);
    String address = 'Unknown Location Found';
    if(response.statusCode == 200 && response.body['status'] == 'OK') {
      address = response.body['results'][0]['formatted_address'].toString();
    }else {
      showCustomSnackBar(response.body ['error_message'] ?? response.bodyString);
    }
    return address;
  }

  Future<List<PredictionModel>> searchLocation(BuildContext context, String text) async {
    if(text.isNotEmpty) {
      Response response = await locationRepo.searchLocation(text);
      if (response.statusCode == 200 && response.body['status'] == 'OK') {
        _predictionList = [];
        response.body['predictions'].forEach((prediction) => _predictionList.add(PredictionModel.fromJson(prediction)));
      } else {
        showCustomSnackBar(response.body['error_message'] ?? response.bodyString);
      }
    }
    return _predictionList;
  }

  void setPlaceMark(String address) {
    _address = address;
  }

  Future<void> zoomToFit(GoogleMapController controller, List<LatLng> list, {double padding = 0.5}) async {
    LatLngBounds bounds = _computeBounds(list);
    LatLng centerBounds = LatLng(
      (bounds.northeast.latitude + bounds.southwest.latitude)/2,
      (bounds.northeast.longitude + bounds.southwest.longitude)/2,
    );

    controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: centerBounds, zoom: GetPlatform.isWeb ? 10 : 16)));
  
    bool keepZoomingOut = true;

    int count = 0;
    while(keepZoomingOut) {
      count++;
      final LatLngBounds screenBounds = await controller.getVisibleRegion();
      if(_fits(bounds, screenBounds) || count == 200) {
        keepZoomingOut = false;
        final double zoomLevel = await controller.getZoomLevel() - padding;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
        break;
      }
      else {
        // Zooming out by 0.1 zoom level per iteration
        final double zoomLevel = await controller.getZoomLevel() - 0.1;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
      }
    }
  }
  void autoNavigate(AddressModel address, bool fromSignUp, String route, bool canRoute) async {
    if(!GetPlatform.isWeb) {
      if (Get.find<LocationController>().getUserAddress()?.zoneId != address.zoneId) {
        FirebaseMessaging.instance.unsubscribeFromTopic('zone_${Get.find<LocationController>().getUserAddress()?.zoneId}_customer');
        FirebaseMessaging.instance.subscribeToTopic('zone_${address.zoneId}_customer');
      } else {
        FirebaseMessaging.instance.subscribeToTopic('zone_${address.zoneId}_customer');
      }
    }
    await Get.find<LocationController>().saveUserAddress(address);
    if(Get.find<AuthController>().isLoggedIn()) {
      Get.find<AuthController>().updateZone();
    }
    // HomeScreen.loadData(true);
    if(fromSignUp) {

    }else {
      if(canRoute) {
        Get.offAllNamed(route);
      }else {
        Get.offAllNamed(RouteHelper.getInitialRoute());
      }
    }
  }
  bool _fits(LatLngBounds fitBounds, LatLngBounds screenBounds) {
    final bool northEastLatitudeCheck = screenBounds.northeast.latitude >= fitBounds.northeast.latitude;
    final bool northEastLongitudeCheck = screenBounds.northeast.longitude >= fitBounds.northeast.longitude;

    final bool southWestLatitudeCheck = screenBounds.southwest.latitude <= fitBounds.southwest.latitude;
    final bool southWestLongitudeCheck = screenBounds.southwest.longitude <= fitBounds.southwest.longitude;

    return northEastLatitudeCheck && northEastLongitudeCheck && southWestLatitudeCheck && southWestLongitudeCheck;
  }

  LatLngBounds _computeBounds(List<LatLng> list) {
    assert(list.isNotEmpty);
    var firstLatLng = list.first;
    var s = firstLatLng.latitude,
        n = firstLatLng.latitude,
        w = firstLatLng.longitude,
        e = firstLatLng.longitude;
    for (var i = 1; i < list.length; i++) {
      var latlng = list[i];
      s = min(s, latlng.latitude);
      n = max(n, latlng.latitude);
      w = min(w, latlng.longitude);
      e = max(e, latlng.longitude);
    }
    return LatLngBounds(southwest: LatLng(s, w), northeast: LatLng(n, e));
  }



  Future<void> getCategoryList() async {
    _zoneIds = [];
    _cityIds = [];
    _zoneIds.add(0);
    _cityIds.add(0);
    // getSubCategoryList(0);
    Response response = await locationRepo.getZoneList();
    if (response.statusCode == 200) {
      _categoryList = [];
      response.body.forEach((category) => _categoryList?.add(ZoneModel.fromJson(category)));
      for(int index=0; index<_categoryList!.length; index++) {
        _zoneIds.add(_categoryList![index].id);
      }
        } else {
      ApiChecker.checkApi(response, showToaster: true);
    }
    update();
  }
  void setCategoryIndex(int index, bool notify) {
    _categoryIndex = index;
    if(notify) {
      update();
    }
  }


  Future<void> fetchLocationData(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        city.value = placemark.locality ?? "";
        district.value = placemark.subLocality ?? "";
      } else {
        city.value = "City Not Found";
        district.value = "District Not Found";
      }
    } catch (e) {
      //print("Error fetching location data: $e");
      city.value = "Error";
      district.value = "Error";
    }
  }

}