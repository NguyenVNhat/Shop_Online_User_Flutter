class Userregisterdto {
  String fullname;
  String password;
  String phonenumber;
  String email;
  String address;
  double longtitude;
  double latitude;
  Userregisterdto(
      {required this.fullname,
      required this.password,
      required this.phonenumber,
      required this.email,
      required this.longtitude,
      required this.latitude,
      required this.address});
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data["fullName"] = this.fullname;
    data["password"] = this.password;
    data["longtitude"] = this.longtitude;
    data["latitude"] = this.latitude;
    data["phoneNumber"] = this.phonenumber;
    data["email"] = this.email;
    data["address"] = this.address;
    return data;
  }
}
