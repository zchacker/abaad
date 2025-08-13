import 'package:abaad_flutter/controller/auth_controller.dart';
import 'package:abaad_flutter/controller/estate_controller.dart';
import 'package:abaad_flutter/controller/user_controller.dart';
import 'package:abaad_flutter/helper/route_helper.dart';
import 'package:abaad_flutter/util/dimensions.dart';
import 'package:abaad_flutter/util/styles.dart';
import 'package:abaad_flutter/view/base/custom_app_bar.dart';
import 'package:abaad_flutter/view/base/custom_button.dart';
import 'package:abaad_flutter/view/base/custom_snackbar.dart';
import 'package:abaad_flutter/view/base/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../base/not_logged_in_screen.dart';

class AdLicenseScreen extends StatefulWidget {
  const AdLicenseScreen({super.key});

  @override
  State<AdLicenseScreen> createState() => _AdLicenseScreenState();
}

class _AdLicenseScreenState extends State<AdLicenseScreen> {
  final TextEditingController _numberLicenseController =
      TextEditingController();
  final bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final TextEditingController _idNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'add_ads'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        child: Get.find<AuthController>().isLoggedIn() ? Center(
            child: SizedBox(
                width: Dimensions.WEB_MAX_WIDTH,
                child: GetBuilder<AuthController>(builder: (authController) {
                  return GetBuilder<UserController>(builder: (userController) {
                    if (_idNumberController.text.isEmpty) {
                      _idNumberController.text =
                          userController.userInfoModel?.agent!.identity ?? '';
                    }
                    return GetBuilder<EstateController>(
                        builder: (estateController) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 7),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                          Text(
                            'رقم الترخيص',
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                          // حقل إدخال رقم الترخيص
                          MyTextField(
                            hintText: 'ادخل رقم الترخيص',
                            controller: _numberLicenseController,
                            inputType: TextInputType.phone,
                            showBorder: true,
                            isEnabled: true,
                          ),

                          SizedBox(height: 20),
                          Text(
                            'هوية المعلن',
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall),
                          ),
                          MyTextField(
                            hintText: 'ادخل رقم المعلن',
                            controller:
                                _idNumberController, // تأكد من تعريف هذا المتغير
                            inputType: TextInputType.phone,
                            showBorder: true,
                            isEnabled: false,
                          ),

                          SizedBox(height: 20),
                          // دروب داون لست لخياري "منشأة" و"فرد"
                          Text(
                            'نوع المعلن',
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                          DropdownButtonFormField<String>(
                            value: estateController.advertiserType == 1
                                ? 'فرد'
                                : estateController.advertiserType == 2
                                    ? 'منشأة'
                                    : null, // القيمة الافتراضية
                            items: [
                              DropdownMenuItem(
                                value: 'فرد',
                                child: Text('فرد'),
                              ),
                              DropdownMenuItem(
                                value: 'منشأة',
                                child: Text('منشأة'),
                              ),
                            ],
                            onChanged: (value) {
                              estateController.setAdvertiserType(
                                  value!); // تحديث القيمة بناءً على الاختيار
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                            ),
                          ),

                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                          // زر التالي
                          !estateController.isLoading
                              ? CustomButton(
                                  height: 40,
                                  width: 100,
                                  buttonText: 'التالي',
                                  onPressed: () async {
                                    String licenseVerificationMessage = ''; // ✅ هذا هو المتغير الذي نحت

                                    String numberLicense =
                                        _numberLicenseController.text.trim();

                                    String advertiserNumber =
                                        _idNumberController.text.trim();
                                    final advertiserType =
                                        estateController.advertiserType;
                                    //print(advertiserType); // يطبع 1 أو 2 بناءً على اختيار المستخدم

                                    if (numberLicense.isEmpty) {
                                      showCustomSnackBar('ادخل رقم الترخيص');
                                    } else {
                                      bool isSuccess =
                                          await estateController.verifyLicense(
                                              numberLicense,
                                              advertiserNumber,
                                              advertiserType);

                                      if (isSuccess) {
                                        showCustomSnackBar(
                                            'تم التحقق من رقم الترخيص بنجاح!',
                                            isError: false);

                                        // حفظ البيانات باستخدام SharedPreferences
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        final data = estateController
                                            .licenseData; // البيانات من API
                                        await prefs.setString('advertiserId',
                                            data['advertiserId'].toString());
                                        await prefs.setString('advertiserName',
                                            data['advertiserName']);
                                        await prefs.setString(
                                            'phoneNumber', data['phoneNumber']);
                                        await prefs.setInt('advertiserType',
                                            estateController.advertiserType);

                                        // حفظ القيم المطلوبة أيضًا
                                        await prefs.setString(
                                            'numberLicense', numberLicense);
                                        await prefs.setString(
                                            'advertiserNumber',
                                            advertiserNumber);
                                        await prefs.setInt(
                                            'advertiserTypeInput',
                                            advertiserType); // هذا المدخل من المستخدم

                                        // الانتقال إلى صفحة إضافة العقار
                                        Get.toNamed(
                                            RouteHelper.getAddEstateRoute());
                                        // يمكنك إضافة المزيد من الحقول حسب الحاجة

                                        // الانتقال إلى الشاشة التالية إذا لزم الأمر
                                      } else {
                                        showCustomSnackBar(estateController.licenseVerificationMessage);
                                      }
                                    }
                                  },
                                )
                              : Center(child: CircularProgressIndicator()),
                        ],
                      );
                    });
                  });
                }))): NotLoggedInScreen(),
      ),
    );
  }
}
