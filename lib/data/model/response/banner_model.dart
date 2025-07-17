import 'package:abaad/data/model/response/basic_campaign_model.dart';
import 'package:abaad/data/model/response/service_provider.dart';


class BannerModel {
  List<BasicCampaignModel>? campaigns;
  List<Banner>? banners;

  BannerModel({required this.campaigns, required this.banners});

  BannerModel.fromJson(Map<String, dynamic> json) {
    if (json['campaigns'] != null) {
      campaigns = [];
      json['campaigns'].forEach((v) {
        campaigns?.add(BasicCampaignModel.fromJson(v));
      });
    }
    if (json['banners'] != null) {
      banners = [];
      json['banners'].forEach((v) {
        banners?.add(Banner.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['campaigns'] = campaigns?.map((v) => v.toJson()).toList();
      data['banners'] = banners?.map((v) => v.toJson()).toList();
      return data;
  }
}

class Banner {
  int id = 0;
  String title = "";
  String type = "";
  String image = "";
  ServiceProvider restaurant = ServiceProvider();

  Banner(
      {required this.id, required this.title, required this.type, required this.image, required this.restaurant});

  Banner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    image = json['image'];
    restaurant = (json['providers'] != null ? ServiceProvider.fromJson(json['providers']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['type'] = type;
    data['image'] = image;
    data['providers'] = restaurant.toJson();
      return data;
  }
}
