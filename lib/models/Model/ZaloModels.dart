class ZaloModels {
  bool? success;
  String? message;
  ZaloData? zalodata;
  ZaloData? get getzalodata => zalodata; 

  ZaloModels({this.success, this.message, this.zalodata});

  ZaloModels.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    zalodata = json['data'] != null ? new ZaloData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.zalodata != null) {
      data['data'] = this.zalodata!.toJson();
    }
    return data;
  }
}

class ZaloData {
  String? returnmessage;
  String? orderurl;
  int? returncode;
  String? zptranstoken;
  String? apptransid;
  String? orderId;

  ZaloData(
      {this.returnmessage,
      this.orderurl,
      this.returncode,
      this.zptranstoken,
      this.apptransid,
      this.orderId});

  ZaloData.fromJson(Map<String, dynamic> json) {
    returnmessage = json['returnmessage'];
    orderurl = json['orderurl'];
    returncode = json['returncode'];
    zptranstoken = json['zptranstoken'];
    apptransid = json['apptransid'];
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['returnmessage'] = this.returnmessage;
    data['orderurl'] = this.orderurl;
    data['returncode'] = this.returncode;
    data['zptranstoken'] = this.zptranstoken;
    data['apptransid'] = this.apptransid;
    data['order_id'] = this.orderId;
    return data;
  }
}