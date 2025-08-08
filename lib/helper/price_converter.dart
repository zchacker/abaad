
import 'package:abaad_flutter/controller/splash_controller.dart';
import 'package:get/get.dart';

class PriceConverter {
  static String convertPrice(double price, { double discount = 0,  String discountType = ""}) {
    if(discountType == 'amount') {
      price = price - discount;
    }else if(discountType == 'percent') {
      price = price - ((discount / 100) * price);
    }
      bool isRightSide = Get.find<SplashController>().configModel?.currencySymbolDirection == 'right';
    return '${isRightSide ? '' : '${Get.find<SplashController>().configModel?.currencySymbol} '}'
        '${(price).toStringAsFixed(Get.find<SplashController>().configModel!.digitAfterDecimalPoint ?? 1)
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'
        '${isRightSide ? ' ${Get.find<SplashController>().configModel?.currencySymbol}' : ''}';
  }


  static double convertWithDiscount(double price, double discount, String discountType) {
    if(discountType == 'amount') {
      price = price - discount;
    }else if(discountType == 'percent') {
      price = price - ((discount / 100) * price);
    }
    return price;
  }

  static double calculation(double amount, double discount, String type, int quantity) {
    double calculatedAmount = 0;
    if(type == 'amount') {
      calculatedAmount = discount * quantity;
    }else if(type == 'percent') {
      calculatedAmount = (discount / 100) * (amount * quantity);
    }
    return calculatedAmount;
  }

  static String percentageCalculation(String price, String discount, String discountType) {
    return '$discount${discountType == 'percent' ? '%' : Get.find<SplashController>().configModel?.currencySymbol} OFF';
  }
}