class Ratemodel {
  bool? success;
  String? message;
  List<RateData>? listrate;
  List<RateData>? get getlistrate => listrate;

  Ratemodel({this.success, this.message, this.listrate});

  Ratemodel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      listrate = <RateData>[];
      json['data'].forEach((v) {
        listrate!.add(new RateData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.listrate != null) {
      data['data'] = this.listrate!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RateData {
  int? rateId;
  String? userName;
  int? rate;
  String? comment;
  String? createdAt;
  String? updatedAt;
  int? productId;
  int? comboId;

  RateData(
      {this.rateId,
      this.userName,
      this.rate,
      this.comment,
      this.createdAt,
      this.updatedAt,
      this.productId,
      this.comboId});

  RateData.fromJson(Map<String, dynamic> json) {
    rateId = json['rateId'];
    userName = json['userName'];
    rate = json['rate'];
    comment = json['comment'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    productId = json['productId'];
    comboId = json['comboId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rateId'] = this.rateId;
    data['userName'] = this.userName;
    data['rate'] = this.rate;
    data['comment'] = this.comment;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['productId'] = this.productId;
    data['comboId'] = this.comboId;
    return data;
  }
}