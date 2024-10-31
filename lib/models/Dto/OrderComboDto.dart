class Ordercombodto {
  String? paymentMethod;
  int? comboId;
  List<int>? drinkIds;
  int? storeId;
  int? quantity;
  String? size;
  String? deliveryAddress;
  double? latitude;
  double? longitude;

  Ordercombodto({
    this.paymentMethod,
    this.comboId,
    this.drinkIds,
    this.storeId,
    this.quantity,
    this.size,
    this.deliveryAddress,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymentMethod'] = this.paymentMethod;
    data['comboId'] = this.comboId;
    data['drinkId'] = this.drinkIds;
    data['storeId'] = this.storeId;
    data['quantity'] = this.quantity;
    data['size'] = this.size;
    data['deliveryAddress'] = this.deliveryAddress;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
