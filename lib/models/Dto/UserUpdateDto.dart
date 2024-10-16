class Userupdatedto {
  String fullName;
  String  avatar;
  String email;
  String address;
  Userupdatedto(
      {required this.fullName,
      required this.avatar,
      required this.email,
      required this.address});
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data["fullName"] = this.fullName;
    data["avatar"] = this.avatar;
    data["email"] = this.email;
    data["address"] = this.address;
    return data;
  }
}
