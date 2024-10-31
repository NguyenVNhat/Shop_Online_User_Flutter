class Promotiondto {
  int? promotionId;
  int? storeId;
  Promotiondto({
    this.promotionId,
    this.storeId,
  });
   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["promotionId"] = this.promotionId;
    data["storeId"] = this.storeId;
    return data;
  }
}