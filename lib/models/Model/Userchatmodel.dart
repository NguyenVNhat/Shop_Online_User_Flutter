import 'package:flutter_user_github/models/Model/UserModel.dart';

class Userchatmodel {
  bool? status;
  String? message;
  List<User>? listuser;
  List<User>? get getlistuser => listuser;

  Userchatmodel({this.status, this.message, this.listuser});

  Userchatmodel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      listuser = <User>[];
      json['data'].forEach((v) {
        listuser!.add(new User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
   if (this.listuser != null) {
      data['data'] = this.listuser!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
