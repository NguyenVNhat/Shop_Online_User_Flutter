import 'package:flutter_user_github/models/Model/Item/ProductItem.dart';

class Productmodel {
  bool? status;
  String? message;
  List<Productitem>? listproduct;
  List<Productitem>? get get_listproduct => listproduct;

  Productmodel({this.status, this.message, this.listproduct});

  Productmodel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      listproduct = <Productitem>[];
      json['data'].forEach((v) {
        listproduct!.add(new Productitem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.listproduct != null) {
      data['data'] = this.listproduct!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}