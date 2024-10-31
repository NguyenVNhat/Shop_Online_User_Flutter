import 'package:flutter_user_github/models/Model/UserModel.dart';

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

class DisplayRate{
  User? user;
  RateData? rateData;
  DisplayRate({
    this.user,
    this.rateData,
  });
}
class RateData {
  int? rateId;
  int? userId;
  int? rate;
  String? comment;
  String? createdAt;
  String? updatedAt;
  int? productId;
  int? comboId;
  List<String>? imageRatings;

  RateData(
      {this.rateId,
      this.userId,
      this.rate,
      this.comment,
      this.createdAt,
      this.updatedAt,
      this.productId,
      this.comboId,
      this.imageRatings});

  RateData.fromJson(Map<String, dynamic> json) {
    rateId = json['rateId'];
    userId = json['userId'];
    rate = json['rate'];
    comment = json['comment'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    productId = json['productId'];
    comboId = json['comboId'];
    imageRatings = json['imageRatings'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rateId'] = this.rateId;
    data['userId'] = this.userId;
    data['rate'] = this.rate;
    data['comment'] = this.comment;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['productId'] = this.productId;
    data['comboId'] = this.comboId;
    data['imageRatings'] = this.imageRatings;
    return data;
  }
}
