class Chartdto {
  int? sender;
  int? receiver;
  String? message;
  String? imageBase64;
  bool? isRead;

  Chartdto({
    required this.sender,
    required this.receiver,
    required this.message,
    required this.imageBase64,
    required this.isRead
  });
  
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data["sender"] = this.sender;
    data["receiver"] = this.receiver;
    data["message"] = this.message;
    data["imageBase64"] = this.imageBase64;
    data["isRead"] = this.isRead;
    return data;
  }
}