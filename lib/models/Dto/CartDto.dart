class Cartdto {
  List<int> cartlist;
  String deliveryAddress;
  String paymentMethod;
  Cartdto(
      {required this.cartlist,
      required this.deliveryAddress,
      required this.paymentMethod});
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data["cartIds"] = this.cartlist;
    data["deliveryAddress"] = this.deliveryAddress;
    data["paymentMethod"] = this.paymentMethod;
    return data;
  }
}
