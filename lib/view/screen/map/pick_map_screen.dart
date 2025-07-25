import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/location_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_button.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/base/web_menu_bar.dart';
import 'package:abaad/view/screen/map/widget/permission_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'widget/location_search_dialog.dart';

class PickMapScreen extends StatefulWidget {
  final bool fromSignUp;
  final bool fromAddAddress;
  final bool canRoute;
  final String route;
  final GoogleMapController? googleMapController;
  const PickMapScreen({super.key, 
    required this.fromSignUp,
    required this.fromAddAddress,
    required this.canRoute,
    required this.route,
    this.googleMapController,
  });

  @override
  State<PickMapScreen> createState() => _PickMapScreenState();
}

class _PickMapScreenState extends State<PickMapScreen> {
  late GoogleMapController _mapController;
  late CameraPosition _cameraPosition;
  late LatLng _initialPosition;

  @override
  void initState() {
    super.initState();

    if(widget.fromAddAddress) {
      Get.find<LocationController>().setPickData();
    }
    _initialPosition = LatLng(
      double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lat ?? '0'),
      double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lng ?? '0'),
    );
    Get.find<AuthController>().getZoneList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      body: SafeArea(child: Center(child: SizedBox(
        width: Dimensions.WEB_MAX_WIDTH,
        child: GetBuilder<AuthController>(builder: (authController) {


       return GetBuilder<LocationController>(builder: (locationController) {

         List<int> zoneIndexList = [];
         if(authController.zoneList != null) {
           for(int index=0; index<locationController.categoryList!.length; index++) {
             zoneIndexList.add(index);
           }
         }
          // //print('--------------${'${locationController.pickPlaceMark.name ?? ''} '
          //     '${locationController.address. ?? ''} '
          //     '${locationController.pickPlaceMark.postalCode ?? ''} ${locationController.pickPlaceMark.country ?? ''}'}');

          return Stack(children: [

            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.fromAddAddress ? LatLng(
                    double.parse(locationController.categoryList![locationController.categoryIndex-1] .latitude)??0,
                    double.parse( locationController.categoryList![locationController.categoryIndex-1].longitude)??0)
                    : _initialPosition,
                zoom: 16,
              ),
              minMaxZoomPreference: MinMaxZoomPreference(0, 40 ),
              onMapCreated: (GoogleMapController mapController) {
                _mapController = mapController;
                if(!widget.fromAddAddress) {
                  Get.find<LocationController>().getCurrentLocation(false, mapController: mapController, defaultLatLng: LatLng(0, 0));
                }
              },
              mapType: MapType.satellite,
              zoomControlsEnabled: false,
              onCameraMove: (CameraPosition cameraPosition) {
                _cameraPosition = cameraPosition;
              },
              onCameraMoveStarted: () {
                locationController.disableButton();
              },
              onCameraIdle: () {
                Get.find<LocationController>().updatePosition(_cameraPosition, false);
              },
            ),

            Center(child: !locationController.loading ? Image.asset(Images.pick_marker, height: 50, width: 50)
                : CircularProgressIndicator()),

            Positioned(
              top: Dimensions.PADDING_SIZE_LARGE, left: Dimensions.PADDING_SIZE_SMALL, right: Dimensions.PADDING_SIZE_SMALL,
              child: InkWell(
                onTap: () => Get.dialog(LocationSearchDialog(mapController: _mapController)),
                child: Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
                  child: Row(children: [
                    Icon(Icons.location_on, size: 25, color: Theme.of(context).primaryColor),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Expanded(
                      child: Text(
                        locationController.pickAddress,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge), maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                    Icon(Icons.search, size: 25, color: Theme.of(context).textTheme.bodyLarge!.color),
                  ]),
                ),
              ),
            ),

            Positioned(
              bottom: 80, right: Dimensions.PADDING_SIZE_SMALL,
              child: FloatingActionButton(
                mini: true, backgroundColor: Theme.of(context).cardColor,
                onPressed: () => _checkPermission(() {
                  Get.find<LocationController>().getCurrentLocation(false, mapController: _mapController, defaultLatLng: LatLng(0, 0));
                }),
                child: Icon(Icons.my_location, color: Theme.of(context).primaryColor),
              ),
            ),

            Positioned(
              bottom: Dimensions.PADDING_SIZE_LARGE, left: Dimensions.PADDING_SIZE_SMALL, right: Dimensions.PADDING_SIZE_SMALL,
              child: !locationController.isLoading ? CustomButton(
                buttonText: locationController.inZone ? widget.fromAddAddress ? 'حدد الموقع'.tr : 'pick_location'.tr
                    : 'هذ العقار مضاف مسبقا '.tr,
                onPressed: (locationController.buttonDisabled || locationController.loading) ? null : () {
                  if(locationController.pickPosition.latitude != 0 && locationController.pickAddress.isNotEmpty) {
                    if(widget.fromAddAddress) {
                      widget.googleMapController?.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
                        locationController.pickPosition.latitude, locationController.pickPosition.longitude,
                      ), zoom: 17)));
                      locationController.setAddAddressData();
                    
                      locationController. fetchLocationData(locationController.pickPosition.latitude,locationController.pickPosition.longitude);
     showCustomSnackBar("${                 locationController.district}");
           Get.back();
                    }else {
                      // AddressModel _address = AddressModel(
                      //   latitude: locationController.pickPosition.latitude.toString(),
                      //   longitude: locationController.pickPosition.longitude.toString(),
                      //   addressType: 'others', address: locationController.pickAddress,
                      // );
                      // locationController.saveAddressAndNavigate(_address, widget.fromSignUp, widget.route, widget.canRoute);
                    }
                  }else {
                    showCustomSnackBar('pick_an_address'.tr);
                  }
                },
              ) : Center(child: CircularProgressIndicator()),
            ),

          ]);
        });
        })
      ))),
    );
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.denied) {
      showCustomSnackBar('you_have_to_allow'.tr);
    }else if(permission == LocationPermission.deniedForever) {
      Get.dialog(PermissionDialog());
    }else {
      onTap();
    }
  }
}
