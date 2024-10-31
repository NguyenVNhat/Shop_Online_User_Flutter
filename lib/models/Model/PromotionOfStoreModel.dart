import 'package:flutter_user_github/models/Model/Item/StoresItem.dart';

class Promotionofstoremodel {
  bool? success;
  String? message;
  List<PromotionDataOfStore>? listPromotion;
  List<PromotionDataOfStore>? get getlistPromotion => listPromotion;

  Promotionofstoremodel({this.success, this.message, this.listPromotion});

  Promotionofstoremodel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      listPromotion = <PromotionDataOfStore>[];
      json['data'].forEach((v) {
        listPromotion!.add(new PromotionDataOfStore.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.listPromotion != null) {
      data['data'] = this.listPromotion!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class DisplayPromotionData{
  Storesitem? storesitem;
  List<PromotionDataOfStore>? promotionDataOfStore;
  DisplayPromotionData({
    this.storesitem,
    this.promotionDataOfStore
  });
}


class PromotionDataOfStore {
  int? id;
  String? name;
  String? description;
  String? image;
  double? discountPercentage;
  String? startDate;
  String? endDate;
  List<int>? storeIds;
  List<String>? storeNames;

  PromotionDataOfStore(
      {this.id,
      this.name,
      this.description,
      this.image,
      this.discountPercentage,
      this.startDate,
      this.endDate,
      this.storeIds,
      this.storeNames});

  PromotionDataOfStore.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    discountPercentage = json['discountPercentage'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    storeIds = json['storeIds'].cast<int>();
    storeNames = json['storeNames'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['discountPercentage'] = this.discountPercentage;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['storeIds'] = this.storeIds;
    data['storeNames'] = this.storeNames;
    return data;
  }
}