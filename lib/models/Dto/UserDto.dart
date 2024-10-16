class Userdto {
  String username;
  String password;
  Userdto({
    required this.username,
    required this.password,
  });
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["numberPhone"] = this.username;
    data["password"] = this.password;
    return data;
  }
}
