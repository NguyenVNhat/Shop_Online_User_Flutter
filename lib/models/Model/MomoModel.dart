class MomoModels {
  String? requestType;
  String? orderId;
  String? signature;
  String? requestId;
  String? qrCodeUrl;
  String? deeplink;
  int? errorCode;
  String? payUrl;
  String? deeplinkWebInApp;
  String? message;
  String? localMessage;
  MomoModels(
      {this.requestType,
      this.orderId,
      this.signature,
      this.requestId,
      this.qrCodeUrl,
      this.deeplink,
      this.errorCode,
      this.payUrl,
      this.deeplinkWebInApp,
      this.message,
      this.localMessage});

 late MomoModels _momo;
  MomoModels get momo => _momo;
  MomoModels.fromJson(Map<String, dynamic> json) {
    requestType = json['requestType'];
    orderId = json['orderId'];
    signature = json['signature'];
    requestId = json['requestId'];
    qrCodeUrl = json['qrCodeUrl'];
    deeplink = json['deeplink'];
    errorCode = json['errorCode'];
    payUrl = json['payUrl'];
    deeplinkWebInApp = json['deeplinkWebInApp'];
    message = json['message'];
    localMessage = json['localMessage'];
    if(json['data'] != null){
      _momo = MomoModels();
      _momo =  MomoModels.fromJson(json['data']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestType'] = this.requestType;
    data['orderId'] = this.orderId;
    data['signature'] = this.signature;
    data['requestId'] = this.requestId;
    data['qrCodeUrl'] = this.qrCodeUrl;
    data['deeplink'] = this.deeplink;
    data['errorCode'] = this.errorCode;
    data['payUrl'] = this.payUrl;
    data['deeplinkWebInApp'] = this.deeplinkWebInApp;
    data['message'] = this.message;
    data['localMessage'] = this.localMessage;
    return data;
  }
}
