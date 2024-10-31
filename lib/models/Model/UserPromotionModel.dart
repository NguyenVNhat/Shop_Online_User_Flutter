class UserPromotionModel {
  bool? success;
  String? message;
  List<UserPromotionData>? listpromotion;
  List<UserPromotionData>? get getlistpromotion => listpromotion;

  UserPromotionModel({this.success, this.message, this.listpromotion});

  UserPromotionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      listpromotion = <UserPromotionData>[];
      json['data'].forEach((v) {
        listpromotion!.add(new UserPromotionData.fromJson(v));
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

class UserPromotionData {
  int? id;
  int? userId;
  int? storeId;
  int? promotionId;
  String? promotionCode;
  double? percent;
  bool? used;

  UserPromotionData(
      {this.id,
      this.userId,
      this.storeId,
      this.promotionId,
      this.promotionCode,
      this.percent,
      this.used});

  UserPromotionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    storeId = json['storeId'];
    promotionId = json['promotionId'];
    promotionCode = json['promotionCode'];
    percent = json['percent'];
    used = json['used'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['storeId'] = this.storeId;
    data['promotionId'] = this.promotionId;
    data['promotionCode'] = this.promotionCode;
    data['percent'] = this.percent;
    data['used'] = this.used;
    return data;
  }
}