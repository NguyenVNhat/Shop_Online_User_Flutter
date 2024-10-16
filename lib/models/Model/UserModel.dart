class Usermodel {
  bool? status;
  String? message;
  User? user;
  User? get getuser => user;

  Usermodel({this.status, this.message, this.user});

  Usermodel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    user = json['data'] != null ? new User.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.user != null) {
      data['data'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? phoneNumber;
  String? fullName;
  String? avatar;
  double? longitude;
  double? latitude;
  String? email;
  String? address;
  String? createdAt;
  String? updatedAt;
  bool? accountLocked;
  Role? role;

  User(
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
      this.role});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumber = json['phoneNumber'];
    fullName = json['fullName'];
    avatar = json['avatar'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    email = json['email'];
    address = json['address'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    accountLocked = json['accountLocked'];
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phoneNumber'] = this.phoneNumber;
    data['fullName'] = this.fullName;
    data['avatar'] = this.avatar;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['email'] = this.email;
    data['address'] = this.address;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['accountLocked'] = this.accountLocked;
    if (this.role != null) {
      data['role'] = this.role!.toJson();
    }
    return data;
  }
}

class Role {
  int? id;
  String? name;

  Role({this.id, this.name});

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
