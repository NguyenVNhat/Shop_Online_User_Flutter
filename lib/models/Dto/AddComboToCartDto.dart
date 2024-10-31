class Combotocartdto {
  int? comboId;
  int? quantity;
  int? storeId;
  String? size;
  String? status;
  List<int>? drinkId;
  Combotocartdto({
    this.comboId,
    this.drinkId,
    this.quantity,
    this.storeId,
  });
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comboId'] = this.comboId;
    data['quantity'] = this.quantity;
    data['size'] = "M";
    data['storeId'] = this.storeId;
    data['status'] = "Pending";
    data['drinkId'] = this.drinkId;
    return data;
  }
}
