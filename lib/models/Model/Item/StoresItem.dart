class Storesitem {
  int? storeId;
  String? storeName;
  String? image;
  String? location;
  double? longitude;
  double? latitude;
  String? numberPhone;
  String? openingTime;
  String? closingTime;
  String? managerName;
  String? createdAt;
  String? updatedAt;

  Storesitem(
      {this.storeId,
      this.storeName,
      this.image,
      this.location,
      this.longitude,
      this.latitude,
      this.numberPhone,
      this.openingTime,
      this.closingTime,
      this.managerName,
      this.createdAt,
      this.updatedAt});

  Storesitem.fromJson(Map<String, dynamic> json) {
    storeId = json['storeId'];
    storeName = json['storeName'];
    image = json['image'];
    location = json['location'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    numberPhone = json['numberPhone'];
    openingTime = json['openingTime'];
    closingTime = json['closingTime'];
    managerName = json['managerName'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['storeId'] = this.storeId;
    data['storeName'] = this.storeName;
    data['image'] = this.image;
    data['location'] = this.location;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['numberPhone'] = this.numberPhone;
    data['openingTime'] = this.openingTime;
    data['closingTime'] = this.closingTime;
    data['managerName'] = this.managerName;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
