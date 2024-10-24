class Cartdto {
  List<int> cartlist;
  String deliveryAddress;
  String paymentMethod;
  double latitude;
  double longitude;
  Cartdto(
      {required this.cartlist,
      required this.latitude,
      required this.longitude,
      required this.deliveryAddress,
      required this.paymentMethod});
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data["cartIds"] = this.cartlist;
    data["deliveryAddress"] = this.deliveryAddress;
    data["paymentMethod"] = this.paymentMethod;
    data["latitude"] = this.latitude;
    data["longitude"] = this.longitude;
    return data;
  }
}
