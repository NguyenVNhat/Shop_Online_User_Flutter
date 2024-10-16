class Annoucedto {
  int userid;
  String title;
  String content;
  Annoucedto(
      {required this.userid,
      required this.title,
      required this.content});
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data["userid"] = this.userid;
    data["title"] = this.title;
    data["content"] = this.content;
    return data;
  }
}
