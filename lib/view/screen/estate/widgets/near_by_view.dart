import 'dart:convert';

import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:typed_data';

import 'package:abaad/data/repository/nearbyplacesmodel.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

class NearByView extends StatefulWidget {
  Estate esate;
   NearByView({super.key, required this.esate});

  @override
  State<NearByView> createState() => _NearByViewState();
}

class _NearByViewState extends State<NearByView> {
  final CustomInfoWindowController _customInfoWindowController =
  CustomInfoWindowController();
  final Completer<GoogleMapController> _controller = Completer();
  final List<Marker> _marker = [];
  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse(nextPageToken: '', results: [], status: '');
  double currentLat = 0.0;
  double currentLng = 0.0;
  String type = 'restaurant';
  String? type_value;

  Uint8List? imageDataBytes;
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor hospitalIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor restlIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor mosqueIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor schoolIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor pharmacylIcon = BitmapDescriptor.defaultMarker;
  var markerIcon;
  GlobalKey iconKey = GlobalKey();
  List<RadioModel> sampleData = <RadioModel>[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentLat=double.parse(widget.esate.latitude ?? "" );
    currentLng=double.parse(widget?.esate?.longitude ?? "");
    navigateToCurrentPosition();
    setCustomMarkerIcon();
    setHospitalMarkerIcon();
    setRestMarkerIcon();
    setMosqueMarkerIcon();
    setSchoolMarkerIcon();
    setParmceyIcon();

    _marker.add(
        Marker(markerId: MarkerId('id-0'),
            icon:sourceIcon,
            position: LatLng(
              // double.parse(Get.find<LocationController>().getUserAddress().latitude),
              // double.parse(Get.find<LocationController>().getUserAddress().longitude),
              double.parse(widget.esate.latitude ?? ""),
              double.parse(widget.esate.longitude ?? ""),
            ))
    );
    sampleData.add( RadioModel(false, 'restaurant'.tr, Images.restaurant));
    sampleData.add( RadioModel(false, 'mosque'.tr, Images.mosque));
    sampleData.add( RadioModel(false, 'hospital'.tr,Images.hosptial));
    sampleData.add( RadioModel(false, 'schools'.tr,Images.hosptial));
    sampleData.add( RadioModel(false, 'pharmacies'.tr,Images.heart));
    // getNearbyPlaces();
    // loadData();
  }

  loadData() {
    for (int i = 0; i < nearbyPlacesResponse.results.length; i++) {
      addMarkers(nearbyPlacesResponse.results[i], i);
    }
    }

  void addMarkers(Results results, int i) {
    _marker.add(Marker(
      markerId: MarkerId(i.toString()),
      onTap: (){

      },
      infoWindow: InfoWindow( //popup info
    title: results.name,
    ) ,
      icon: type=="restaurant"?restlIcon:type=="mosque"?mosqueIcon:type=="hospital"?hospitalIcon:type=="school"?schoolIcon:type=="pharmacy"?pharmacylIcon: sourceIcon ,

        position: LatLng(
          results.geometry!.location!.lat, results.geometry!.location!.lng),
    ));

    _marker.add(
        Marker(markerId: MarkerId('id-0'),
            icon: sourceIcon,
            position: LatLng(
              // double.parse(Get.find<LocationController>().getUserAddress().latitude),
              // double.parse(Get.find<LocationController>().getUserAddress().longitude),
               double.parse(widget.esate.latitude ?? ""),
               double.parse(widget.esate.longitude ?? ""),
            ))
    );

    setState(() {});
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      debugPrint('error in getting current location');
      //debugPrint(error.toString());
    });

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void navigateToCurrentPosition() {

      debugPrint('My current location');
      //debugPrint(widget.esate.latitude! + (widget.esate.longitude ?? ""));


      _marker.add(Marker(
          markerId: MarkerId("yeiuwe87"),
          position: LatLng(double.parse((widget.esate.latitude ?? "")), double.parse((widget.esate.longitude ?? ""))),
          icon:  BitmapDescriptor.defaultMarker,

          infoWindow: InfoWindow(
            title: 'My current location',
          )));



      setState(() {
        currentLat =double.parse( (widget.esate.latitude ?? "") );
        currentLng = double.parse( (widget.esate.longitude ?? "") );
        getNearbyPlaces(type);
      });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(title: 'neighboring_facilities'.tr),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:  CameraPosition(zoom: 14.4, target: LatLng(
              // double.parse(Get.find<LocationController>().getUserAddress().latitude),
              // double.parse(Get.find<LocationController>().getUserAddress().longitude),
                double.parse( (widget.esate.latitude ?? "") ),
                double.parse( (widget.esate.longitude ?? "") )
            )),
            myLocationEnabled: true,

            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: Set<Marker>.of(_marker),
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 0,
            width: 0,
            offset: 0,
          ),

          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60,
                color: Colors.white,
                child: ListView.builder(
                  itemCount: sampleData.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return   InkWell(
                      //highlightColor: Colors.red,
                      splashColor: Colors.blueAccent,
                      onTap: () async{

                          for (var element in sampleData) {
                            element.isSelected = false;
                          }
                          sampleData[index].isSelected = true;




                          if (sampleData[index].buttonText=='restaurant'.tr) {
                            type = 'restaurant';
                            getNearbyPlaces(type);

                          } else if (sampleData[index].buttonText=='hospital'.tr) {

                            type = 'hospital';
                            getNearbyPlaces(type);
                          } else if (sampleData[index].buttonText=='mosque'.tr) {
                            type = 'mosque';
                            getNearbyPlaces(type);
                          }else if (sampleData[index].buttonText=='schools'.tr) {
                            type = 'school';
                            getNearbyPlaces(type);
                          }else if (sampleData[index].buttonText=='pharmacies'.tr) {
                            type = 'pharmacy';
                            getNearbyPlaces(type);
                          }


                      },
                      child: RadioItem(sampleData[index]),
                    );
                  },
                ),
              ),
            ),
          ),


        ],

      ),

    );
  }
  Future<void> getCustomMarkerIcon(GlobalKey iconKey) async {
    RenderRepaintBoundary? boundary = iconKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    ui.Image image = await boundary!.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    var pngBytes = byteData!.buffer.asUint8List();
    setState(() {
      markerIcon = BitmapDescriptor.fromBytes(pngBytes);
    });
  }

  void getNearbyPlaces(String type) async {
    _marker.clear();
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${widget.esate.latitude},${widget.esate.longitude}&radius=1500&type=$type&key=${AppConstants.googleMapKey}');

    var response = await http.post(url);

    //print("printing latlng");
    //print(jsonDecode(response.body));
    nearbyPlacesResponse =
        NearbyPlacesResponse.fromJson(jsonDecode(response.body));
    //print("printing latlng");
    //print(jsonDecode(response.body));

    loadData();
    setState(() {});
  }


  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, Images.near)
        .then(
          (icon) {
        sourceIcon = icon;
      },
    );
  }

  void setHospitalMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, Images.mark_hosiptal)
        .then(
          (icon) {
        hospitalIcon = icon;
      },
    );
  }


  void setRestMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, Images.mark_restaurant)
        .then(
          (icon) {
        restlIcon = icon;
      },
    );
  }
  void setMosqueMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, Images.mark_mosque)
        .then(
          (icon) {
            mosqueIcon = icon;
      },
    );
  }


  void setSchoolMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, Images.mark_school)
        .then(
          (icon) {
        schoolIcon = icon;
      },
    );
  }


  void setParmceyIcon() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, Images.mark_pharmcy)
        .then(
          (icon) {
        pharmacylIcon = icon;
      },
    );
  }


}


class RadioModel {
  bool isSelected;
  final String buttonText;
  final String text;

  RadioModel(this.isSelected, this.buttonText, this.text);
}


class RadioItem extends StatelessWidget {
  final RadioModel _item;
  const RadioItem(this._item, {super.key});
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 34,
      decoration:  BoxDecoration(
        color: _item.isSelected
            ?  Theme.of(context).primaryColor
            : Colors.transparent,
        border:  Border.all(
            width: 2.0,
            color: _item.isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey),
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
      margin:  EdgeInsets.only(bottom: 7,top: 7,right: 4,left: 4),
      child:  Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            height: 30.0,
            width: 50.0,

            child:  Center(
              child:  Image.asset(_item.text,height: 24,width: 24,color: _item.isSelected
                  ? Theme.of(context).colorScheme.surface
                  : Colors.grey)),
            ),
          Container(
            margin:  EdgeInsets.all( 7.0),
            child:  Text(_item.buttonText,style: robotoBlack.copyWith(fontSize: 11, color: _item.isSelected
                ? Theme.of(context).colorScheme.surface
                : Colors.grey)),
          )
        ],
      ),
    );
  }
}