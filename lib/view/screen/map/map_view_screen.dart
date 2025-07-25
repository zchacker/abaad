import 'dart:async';
import 'dart:collection';

import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/category_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/data/model/response/zone_model.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:abaad/util/images.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MapViewScreen extends StatefulWidget {
  const MapViewScreen({ Key? key}) : super(key: key);
  static Future<void> loadData(bool reload) async {
    int offset = 1;
    Get.find<AuthController>().getZoneList();
  //  Get.find<SplashController>().setNearestEstateIndex(-1, notify: false);
  }

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  GoogleMapController? _controller;

  List<MarkerData>  _customMarkersZone = [];
  int _reload = 0;
  final Set<Polygon> _polygon = HashSet<Polygon>();


  @override
  void initState() {
    super.initState();

    MapViewScreen.loadData(false);
  }




  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }


  get borderRadius => BorderRadius.circular(8.0);
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    var height = MediaQuery
        .of(context)
        .size
        .height;
    final currentLocale = Get.locale;
    bool isArabic = currentLocale?.languageCode == 'ar';
    return Scaffold(
      //appBar:  WebMenuBar(ontop:()=>   _key.currentState.openDrawer(),),

      body: GetBuilder<AuthController>(builder: (authController) {

        // List<int> _zoneIndexList = [];
        // if (authController.zoneList != null) {
        //   //  //print("zone_list${authController.zoneModel.name}");
        //   for (int index = 0; index < authController.zoneList.length; index++) {
        //     _zoneIndexList.add(index);
        //   }
        // }
        return authController.zoneList != null ? CustomGoogleMapMarkerBuilder(
          customMarkers: _customMarkersZone,
          builder: (context, markers) {
            if (markers == null) {
              return Stack(children: [

                GoogleMap(
                  initialCameraPosition: const CameraPosition(
                      zoom: 12, target: LatLng(
                      24.263867,
                      45.033284
                    // double.parse(Get.find<LocationController>().getUserAddress().latitude),
                    // double.parse(Get.find<LocationController>().getUserAddress().longitude),
                  )),
                  myLocationEnabled: false,
                  compassEnabled: false,
                  zoomControlsEnabled: true,



                  onTap: (position) => Get.find<SplashController>().setNearestEstateIndex(-1),
                  minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                  onMapCreated: (GoogleMapController controller) {
                    _setMarkersZone(authController.zoneList!);

                  },
                ),


              ]);
            }
            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: const CameraPosition(
                      zoom: 5.2, target: LatLng(
                    // double.parse(Get.find<LocationController>().getUserAddress().latitude),
                    // double.parse(Get.find<LocationController>().getUserAddress().longitude),
                      24.263867,
                      45.033284
                  )),
                  markers: markers,
                  myLocationEnabled: false,
                  compassEnabled: false,
                  zoomControlsEnabled: false,
                  onTap: (position) {},
                  minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                  polygons: _polygon,
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                    if (authController.zoneList != null) {
                      // //print("zonelist${authController.zoneList.length}");

                      _setMarkersZone(authController.zoneList!);

                      // _setPolygo(authController.zoneList);
                      //  _setMarkers(authController.estateModel.estates);
                    }
                  },
                ),

              ],
            );
          },
        ) : const Center(child: CircularProgressIndicator());
      })
      ,


    );
  }


  void _setMarkersZone(List<ZoneModel> zone) async {
    final currentLocale = Get.locale;
    bool isArabic = currentLocale?.languageCode == 'ar';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<LatLng> latLngs = [];
    _customMarkersZone = [];
    await prefs.setInt("visible", 0);

    _customMarkersZone.add(MarkerData(
      marker: const Marker(markerId: MarkerId('id-0'), position: LatLng(
        // double.parse(Get.find<LocationController>().getUserAddress().latitude),
        // double.parse(Get.find<LocationController>().getUserAddress().longitude),
          24.263867,
          45.033284
      )),
      child: Image.asset(Images.mail, height: 20, width: 20),
    ));
    int index0 = 0;
    for (int index = 0; index < zone.length; index++) {
      index0++;
      LatLng latLng = LatLng(double.parse(zone[index].latitude),
          double.parse(zone[index].longitude));
      latLngs.add(latLng);
      // _polygon.add(
      //     Polygon(
      //       // given polygonId
      //       polygonId: PolygonId('id-$_index'),
      //       // initialize the list of points to display polygon
      //       points: zone[index].coordinates.coordinates,
      //       // given color to polygon
      //       fillColor: Colors.green.withOpacity(0.3),
      //       // given border color to polygon
      //       strokeColor: Colors.green,
      //       geodesic: true,
      //       // given width of border
      //       strokeWidth: 4,
      //     )
      // );
      _customMarkersZone.add(
          MarkerData(
        marker: Marker(markerId: MarkerId('id-$index0'),
            position: latLng,
            onTap: () async {
              await prefs.setInt("visible", 1);
              // _controller.animateCamera(
              //     CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
              //       double.parse(zone[index].latitude),
              //       double.parse(zone[index].longitude),
              //
              //     ), zoom: 11)));
              // Future.delayed(Duration(seconds: 1), () {
              // Get.offNamed(RouteHelper.getAccessLocationRoute('verification'));
              Get.find<CategoryController>().setFilterIndex(zone[index].id,0,"0","0",0,0,0,"");
              Get.toNamed(RouteHelper.getCategoryRoute(zone[index].id,zone[index].latitude,zone[index].longitude));
              // });

            }),
        child: SafeArea(


          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Stack(

              children: <Widget>[
                Container(
                  width: 54,
                  height: 18,

                  decoration: BoxDecoration(
                    borderRadius : BorderRadius.only(
                      topLeft: Radius.circular(7),
                      topRight: Radius.circular(4),
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(4),
                    ),
                    color : Color.fromRGBO(55, 133, 250, 1),
                    border : Border.all(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      width: 1.5,
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.only(right: 3,left: 3,bottom: 2),
                    child: Text(isArabic?zone[index].nameAr:zone[index].name, textAlign: TextAlign.left, style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontFamily: 'Cairo',
                        fontSize: 8,
                        letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1.5
                    ),),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(bottom: 3),
                  child: Row(


                    children: <Widget>[
                      Container(
                        height: 19,
                        width: 19,
                        decoration: BoxDecoration(
                          borderRadius : const BorderRadius.only(
                            topLeft: Radius.circular(8520),
                            topRight: Radius.circular(8520),
                            bottomLeft: Radius.circular(8520),
                            bottomRight: Radius.circular(8520),
                          ),
                          color : Color.fromRGBO(255, 255, 255, 1),
                          border : Border.all(
                            color: Color.fromRGBO(55, 133, 250, 1),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,

                            children: <Widget>[Text(zone[index].estate_count, textAlign: TextAlign.left, style: TextStyle(
                                color: Color.fromRGBO(55, 133, 250, 1),
                                fontFamily: 'Cairo',
                                fontSize: 10,
                                letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1.5
                            ),),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ));
    }
    // if(!ResponsiveHelper.isWeb() && _controller != null) {
    //   Get.find<LocationController>().zoomToFit(_controller, _latLngs, padding: 0);
    // }
    await Future.delayed(const Duration(milliseconds: 500));
    if (_reload == 0) {
      setState(() {});
      _reload = 1;
    }

    await Future.delayed(const Duration(seconds: 3));
    if (_reload == 1) {
      _reload = 2;
    }

  }

}



class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * .03, size.height);
    path.quadraticBezierTo(size.width * .2, size.height * .5, size.width * .03, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) => false;
}
