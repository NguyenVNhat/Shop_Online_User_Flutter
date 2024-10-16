class Cartmodel {
  bool? status;
  String? message;
  List<CartData>? data = [];
  List<CartData>? get getdata => data;

  Cartmodel({this.status, this.message, this.data});

  Cartmodel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CartData>[];
      json['data'].forEach((v) {
        data!.add(new CartData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartData {
  int? cartId;
  String? type;
  ProductInCart? product;
  ComboInCart? combo;

  CartData({this.cartId, this.type, this.product, this.combo});

  CartData.fromJson(Map<String, dynamic> json) {
    cartId = json['cartId'];
    type = json['type'];
    product = json['product'] != null
        ? new ProductInCart.fromJson(json['product'])
        : null;
    combo =
        json['combo'] != null ? new ComboInCart.fromJson(json['combo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cartId'] = this.cartId;
    data['type'] = this.type;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    data['combo'] = this.combo;
    return data;
  }
}

class ProductInCart {
  int? userId;
  int? productId;
  String? productName;
  String? image;
  int? quantity;
  double? unitPrice;
  double? totalPrice;
  int? storeId;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? size;
  ProductInCart(
      {this.userId,
      this.productId,
      this.productName,
      this.image,
      this.quantity,
      this.unitPrice,
      this.totalPrice,
      this.storeId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.size});

  ProductInCart.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    productId = json['productId'];
    productName = json['productName'];
    image = json['image'];
    quantity = json['quantity'];
    unitPrice = json['unitPrice'];
    totalPrice = json['totalPrice'];
    storeId = json['storeId'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['image'] = this.image;
    data['quantity'] = this.quantity;
    data['unitPrice'] = this.unitPrice;
    data['totalPrice'] = this.totalPrice;
    data['storeId'] = this.storeId;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['size'] = this.size;
    return data;
  }
}

class ComboInCart {
  int? userId;
  int? comboId;
  String? comboName;
  String? image;
  int? quantity;
  double? unitPrice;
  double? totalPrice;
  int? storeId;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? size;
  ComboInCart(
      {this.userId,
      this.comboId,
      this.comboName,
      this.image,
      this.quantity,
      this.unitPrice,
      this.totalPrice,
      this.storeId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.size});

  ComboInCart.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    comboId = json['comboId'];
    comboName = json['comboName'];
    image = json['image'];
    quantity = json['quantity'];
    unitPrice = json['unitPrice'];
    totalPrice = json['totalPrice'];
    storeId = json['storeId'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['comboId'] = this.comboId;
    data['comboName'] = this.comboName;
    data['image'] = this.image;
    data['quantity'] = this.quantity;
    data['unitPrice'] = this.unitPrice;
    data['totalPrice'] = this.totalPrice;
    data['storeId'] = this.storeId;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['size'] = this.size;
    return data;
  }
}
