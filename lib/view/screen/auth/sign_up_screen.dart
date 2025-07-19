import 'dart:convert';
import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/data/model/body/signup_body.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_button.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/base/custom_text_field.dart';
import 'package:abaad/view/base/web_menu_bar.dart';
//import 'package:country_code_picker/country_code.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';

import 'widget/code_picker_widget.dart';
import 'widget/condition_check_box.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  // final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _referCodeFocus = FocusNode();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _referCodeController = TextEditingController();
  String _registrationType = 'individual';
  final TextEditingController _unifiedNumberController = TextEditingController();

  String _countryDialCode;
  String _membershipType;
  String _selectedUserType;

  @override
  void initState() {
    super.initState();
   // Get.find<AuthController>().zoneList.;
    _countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel.country).dialCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      body: SafeArea(child: Scrollbar(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          physics: BouncingScrollPhysics(),
          child: Center(
            child: Container(
              width: context.width > 700 ? 700 : context.width,
              padding: context.width > 700 ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT) : null,
              decoration: context.width > 700 ? BoxDecoration(

                boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300], blurRadius: 5, spreadRadius: 1)],
              ) : null,
              child: GetBuilder<AuthController>(builder: (authController) {

                return Column(children: [

                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                  Image.asset(Images.logo, width: 130),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                  const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                  SizedBox(height: 20),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),


                    ),
                    child: Column(children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'full_name'.tr,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                          ),
                          CustomTextField(
                            hintText: 'ali'.tr,
                            controller: _fullNameController,
                            focusNode: _firstNameFocus,
                            nextFocus: _emailFocus,
                            inputType: TextInputType.name,
                            capitalization: TextCapitalization.words,
                            prefixIcon: Icons.person,
                            showTitle: ResponsiveHelper.isDesktop(context),

                          ),
                        ],
                      ),
                      // CustomTextField(
                      //   hintText: 'last_name'.tr,
                      //   controller: _lastNameController,
                      //   focusNode: _lastNameFocus,
                      //   nextFocus: _emailFocus,
                      //   inputType: TextInputType.name,
                      //   capitalization: TextCapitalization.words,
                      //   prefixIcon: Images.mail,
                      //   divider: true,
                      // ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'email'.tr,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                          ),
                          CustomTextField(
                            hintText: 'ali4322@hostmail.com(إختياري)',
                            controller: _emailController,
                            focusNode: _emailFocus,
                            nextFocus: _phoneFocus,
                            inputType: TextInputType.emailAddress,
                            prefixIcon: Icons.mail,
                            showTitle: ResponsiveHelper.isDesktop(context),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'phone'.tr,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                          ),
                          SizedBox(height: 4),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Container(
                              color: Theme.of(context).cardColor,
                              child: Row(children: [
                                CodePickerWidget(
                                  onChanged: (CountryCode countryCode) {
                                    _countryDialCode = countryCode.dialCode;
                                  },
                                  initialSelection: CountryCode.fromCountryCode(Get.find<SplashController>().configModel.country).code,
                                  favorite: [CountryCode.fromCountryCode(Get.find<SplashController>().configModel.country).code],
                                  showDropDownButton: true,
                                  padding: EdgeInsets.zero,
                                  showFlagMain: true,
                                  dialogBackgroundColor: Theme.of(context).cardColor,
                                  textStyle: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge.color,
                                  ),
                                ),
                                Expanded(child: CustomTextField(
                                  hintText: '500000000',
                                  controller: _phoneController,
                                  focusNode: _phoneFocus,
                                  nextFocus: _passwordFocus,
                                  inputType: TextInputType.phone,
                                  showTitle: ResponsiveHelper.isDesktop(context),
                                )),
                              ]),
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE), child: Divider(height: 1)),



                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'نوع المستخدم',
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[Get.isDarkMode ? 800 : 200],
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: _selectedUserType,
                                hint: Text(
                                  'اختر نوع المستخدم',
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeLarge,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                                icon: Icon(Icons.keyboard_arrow_down),
                                items: [
                                  DropdownMenuItem(
                                    value: 'باحث عن عقار',
                                    child: Text('باحث عن عقار'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'مسوق عقاري',
                                    child: Text('مسوق عقاري'),
                                  ),
                                ],
                                onChanged: (String newValue) {
                                  setState(() {
                                    _selectedUserType = newValue;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),


                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'نوع التسجيل',
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                              border: Border.all(color: Theme.of(context).disabledColor),
                            ),
                            child: DropdownButton<String>(
                              value: _registrationType,
                              onChanged: (String newValue) {
                                setState(() {
                                  _registrationType = newValue;
                                });
                              },
                              isExpanded: true,
                              underline: SizedBox(),
                              items: <DropdownMenuItem<String>>[
                                DropdownMenuItem(
                                  value: 'individual',
                                  child: Text('فرد'),
                                ),
                                DropdownMenuItem(
                                  value: 'organization',
                                  child: Text('منشأة'),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                          // الرقم الموحد (يظهر فقط إذا كانت منشأة)
                          if (_registrationType == 'organization')
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'الرقم الموحد',
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                                ),
                                CustomTextField(
                                  hintText: 'ادخل الرقم الموحد',
                                  controller: _unifiedNumberController,
                                  inputType: TextInputType.number,
                                ),
                              ],
                            ),
                        ],
                      )


                      // CustomTextField(
                      //   hintText: 'password'.tr,
                      //   controller: _passwordController,
                      //   focusNode: _passwordFocus,
                      //   nextFocus: _confirmPasswordFocus,
                      //   inputType: TextInputType.visiblePassword,
                      //   prefixIcon: Images.lock,
                      //   isPassword: true,
                      //   divider: true,
                      // ),
                      //
                      // CustomTextField(
                      //   hintText: 'confirm_password'.tr,
                      //   controller: _confirmPasswordController,
                      //   focusNode: _confirmPasswordFocus,
                      //   nextFocus: Get.find<SplashController>().configModel.refEarningStatus == 1 ? _referCodeFocus : null,
                      //   inputAction: Get.find<SplashController>().configModel.refEarningStatus == 1 ? TextInputAction.next : TextInputAction.done,
                      //   inputType: TextInputType.visiblePassword,
                      //   prefixIcon: Images.lock,
                      //   isPassword: true,
                      //   divider: Get.find<SplashController>().configModel.refEarningStatus == 1 ? true : false,
                      //   onSubmit: (text) => (GetPlatform.isWeb && authController.acceptTerms) ? _register(authController, _countryDialCode) : null,
                      // ),

                //       SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                //       Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             'refer_code'.tr,
                //             style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                //           ),
                //           CustomTextField(
                //             hintText: 'refer_code'.tr,
                //             controller: _referCodeController,
                //             focusNode: _referCodeFocus,
                //             inputAction: TextInputAction.done,
                //             inputType: TextInputType.text,
                //             capitalization: TextCapitalization.words,
                //             prefixIcon: Images.arabic,
                //             divider: false,
                //             prefixSize: 14,
                //           ),
                //         ],
                //       ),

                    ]),
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                  ConditionCheckBox(authController: authController),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                  !authController.isLoading ? Row(children: [
                    // Expanded(child: CustomButton(
                    //   buttonText: 'sign_in'.tr,
                    //   transparent: true,
                    //   onPressed: () =>Get.toNamed(RouteHelper.getSignInRoute(RouteHelper.signUp)),
                    // )),
                    Expanded(child: CustomButton(
                      buttonText: 'sign_up'.tr,
                      onPressed: authController.acceptTerms ? () => _register(authController, _countryDialCode) : null,
                    )),
                  ]) : Center(child: CircularProgressIndicator()),
                  SizedBox(height: 30),

                  // SocialLoginWidget(),


                ]);
              }),
            ),
          ),
        ),
      )),
    );
  }

  void _register(AuthController authController, String countryCode) async {
    String fullName = _fullNameController.text.trim();
    String email = _emailController.text.trim();
    String number = _phoneController.text.trim();
    // String _password = _passwordController.text.trim();
    // String _confirmPassword = _confirmPasswordController.text.trim();
    String referCode = _referCodeController.text.trim();

    String numberWithCountryCode = countryCode+number;
    bool isValid = GetPlatform.isWeb ? true : false;
    if(!GetPlatform.isWeb) {
      try {
        PhoneNumber phoneNumber = await PhoneNumberUtil().parse(numberWithCountryCode);
        numberWithCountryCode = '+${phoneNumber.countryCode}${phoneNumber.nationalNumber}';
        isValid = true;
      } catch (e) {}
    }

    if (fullName.isEmpty) {
      showCustomSnackBar('enter_your_name'.tr);
    }else if (number.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    }

    // else if (!_isValid) {
    //   showCustomSnackBar('invalid_phone_number'.tr);
    // }
    // else if (_password.isEmpty) {
    //   showCustomSnackBar('enter_password'.tr);
    // }else if (_password.length < 6) {
    //   showCustomSnackBar('password_should_be'.tr);
    // }else if (_password != _confirmPassword) {
    //   showCustomSnackBar('confirm_password_does_not_matched'.tr);
    // }
    else if (_selectedUserType.isEmpty) {
      showCustomSnackBar('يرجى اختيار نوع المستخدم');
    }
    else if (referCode.isNotEmpty && referCode.length != 10) {
      showCustomSnackBar('invalid_refer_code'.tr);
    }else {
      SignUpBody signUpBody = SignUpBody(
        fName: fullName, email: email, phone: numberWithCountryCode, password: "1234567",
        refCode: referCode,zone_id:  0,
        membershipType: _selectedUserType,
        unifiedNumber: _registrationType == 'organization' ? _unifiedNumberController.text.trim() : null,
      );
      authController.registration(signUpBody).then((status) async {
        if (status.isSuccess) {
          if(Get.find<SplashController>().configModel.customerVerification) {
            List<int> encoded = utf8.encode("1234567");
            String data = base64Encode(encoded);
            Get.toNamed(RouteHelper.getVerificationRoute(numberWithCountryCode, status.message, RouteHelper.signUp, data));
          }else {
            Get.toNamed(RouteHelper.getAccessLocationRoute(RouteHelper.signUp));
          }
        }else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}
