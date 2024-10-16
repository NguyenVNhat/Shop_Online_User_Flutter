import 'package:flutter_user_github/models/Model/Item/StoresItem.dart';

class Storesmodel {
  bool? status;
  String? message;
  List<Storesitem>? liststores;
  List<Storesitem>? get get_liststores => liststores;

  Storesmodel({this.status, this.message, this.liststores});

  Storesmodel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      liststores = <Storesitem>[];
      json['data'].forEach((v) {
        liststores!.add(new Storesitem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.liststores != null) {
      data['data'] = this.liststores!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}