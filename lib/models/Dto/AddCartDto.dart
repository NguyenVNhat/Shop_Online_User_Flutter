class AddcartDto {
  int? productId;
  int? quantity;
  String? size;
  int? storeId;

  AddcartDto({this.productId, this.quantity, this.size, this.storeId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['quantity'] = this.quantity;
    data['size'] = this.size;
    data['storeId'] = this.storeId;
    return data;
  }
}