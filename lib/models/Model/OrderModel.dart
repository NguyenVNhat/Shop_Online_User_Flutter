class Ordermodel {
  bool? status;
  String? message;
  List<OrderItem>? orderitem = [];
  List<OrderItem>? get getorderitem => orderitem;

  Ordermodel({this.status, this.message, this.orderitem});

  Ordermodel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      orderitem = <OrderItem>[];
      json['data'].forEach((v) {
        orderitem!.add(new OrderItem.fromJson(v));
      });
    }
  }
  Ordermodel.fromAJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      orderitem = <OrderItem>[];
      orderitem!.add(new OrderItem.fromJson(json['data']));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.orderitem != null) {
      data['data'] = this.orderitem!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class OrderItem {
 int? orderId;
  String? orderCode;
  int? userId;
  String? orderDate;
  double? totalAmount;
  String? status;
  String? deliveryAddress;
  String? createdAt;
  String? updatedAt;
  bool? feedback;
  List<OrderDetails>? orderDetails;

  OrderItem(
      {this.orderId,
      this.orderCode,
      this.userId,
      this.orderDate,
      this.totalAmount,
      this.status,
      this.deliveryAddress,
      this.createdAt,
      this.updatedAt,
      this.feedback,
      this.orderDetails});

  OrderItem.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    orderCode = json['orderCode'];
    userId = json['userId'];
    orderDate = json['orderDate'];
    totalAmount = json['totalAmount'];
    status = json['status'];
    deliveryAddress = json['deliveryAddress'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    feedback = json['feedback'];
    if (json['orderDetails'] != null) {
      orderDetails = <OrderDetails>[];
      json['orderDetails'].forEach((v) {
        orderDetails!.add(new OrderDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['orderCode'] = this.orderCode;
    data['userId'] = this.userId;
    data['orderDate'] = this.orderDate;
    data['totalAmount'] = this.totalAmount;
    data['status'] = this.status;
    data['deliveryAddress'] = this.deliveryAddress;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['feedback'] = this.feedback;
    if (this.orderDetails != null) {
      data['orderDetails'] = this.orderDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderDetails {
  String? type;
  ProductDetail? productDetail;
  ComboDetail? comboDetail;

  OrderDetails({this.type, this.productDetail, this.comboDetail});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    productDetail = json['productDetail'] != null
        ? new ProductDetail.fromJson(json['productDetail'])
        : null;
     comboDetail = json['comboDetail'] != null
        ? new ComboDetail.fromJson(json['comboDetail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.productDetail != null) {
      data['productDetail'] = this.productDetail!.toJson();
    }
     if (this.comboDetail != null) {
      data['comboDetail'] = this.comboDetail!.toJson();
    }
    return data;
  }
}
class ProductDetail {
  int? orderDetailId;
  int? productId;
  String? productName;
  String? description;
  String? productImage;
  String? category;
  int? quantity;
  double? unitPrice;
  double? totalPrice;
  String? size;
  String? drinkId;
  int? storeId;
  String? status;
  bool? bestSeller;

  ProductDetail(
      {this.orderDetailId,
      this.productId,
      this.productName,
      this.description,
      this.productImage,
      this.category,
      this.quantity,
      this.unitPrice,
      this.totalPrice,
      this.size,
      this.drinkId,
      this.storeId,
      this.status,
      this.bestSeller});

  ProductDetail.fromJson(Map<String, dynamic> json) {
    orderDetailId = json['orderDetailId'];
    productId = json['productId'];
    productName = json['productName'];
    description = json['description'];
    productImage = json['productImage'];
    category = json['category'];
    quantity = json['quantity'];
    unitPrice = json['unitPrice'];
    totalPrice = json['totalPrice'];
    size = json['size'];
    drinkId = json['drinkId'];
    storeId = json['storeId'];
    status = json['status'];
    bestSeller = json['bestSeller'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderDetailId'] = this.orderDetailId;
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['description'] = this.description;
    data['productImage'] = this.productImage;
    data['category'] = this.category;
    data['quantity'] = this.quantity;
    data['unitPrice'] = this.unitPrice;
    data['totalPrice'] = this.totalPrice;
    data['size'] = this.size;
    data['drinkId'] = this.drinkId;
    data['storeId'] = this.storeId;
    data['status'] = this.status;
    data['bestSeller'] = this.bestSeller;
    return data;
  }
}
class ComboDetail {
 int? orderDetailId;
  int? comboId;
  int? quantity;
  double? unitPrice;
  double? totalPrice;
  String? size;
  String? drinkId;
  int? storeId;
  String? status;

  ComboDetail(
      {this.orderDetailId,
      this.quantity,
      this.unitPrice,
      this.totalPrice,
      this.size,
      this.drinkId,
      this.storeId,
      this.status,
      });

  ComboDetail.fromJson(Map<String, dynamic> json) {
    orderDetailId = json['orderDetailId'];
    comboId = json['comboId'];
    quantity = json['quantity'];
    unitPrice = json['unitPrice'];
    totalPrice = json['totalPrice'];
    size = json['size'];
     drinkId = json['drinkId'];
    storeId = json['storeId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderDetailId'] = this.orderDetailId;
    data['comboId'] = this.comboId;
    data['quantity'] = this.quantity;
    data['unitPrice'] = this.unitPrice;
    data['totalPrice'] = this.totalPrice;
    data['size'] = this.size;
    data['drinkId'] = this.drinkId;
    data['storeId'] = this.storeId;
    data['status'] = this.status;
    return data;
  }

}
