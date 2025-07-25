import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceProivderView extends StatefulWidget {
  final Estate estate;
  final bool fromView;
  const ServiceProivderView(
      {super.key, required this.estate, required this.fromView});

  @override
  State<ServiceProivderView> createState() => _ServiceProivderViewState();
}

class _ServiceProivderViewState extends State<ServiceProivderView> {
  final PageController _controller = PageController();
  //final CarouselController carouselController = CarouselController();
  final CarouselSliderController carouselController = CarouselSliderController();
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();

    Get.find<EstateController>().getEstateDetails(Estate(id: widget.estate.id));
  }

  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return widget.estate.serviceOffers != null
        ? SizedBox(
            height: 130,
            child: Stack(
              children: [
                Positioned(
                  top: 4,
                  right: 0,
                  left: 0,
                  bottom: 4,
                  child: GetBuilder<SplashController>(
                    builder: (splashController) {
                      String baseUrl = Get.find<SplashController>()
                          .configModel!
                          .baseUrls!
                          .provider;
                      return CarouselSlider(
                        items: widget.estate?.serviceOffers!
                            .map(
                              (item) => CustomImage(
                                image: '$baseUrl/${item.image}',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            )
                            .toList(),
                        carouselController: carouselController,
                        options: CarouselOptions(
                          scrollPhysics: const BouncingScrollPhysics(),
                          autoPlay: true,
                          aspectRatio: 2,
                          viewportFraction: 1,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 6,
                  right: 6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Container(
                          //   child: Text(
                          //     '${widget.estate.serviceOffers[currentIndex].title}',
                          //     style: robotoBlack.copyWith(fontSize: 11, color: Colors.white),
                          //   ),
                          // ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color:
                                  const Color(0xFF033D75), // كود اللون الكحلي
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.estate.serviceOffers![currentIndex].title!,
                              style: robotoBold.copyWith(
                                fontSize: 12,
                                color: Colors.white,
                                height: 1.2,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          const SizedBox(height: 3.0),

                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF033D75), // لون كُحلي
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  widget.estate.serviceOffers![currentIndex]
                                              .servicePrice !=
                                          null
                                      ? "price".tr
                                      : "discount".tr,
                                  style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),

                              // السعر أو الخصم
                              widget.estate.serviceOffers![currentIndex]
                                          .discount !=
                                      null
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                            0xFF033D75), // لون كُحلي
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        "${widget.estate.serviceOffers![currentIndex].discount}%",
                                        style: robotoBold.copyWith(
                                            fontSize: 11, color: Colors.white),
                                      ),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                            0xFF033D75), // لون كُحلي
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        "${widget.estate.serviceOffers![currentIndex].servicePrice} ريال",
                                        style: robotoBold.copyWith(
                                            fontSize: 11, color: Colors.white),
                                      ),
                                    ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF033D75), // لون كُحلي
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              widget.estate.serviceOffers![currentIndex].description!.length >  100
                                  ? '${widget.estate!.serviceOffers![currentIndex]!.description!.substring(0, 40)}...'
                                  : widget.estate!.serviceOffers![currentIndex]
                                      .description!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widget.estate.serviceOffers!
                            .asMap()
                            .entries
                            .map((entry) {
                          return GestureDetector(
                            onTap: () =>
                                carouselController.animateToPage(entry.key),
                            child: Container(
                              width: currentIndex == entry.key ? 17 : 7,
                              height: 7.0,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 3.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: currentIndex == entry.key
                                    ? Colors.red
                                    : Colors.teal,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(Images.background_gray),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Center(child: Container());
  }
}
