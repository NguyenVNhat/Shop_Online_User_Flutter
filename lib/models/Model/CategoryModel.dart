import 'package:flutter_user_github/models/Model/Item/CategoryItem.dart';

class Categorymodel {
  bool? status;
  String? message;
  List<Categoryitem>? listCategory;
  List<Categoryitem>? get  get_listCategory => listCategory;

  Categorymodel({this.status, this.message, this.listCategory});

  Categorymodel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      listCategory = <Categoryitem>[];
      json['data'].forEach((v) {
        listCategory!.add(new Categoryitem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.listCategory != null) {
      data['data'] = this.listCategory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}