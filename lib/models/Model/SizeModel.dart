class Sizemodel {
  bool? status;
  String? message;
  List<Size>? listsize;
  List<Size>? get getlistsize => listsize;

  Sizemodel({this.status, this.message, this.listsize});

  Sizemodel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      listsize = <Size>[];
      json['data'].forEach((v) {
        listsize!.add(new Size.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.listsize != null) {
      data['data'] = this.listsize!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Size {
  int? id;
  String? name;

  Size({this.id, this.name});

  Size.fromJson(Map<String, dynamic> json) {
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