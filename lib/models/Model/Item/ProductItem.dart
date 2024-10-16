import 'package:flutter_user_github/models/Model/Item/CategoryItem.dart';
import 'package:flutter_user_github/models/Model/Item/StoresItem.dart';

class Productitem {
  int? productId;
  String? productName;
  String? image;
  String? description;
  double? price;
  double? discountedPrice;
  double? averageRate;
  Categoryitem? category;
  List<Storesitem>? stores;
  int? stockQuantity;
  String? createdAt;
  String? updatedAt;
  bool? bestSale;

  Productitem(
      {this.productId,
      this.productName,
      this.image,
      this.description,
      this.price,
      this.discountedPrice,
      this.averageRate,
      this.category,
      this.stores,
      this.stockQuantity,
      this.createdAt,
      this.updatedAt,
      this.bestSale});

  Productitem.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    image = json['image'];
    description = json['description'];
    price = json['price'];
    discountedPrice = json['discountedPrice'];
    averageRate = json['averageRate'];
    category = json['category'] != null
        ? new Categoryitem.fromJson(json['category'])
        : null;
    if (json['stores'] != null) {
      stores = <Storesitem>[];
      json['stores'].forEach((v) {
        stores!.add(new Storesitem.fromJson(v));
      });
    }
    stockQuantity = json['stockQuantity'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    bestSale = json['bestSale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['image'] = this.image;
    data['description'] = this.description;
    data['price'] = this.price;
    data['discountedPrice'] = this.discountedPrice;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.stores != null) {
      data['stores'] = this.stores!.map((v) => v.toJson()).toList();
    }
    data['stockQuantity'] = this.stockQuantity;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['bestSale'] = this.bestSale;
    return data;
  }
}
