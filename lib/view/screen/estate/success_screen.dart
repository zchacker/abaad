import 'dart:async';
import 'dart:io';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

class SuccessScreen extends StatefulWidget {
  final int  estate_id;
  const SuccessScreen({super.key, required this.estate_id});

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {

  double screenWidth = 600;
  double screenHeight = 400;
  Color textColor = const Color(0xFF32567A);

  late bool v;
  late bool s;

  @override
  void initState() {
    super.initState();

    v=true;
    s=true;


    //print("---------------------------------------${widget.estate_id}");


  }

  late VideoPlayerController _videoController;
  late FilePickerResult _filePickerResult;
  double _uploadProgress = 0.0;
  bool _uploading = false;


  late VideoPlayerController _videoSkeyController;
  late FilePickerResult _fileSkyPickerResult;
  double _uploadSkyProgress = 0.0;
  bool _uploadingSky = false;

  @override
  void dispose() {
    _videoController.dispose();
    _videoSkeyController.dispose();
    super.dispose();
  }

  Future<void> pickAndPreviewVideo() async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video);

    setState(() {
      _filePickerResult = result!;
      _videoController = VideoPlayerController.file(File(result.files.single.path!))
        ..initialize().then((_) {
          setState(() {});
        });
    });
    }


  Future<void> pickSkyAndPreviewVideo() async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video);

    setState(() {
      _fileSkyPickerResult = result!;
      _videoSkeyController = VideoPlayerController.file(File(result.files.single.path!))
        ..initialize().then((_) {
          setState(() {});
        });
    });
    }
  Future<void> uploadVideo() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String?  indexValue = prefs.getString('estate_id');
    String? filePath = _filePickerResult.files.single.path;
    var request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}/api/v1/estate/upload-video'));
    request.fields['id'] = indexValue!;
    request.files.add(await http.MultipartFile.fromPath('video', filePath!));

    setState(() {
      _uploading = true;
      _uploadProgress = 0.0;
    });
    var response = await request.send();
    response.stream.listen((event) {
      setState(() {
        _uploadProgress = response.contentLength != null
            ? event.length / (response.contentLength ?? 40)
            : 0;
      });
    }).onDone(() {
      setState(() {
        _uploadProgress = 1.0;
        _uploading = false;
      });
    });

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously

      Future.delayed(Duration(seconds: 2), () {

        Get.snackbar(
          'Thanks'.tr,
          'operation_accomplished_successfully'.tr,
          backgroundColor: Colors.green, // Customize snackbar color
          colorText: Colors.white, // Customize text color
          duration: Duration(seconds: 3), // Set duration in seconds
          snackPosition: SnackPosition.BOTTOM, // Set snackbar position
          margin: EdgeInsets.all(10), // Set margin around the snackbar
          isDismissible: true, // Allow dismissing the snackbar with a tap// Dismiss direction
        );


        // Get.offAllNamed(RouteHelper.getInitialRoute());
        // Get.offNamed(RouteHelper.getInitialRoute());
      });

      setState(() {
        v=false;
      });
    } else {
      Get.snackbar(
        'Thanks'.tr,
        'the_operation_failed_try_again'.tr,
        backgroundColor: Colors.red, // Customize snackbar color
        colorText: Colors.white, // Customize text color
        duration: Duration(seconds: 3), // Set duration in seconds
        snackPosition: SnackPosition.BOTTOM, // Set snackbar position
        margin: EdgeInsets.all(10), // Set margin around the snackbar
        isDismissible: true, // Allow dismissing the snackbar with a tap// Dismiss direction
      );
    }
    }


  Future<void> uploadSkyVideo() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String?  indexValue = prefs.getString('estate_id');
    String? filePath = _fileSkyPickerResult.files.single.path;
    var request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}/api/v1/estate/upload-sky-view'));
    request.fields['id'] = indexValue!;
    request.files.add(await http.MultipartFile.fromPath('video', filePath!));

    setState(() {
      _uploadingSky = true;
      _uploadSkyProgress = 0.0;
    });
    var response = await request.send();
    response.stream.listen((event) {
      setState(() {
        _uploadSkyProgress = response.contentLength != null
            ? event.length / (response.contentLength ?? 40)
            : 0;
      });
    }).onDone(() {
      setState(() {
        _uploadSkyProgress = 1.0;
        _uploadingSky = false;
      });
    });

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Future.delayed(Duration(seconds: 2), () {

        Get.snackbar(
          'Thanks'.tr,
          'operation_accomplished_successfully'.tr,
          backgroundColor: Colors.green, // Customize snackbar color
          colorText: Colors.white, // Customize text color
          duration: Duration(seconds: 3), // Set duration in seconds
          snackPosition: SnackPosition.BOTTOM, // Set snackbar position
          margin: EdgeInsets.all(10), // Set margin around the snackbar
          isDismissible: true, // Allow dismissing the snackbar with a tap// Dismiss direction
        );

        s=false;


        // Get.offAllNamed(RouteHelper.getInitialRoute());
        // Get.offNamed(RouteHelper.getInitialRoute());
      });

      setState(() {
        s=false;
      });
    } else {
      Get.snackbar(
        'Thanks'.tr,
        'the_operation_failed_try_again'.tr,
        backgroundColor: Colors.red, // Customize snackbar color
        colorText: Colors.white, // Customize text color
        duration: Duration(seconds: 3), // Set duration in seconds
        snackPosition: SnackPosition.BOTTOM, // Set snackbar position
        margin: EdgeInsets.all(10), // Set margin around the snackbar
        isDismissible: true, // Allow dismissing the snackbar with a tap// Dismiss direction
      );

    }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'complete_the_process'.tr, onBackPressed: () => Get.back()),
      body: Scaffold(
    body: Center(
    child: Column(


      children: <Widget>[

        ElevatedButton(
          onPressed: (){
            Get.offAllNamed(RouteHelper.getInitialRoute());
          }, //label text
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor //elevated btton background color
          ), //icon data for elevated button
          child: Text("done".tr),
        ),
        Container(
          height: 70,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            Images.success,
            fit: BoxFit.contain,
            color: Theme.of(context).primaryColor,

          ),
        ),

        Text(
          "thanks".tr,
          style:  robotoBold.copyWith(
            fontSize: 14,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Text(
          "added_successfully".tr,
          style: robotoBold.copyWith(
              fontSize: 15,
              color: Theme.of(context).primaryColor),
        ),

        SizedBox(height: screenHeight * 0.01),
        Text(
          "attach_video".tr,
          textAlign: TextAlign.center,
          style: robotoBold.copyWith(
              fontSize: 12,
              color: Theme.of(context).primaryColor),
        ),
        SizedBox(height: 4,),
       v? Column(
          children: [

            GestureDetector(
              onTap: (){
                pickAndPreviewVideo();
              },
              child: _videoController.value.isInitialized? Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1.0
                  ),
                  borderRadius: BorderRadius.all(
                      Radius.circular(5.0) //                 <--- border radius here
                  ),
                ),
                  child: AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  ),
                ):
      Container(
      height: 140,
      width: 140,
      decoration: BoxDecoration(
        border: Border.all(
              width: 1.0
        ),
        borderRadius: BorderRadius.all(
              Radius.circular(5.0) //                 <--- border radius here
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          Images.video_place,
          fit: BoxFit.contain,


        ),
      ),
    ),
            ),
            // ElevatedButton(
            //   onPressed: pickAndPreviewVideo,
            //   child: Text('Pick and Preview Video'),
            // ),

            ElevatedButton.icon(
                onPressed: _uploading ? null : uploadVideo,
              icon: Icon(Icons.upload_file),  //icon data for elevated button
              label: Text("download_video".tr), //label text
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor //elevated btton background color
              ),
            ),
            // ElevatedButton(
            //   onPressed: (){
            //     Get.offAllNamed(RouteHelper.getInitialRoute());
            //   }, //icon data for elevated button
            //   child: Text("i_don_t_want_upload".tr), //label text
            //   style: ElevatedButton.styleFrom(
            //       primary:Theme.of(context).primaryColor //elevated btton background color
            //   ),
            // ),
            if (_uploading)
              Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text('loading_video'.tr),
                ],
              ),
            if (_uploadProgress > 0 && _uploadProgress < 1)
              LinearProgressIndicator(value: _uploadProgress),
          ],
        ):Container(),





        SizedBox(height: 4,),
      s?  Column(
          children: [


            Text("video_drone".tr),
            GestureDetector(
              onTap: (){
                pickSkyAndPreviewVideo();
              },
              child: _videoSkeyController.value.isInitialized? Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1.0
                  ),
                  borderRadius: BorderRadius.all(
                      Radius.circular(5.0) //                 <--- border radius here
                  ),
                ),
                child: AspectRatio(
                  aspectRatio: _videoSkeyController.value.aspectRatio,
                  child: VideoPlayer(_videoSkeyController),
                ),
              ):
              Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1.0
                  ),
                  borderRadius: BorderRadius.all(
                      Radius.circular(5.0) //                 <--- border radius here
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    Images.video_place,
                    fit: BoxFit.contain,


                  ),
                ),
              ),
            ),
            // ElevatedButton(
            //   onPressed: pickAndPreviewVideo,
            //   child: Text('Pick and Preview Video'),
            // ),

            ElevatedButton.icon(
              onPressed: _uploadingSky ? null : uploadSkyVideo,
              icon: Icon(Icons.upload_file),  //icon data for elevated button
              label: Text("download_video".tr), //label text
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor //elevated btton background color
              ),
            ),

            if (_uploadingSky)
              Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 4),
                  Text('loading_video'.tr),
                ],
              ),
            if (_uploadSkyProgress > 0 && _uploadSkyProgress < 1)
              LinearProgressIndicator(value: _uploadSkyProgress),
          ],
        ):Container(),


      ],
    ),
    ),
    ),
    );
  }


}
