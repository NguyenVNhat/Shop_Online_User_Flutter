class Commentdto {
  int? rate;
  String? comment;
  int? productId;

  Commentdto({this.rate, this.comment, this.productId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rate'] = this.rate;
    data['comment'] = this.comment;
    data['productId'] = this.productId;
    return data;
  }
}