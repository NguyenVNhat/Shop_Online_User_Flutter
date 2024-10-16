class Announcemodel {
  bool? success;
  String? message;
  List<AnnounceData>? announce;
  List<AnnounceData>? get getannounce => announce;

  Announcemodel({this.success, this.message, this.announce});

  Announcemodel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      announce = <AnnounceData>[];
      json['data'].forEach((v) {
        announce!.add(new AnnounceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.announce != null) {
      data['data'] = this.announce!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AnnounceData {
  int? id;
  int? userid;
  String? title;
  String? content;

  AnnounceData({this.id, this.userid, this.title, this.content});

  AnnounceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    title = json['title'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['title'] = this.title;
    data['content'] = this.content;
    return data;
  }
}