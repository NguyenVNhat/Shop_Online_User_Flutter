

import 'package:flutter_user_github/models/Model/Item/ComboItem.dart';

class Combomodel {
  bool? status;
  String? message;
  List<Comboitem>? listcombo;
  List<Comboitem>? get get_listcombo => listcombo;

  Combomodel({this.status, this.message, this.listcombo});

  Combomodel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      listcombo = <Comboitem>[];
      json['data'].forEach((v) {
        listcombo!.add(new Comboitem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.listcombo != null) {
      data['data'] = this.listcombo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
