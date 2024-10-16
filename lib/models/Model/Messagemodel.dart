class Messagemodel {
  List<Usermessage>? listmessage;
  List<Usermessage>? get getlistmessage => listmessage;
  int? eC;
  String? eM;

  Messagemodel({this.listmessage, this.eC, this.eM});

  Messagemodel.fromJson(Map<String, dynamic> json) {
    if (json['DT'] != null) {
      listmessage = <Usermessage>[];
      json['DT'].forEach((v) {
        listmessage!.add(new Usermessage.fromJson(v));
      });
    }
    eC = json['EC'];
    eM = json['EM'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listmessage != null) {
      data['DT'] = this.listmessage!.map((v) => v.toJson()).toList();
    }
    data['EC'] = this.eC;
    data['EM'] = this.eM;
    return data;
  }
}

class Usermessage {
  String? message;
  String? image;
  int? sender;
  int? receiver;
  String? localTime;

  Usermessage({this.message, this.image, this.sender, this.receiver, this.localTime});

  Usermessage.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    image = json['image'];
    sender = json['sender'];
    receiver = json['receiver'];
    localTime = json['local_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['image'] = this.image;
    data['sender'] = this.sender;
    data['receiver'] = this.receiver;
    data['local_time'] = this.localTime;
    return data;
  }
}