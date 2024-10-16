

import 'package:flutter_user_github/models/Model/UserModel.dart';

class Chartmodel {
  List<UserChart>? listuser;
  List<UserChart>? get getlistuser => listuser;
  int? eC;
  String? eM;

  Chartmodel({this.listuser, this.eC, this.eM});

  Chartmodel.fromJson(Map<String, dynamic> json) {
    if (json['DT'] != null) {
      listuser = <UserChart>[];
      json['DT'].forEach((v) {
        listuser!.add(new UserChart.fromJson(v));
      });
    }
    eC = json['EC'];
    eM = json['EM'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listuser != null) {
      data['DT'] = this.listuser!.map((v) => v.toJson()).toList();
    }
    data['EC'] = this.eC;
    data['EM'] = this.eM;
    return data;
  }
}

class UserChart {
  int? id;
  String? phoneNumber;
  String? fullName;
  String? avatar;
  String? email;
  String? address;
  double? longitude;
  double? latitude;
  String? createdAt;
  String? updatedAt;
  bool? accountLocked;
  bool? isActive;
  Role? role;

  UserChart(
      {this.id,
      this.phoneNumber,
      this.fullName,
      this.avatar,
      this.email,
      this.address,
      this.longitude,
      this.latitude,
      this.createdAt,
      this.updatedAt,
      this.accountLocked,
      this.isActive,
      this.role});

  UserChart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumber = json['phoneNumber'];
    fullName = json['fullName'];
    avatar = json['avatar'];
    email = json['email'];
    address = json['address'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    accountLocked = json['accountLocked'];
    isActive = json['isActive'];
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phoneNumber'] = this.phoneNumber;
    data['fullName'] = this.fullName;
    data['avatar'] = this.avatar;
    data['email'] = this.email;
    data['address'] = this.address;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['accountLocked'] = this.accountLocked;
    data['isActive'] = this.isActive;
    if (this.role != null) {
      data['role'] = this.role!.toJson();
    }
    return data;
  }
}
