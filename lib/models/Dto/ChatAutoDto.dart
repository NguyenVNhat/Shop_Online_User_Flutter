class Chatautodto {
  int? storeId;
  String? question;

  Chatautodto({
    required this.storeId,
    required this.question,
  });
  
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data["storeId"] = this.storeId;
    data["question"] = this.question;
    return data;
  }
}