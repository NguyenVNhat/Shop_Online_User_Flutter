class Promotionmodel {
  bool? success;
  String? message;
  List<PromotionData>? listpromotion;
  List<PromotionData>? get getlistpromotion => listpromotion;

  Promotionmodel({this.success, this.message, this.listpromotion});

  Promotionmodel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      listpromotion = <PromotionData>[];
      json['data'].forEach((v) {
        listpromotion!.add(new PromotionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.listpromotion != null) {
      data['data'] = this.listpromotion!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PromotionData {
  int? id;
  String? name;
  String? description;
  String? image;
  double? discountPercentage;
  String? startDate;
  String? endDate;
  List<int>? storeIds;

  PromotionData(
      {this.id,
      this.name,
      this.description,
      this.image,
      this.discountPercentage,
      this.startDate,
      this.endDate,
      this.storeIds});

  PromotionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    discountPercentage = json['discountPercentage'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    storeIds = json['storeIds'].cast<int>();
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
    return data;
  }
}