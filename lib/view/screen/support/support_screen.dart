import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/view/base/custom_app_bar.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'widget/support_button.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'help_support'.tr),
      body: Scrollbar(child: SingleChildScrollView(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        physics: BouncingScrollPhysics(),
        child: Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Column(children: [
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

          // Image.asset(Images.support_image, height: 120),
          SizedBox(height: 60),

          Image.asset(Images.logo, width: 100),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          // Image.asset(Images.logo_name, width: 100),
          /*Text(AppConstants.APP_NAME, style: robotoBold.copyWith(
            fontSize: 20, color: Theme.of(context).primaryColor,
          )),*/
          SizedBox(height: 30),

          SupportButton(
            icon: Icons.location_on, title: 'address'.tr, color: Colors.blue,
            info: "الشرقية , الدمام.",
            onTap: () {},
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

          SupportButton(
            icon: Icons.call, title: 'call'.tr, color: Colors.red,
            info: Get.find<SplashController>().configModel?.phone ?? "",
            onTap: () async {
              if(await canLaunchUrlString('tel:${Get.find<SplashController>().configModel?.phone}')) {
                launchUrlString('tel:${Get.find<SplashController>().configModel?.phone}', mode: LaunchMode.externalApplication);
              }else {
                showCustomSnackBar('${'can_not_launch'.tr} ${Get.find<SplashController>().configModel?.phone}');
              }
            },
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

          SupportButton(
            icon: Icons.mail_outline, title: 'email_us'.tr, color: Colors.green,
            info: Get.find<SplashController>().configModel?.email ?? "",
            onTap: () {
              final Uri emailLaunchUri = Uri(
                scheme: 'mailto',
                path: Get.find<SplashController>().configModel?.email,
              );
              launchUrlString(emailLaunchUri.toString(), mode: LaunchMode.externalApplication);
            },
          ),

        ]))),
      )),
    );
  }
}
