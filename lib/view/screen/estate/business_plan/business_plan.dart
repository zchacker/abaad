
import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/data/model/response/package_model.dart';
import 'package:abaad/helper/color_coverter.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_app_bar.dart';
import 'package:abaad/view/base/custom_button.dart';
import 'package:abaad/view/screen/auth/widget/registration_stepper_widget.dart';
import 'package:abaad/view/screen/estate/business_plan/widgets/success_widget.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/subscription_card.dart';
class BusinessPlanScreen extends StatefulWidget {
  final int estateId;
  const  BusinessPlanScreen({Key? key, required this.estateId}) : super(key: key);

  @override
  State<BusinessPlanScreen> createState() => _BusinessPlanScreenState();
}

class _BusinessPlanScreenState extends State<BusinessPlanScreen> {

  final bool _canBack = GetPlatform.isWeb ? true : false;

  @override
  void initState() {
    super.initState();
    Get.find<AuthController>().resetBusiness();
    Get.find<AuthController>().getPackageList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        return WillPopScope(
          onWillPop: () async{
            if(_canBack) {
              return true;
            }else {
              authController.showBackPressedDialogue('your_business_plan_not_setup_yet'.tr);
              return false;
            }
          },
          child: Scaffold(
            appBar: CustomAppBar(title: 'business_plan'.tr, isBackButtonExist: false),
            body: authController.businessPlanStatus == 'complete' ? SuccessWidget() : Center(
              child: Column(children: [

                SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                SizedBox(
                  width: Dimensions.WEB_MAX_WIDTH,
                  child: RegistrationStepperWidget(status: authController.businessPlanStatus),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: Dimensions.WEB_MAX_WIDTH,
                      child: Center(
                        child: Column(children: [


                          authController.businessPlanStatus != 'payment' ? Column(children: [

                            Center(child: Text('choose_your_business_plan'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault))),
                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                              child: Row(children: [
                                Get.find<SplashController>().configModel?.businessPlan?.commission != 0 ? Expanded(
                                  child: baseCardWidget(authController, context, title: 'Commission Base',
                                      index: 0, onTap: ()=> authController.setBusiness(0)),
                                ) : SizedBox(),
                                SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),

                                Get.find<SplashController>().configModel?.businessPlan?.subscription != 0 ? Expanded(
                                  child: baseCardWidget(authController, context, title: 'Subscription Base',
                                      index: 1, onTap: ()=> authController.setBusiness(1)),
                                ) : SizedBox(),
                              ]),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                            authController.businessIndex == 0 ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                              child: Text(
                                "${'restaurant_will_pay'.tr} ${Get.find<SplashController>().configModel?.adminCommission}% ${'commission_to'.tr} ${Get.find<SplashController>().configModel?.businessName} ${'from_each_order_You_will_get_access_of_all'.tr}",
                                style: robotoRegular, textAlign: TextAlign.start, textScaleFactor: 1.1,
                              ),
                            ) : Container(
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                                  child: Text(
                                    'run_restaurant_by_purchasing_subscription_packages'.tr,
                                    style: robotoRegular, textAlign: TextAlign.start,
                                  ),
                                ),

                                authController.packageModel != null ? SizedBox(
                                  height: ResponsiveHelper.isDesktop(context) ? 700 : 600,
                                  child: ((authController.packageModel?.packages?.isNotEmpty ?? false) && (authController.packageModel?.packages?.isNotEmpty ?? false)) ? Swiper(

                                    itemCount: authController.packageModel?.packages?.length ?? 40,
                                    itemWidth: ResponsiveHelper.isDesktop(context) ? 400 : context.width * 0.8,
                                    itemHeight: 600.0,
                                    layout: SwiperLayout.STACK,
                                    onIndexChanged: (index){
                                      authController.selectSubscriptionCard(index);
                                    },
                                    itemBuilder: (BuildContext context, int index){
                                      Packages package = authController.packageModel!.packages![index];

                                      Color color = ColorConverter.stringToColor(package.color);

                                      return GetBuilder<AuthController>(
                                          builder: (authController) {

                                            return Stack(clipBehavior: Clip.none, children: [

                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).cardColor,
                                                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_EXTRA_LARGE),
                                                  boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 10)],
                                                ),
                                                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_LARGE, bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                child: SubscriptionCard(index: index, authController: authController, package: package, color: color),
                                              ),

                                              authController.activeSubscriptionIndex == index ? Positioned(
                                                top: 5, right: -10,
                                                child: Container(
                                                  height: 40, width: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(50),
                                                    color: color, border: Border.all(color: Theme.of(context).cardColor, width: 2),
                                                  ),
                                                  child: Icon(Icons.check, color: Theme.of(context).cardColor),
                                                ),
                                              ) : SizedBox(),

                                            ]);
                                          }
                                      );
                                    },
                                  ) : Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(Images.empty_box, height: 150),
                                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                                        Text('no_package_available'.tr),
                                      ]),
                                  ),
                                ) : CircularProgressIndicator(),

                                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                              ]),
                            ),
                          ]) : Padding(
                            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                            child: Column(children: [

                              Get.find<SplashController>().configModel?.freeTrialPeriodStatus == 1
                                  ? paymentCart(
                                  title: '${'continue_with'.tr} ${Get.find<SplashController>().configModel?.freeTrialPeriodDay} ${'days_free_trial'.tr}',
                                  index: 0,
                                  onTap: (){
                                    authController.setPaymentIndex(0);
                                  }) : SizedBox(),

                              SizedBox(height: Dimensions.PADDING_SIZE_OVER_LARGE),

                              paymentCart(title: 'pay_manually'.tr, index: 1, onTap: ()=> authController.setPaymentIndex(1)),
                            ]),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  width: Dimensions.WEB_MAX_WIDTH,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_SMALL),
                    child: Row(children: [
                      (authController.businessPlanStatus == 'payment') ? Expanded(
                        child: InkWell(
                          onTap: () {
                            if(authController.businessPlanStatus != 'payment'){
                              authController.showBackPressedDialogue('your_business_plan_not_setup_yet'.tr);
                            }else{
                              authController.setBusinessStatus('business');
                              if(authController.isFirstTime == false){
                                authController.isFirstTime = true;
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Icon(Icons.keyboard_double_arrow_left),
                              SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                              Text("back".tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),),
                            ]),
                          ),
                        ),
                      ) : SizedBox(),
                      SizedBox(width: (authController.businessPlanStatus == 'payment') ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),

                      authController.businessIndex == 0 || (authController.businessIndex == 1 && (authController.packageModel?.packages?.isNotEmpty ?? false)) ? Expanded(child: CustomButton(
                        buttonText: 'next'.tr,
                        onPressed: () => authController.submitBusinessPlan(estateId: widget.estateId),
                      )) : SizedBox(),
                    ]),
                  ),
                )
              ]),
            ),
          ),
        );
      }
    );
  }

  Widget paymentCart({required String title, required int index, required Function onTap}){
    return GetBuilder<AuthController>(
      builder: (authController) {
        return Stack( clipBehavior: Clip.none, children: [
            InkWell(
              onTap: onTap as GestureTapCallback?,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
                  border: authController.paymentIndex == index ? Border.all(color: Theme.of(context).primaryColor, width: 1) : null,
                  boxShadow: authController.paymentIndex != index ? [BoxShadow(color: Colors.grey[300]!, blurRadius: 10)] : null,
                  color: authController.paymentIndex == index ? Theme.of(context).primaryColor.withOpacity(0.05) : Theme.of(context).cardColor,
                ),
                alignment: Alignment.center,
                width: context.width,
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_LARGE),
                child: Text(title, style: robotoBold.copyWith(color: authController.paymentIndex == index ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge?.color)),
              ),
            ),

          authController.paymentIndex == index ? Positioned(
              top: -8, right: -8,
              child: Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                child: Icon(Icons.check, size: 18, color: Theme.of(context).cardColor),
              ),
            ) : SizedBox(),
          ],
        );
      }
    );
  }

  Widget baseCardWidget(AuthController authController, BuildContext context,{ required String title, required int index, required Function onTap}){
    return InkWell(
      onTap: onTap  as GestureTapCallback?,
      child: Stack(clipBehavior: Clip.none, children: [

        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              color: authController.businessIndex == index ? Theme.of(context).primaryColor.withOpacity(0.1) : Theme.of(context).cardColor,
              border: authController.businessIndex == index ? Border.all(color: Theme.of(context).primaryColor, width: 0.5) : null,
              boxShadow: authController.businessIndex == index ? null : [BoxShadow(color: Colors.grey[200]!, offset: Offset(5, 5), blurRadius: 10)]
          ),
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT, vertical: Dimensions.PADDING_SIZE_LARGE),
          child: Center(child: Text(title, style: robotoMedium.copyWith(color: authController.businessIndex == index ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeDefault))),
        ),

        authController.businessIndex == index ? Positioned(
          top: -10, right: -10,
          child: Container(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
            decoration: BoxDecoration(
              shape: BoxShape.circle, color: Theme.of(context).primaryColor,
            ),
            child: Icon(Icons.check, size: 14, color: Theme.of(context).cardColor),
          ),
        ) : SizedBox()
      ]),
    );
  }
}



