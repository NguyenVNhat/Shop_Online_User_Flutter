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
  int? voucherId;
  List<int>? storeId;
  String? code;
  double? discountPercent;
  String? description;
  String? startDate;
  String? endDate;
  bool? used;

  PromotionData(
      {this.voucherId,
      this.storeId,
      this.code,
      this.discountPercent,
      this.description,
      this.startDate,
      this.endDate,
      this.used
      });

  PromotionData.fromJson(Map<String, dynamic> json) {
    voucherId = json['voucherId'];
    storeId = json['storeId'].cast<int>();
    code = json['code'];
    discountPercent = json['discountPercent'];
    description = json['description'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    used = json['used'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['voucherId'] = this.voucherId;
    data['storeId'] = this.storeId;
    data['code'] = this.code;
    data['discountPercent'] = this.discountPercent;
    data['description'] = this.description;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['used'] = this.used;
    return data;
  }
}