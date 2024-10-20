import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_user_github/data/controller/Auth_controller.dart';
import 'package:flutter_user_github/data/controller/Combo_controller.dart';
import 'package:flutter_user_github/data/controller/Order_controller.dart';
import 'package:flutter_user_github/data/controller/Product_controller.dart';
import 'package:flutter_user_github/models/Dto/CommentDto.dart';
import 'package:flutter_user_github/models/Model/Item/ComboItem.dart';
import 'package:flutter_user_github/models/Model/OrderModel.dart';
import 'package:flutter_user_github/page/order_page/order_footer.dart';
import 'package:flutter_user_github/page/order_page/order_header.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({
    Key? key,
  }) : super(key: key);
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  bool isChildVisible = false;
  TextEditingController feedbackController = TextEditingController();
  ProductController productController = Get.find<ProductController>();
  OrderController orderController = Get.find<OrderController>();
  OverlayEntry? overlayEntry;

  void showPopover(BuildContext context, Offset offset, String message) {
    OverlayState? overlayState = Overlay.of(context);

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + 10,
        left: offset.dx - 30,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
            width: AppDimention.size100,
            child: Center(
                child: Text(
              message,
              style: TextStyle(color: Colors.grey),
            )),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry!);
    Future.delayed(Duration(milliseconds: 500), () {
      overlayEntry?.remove();
    });
  }

  String _selectedRating = "5 sao";
  void _ShowFeedBack(OrderItem item) {
    List<OrderDetails>? orderDetails = item.orderDetails;

    List<int> listIdProduct = [];
    for (OrderDetails orderdetail in orderDetails!) {
      if (orderdetail.type == "product") {
        listIdProduct.add(orderdetail.productDetail!.productId!);
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: AppDimention.screenWidth,
                height: AppDimention.size100 * 3.7,
                padding: EdgeInsets.all(AppDimention.size20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text("Đánh giá"),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Radio(
                              value: "1 sao",
                              groupValue: _selectedRating,
                              onChanged: (value) {
                                setState(() {
                                  _selectedRating = value.toString();
                                });
                              },
                            ),
                            Row(
                              children: [
                                Text("1"),
                                Icon(
                                  Icons.star,
                                  color: AppColor.mainColor,
                                  size: 10,
                                )
                              ],
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Radio(
                              value: "2 sao",
                              groupValue: _selectedRating,
                              onChanged: (value) {
                                setState(() {
                                  _selectedRating = value.toString();
                                });
                              },
                            ),
                            Row(
                              children: [
                                Text("2"),
                                Icon(
                                  Icons.star,
                                  color: AppColor.mainColor,
                                  size: 10,
                                )
                              ],
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Radio(
                              value: "3 sao",
                              groupValue: _selectedRating,
                              onChanged: (value) {
                                setState(() {
                                  _selectedRating = value.toString();
                                });
                              },
                            ),
                            Row(
                              children: [
                                Text("3"),
                                Icon(
                                  Icons.star,
                                  color: AppColor.mainColor,
                                  size: 10,
                                )
                              ],
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Radio(
                              value: "4 sao",
                              groupValue: _selectedRating,
                              onChanged: (value) {
                                setState(() {
                                  _selectedRating = value.toString();
                                });
                              },
                            ),
                            Row(
                              children: [
                                Text("4"),
                                Icon(
                                  Icons.star,
                                  color: AppColor.mainColor,
                                  size: 10,
                                )
                              ],
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Radio(
                              value: "5 sao",
                              groupValue: _selectedRating,
                              onChanged: (value) {
                                setState(() {
                                  _selectedRating = value.toString();
                                });
                              },
                            ),
                            Row(
                              children: [
                                Text("5"),
                                Icon(
                                  Icons.star,
                                  color: AppColor.mainColor,
                                  size: 10,
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppDimention.size20,
                    ),
                    Container(
                      width: AppDimention.size100 * 3,
                      height: AppDimention.size100 * 3 * 0.4,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black26),
                        borderRadius:
                            BorderRadius.circular(AppDimention.size10),
                      ),
                      child: TextField(
                        controller: feedbackController,
                        maxLines: null,
                        expands: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(AppDimention.size10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppDimention.size20,
                    ),
                    Center(
                        child: GestureDetector(
                      onTap: () {
                        _sendFeedBack(listIdProduct, item.orderId!);
                      },
                      child: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                            color: AppColor.mainColor,
                            borderRadius:
                                BorderRadius.circular(AppDimention.size10)),
                        child: Center(
                          child: Text(
                            "Gửi",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ))
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _ShowCancelOrder(String ordercode,String status) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: AppDimention.screenWidth,
                height: AppDimention.size100 * 1.6,
                padding: EdgeInsets.all(AppDimention.size20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(children: [
                  Container(
                    width: AppDimention.screenWidth,
                    padding: EdgeInsets.all(AppDimention.size10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(width: 1, color: Colors.black26))),
                    child: Text("Xác nhận hủy đơn hàng"),
                  ),
                  SizedBox(
                    height: AppDimention.size20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                        Navigator.of(context).pop(); 
                        },
                        child: Container(
                          width: AppDimention.size120,
                          height: AppDimention.size50,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: AppColor.mainColor),
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size5)),
                          child: Center(
                            child: Text("Thoát"),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _cancelOrder(ordercode,status);
                          Navigator.of(context).pop(); 
                        },
                        child: Container(
                          width: AppDimention.size120,
                          height: AppDimention.size50,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: AppColor.mainColor),
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size5)),
                          child: Center(
                            child: Text("Xác nhận"),
                          ),
                        ),
                      )
                    ],
                  ),
                ]),
              );
            },
          ),
        );
      },
    );
  }

  void _sendFeedBack(List<int> listIdProduct, int orderid) {
    List<String> rate = _selectedRating.split("");
    String feedbackMessage = feedbackController.text;

    for (int id in listIdProduct) {
      Commentdto commentdto = Commentdto(
          productId: id, comment: feedbackMessage, rate: int.parse(rate[0]));
      productController.addcomment(commentdto);
    }
    orderController.updatefeedback(orderid);

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => OrderPage(),
    ));
  }

  void _toggleBar() {
    if (isShowBar) {
      Future.delayed(Duration(milliseconds: 200), () {
        setState(() {
          isChildVisible = true;
        });
      });
    } else {
      setState(() {
        isChildVisible = false;
      });
    }
  }

  String? selectedStatus = "All";

  AuthController? authController = Get.find<AuthController>();
  @override
  void initState() {
    super.initState();
    if (authController!.IsLogin.value) orderController.getall();
  }

  bool isShowBar = false;

  void _cancelOrder(String ordercode,String status) {
    orderController.cancelorder(ordercode,status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          OrderHeader(),
          Obx(() {
            if (!authController!.IsLogin.value) {
              return Container(
                width: AppDimention.screenWidth,
                height: AppDimention.screenHeight - AppDimention.size120,
                child: Center(
                    child: GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoute.LOGIN_PAGE);
                  },
                  child: Center(
                    child: Text("Vui lòng đăng nhập"),
                  ),
                )),
              );
            } else {
              return Expanded(
                  child: Stack(children: [
                Positioned(child: SingleChildScrollView(
                  child: GetBuilder<OrderController>(
                    builder: (orderController) {
                      return !orderController.isLoading
                          ?  orderController
                                    .orderlist.length == 0 ? Container(
                                    width: AppDimention.screenWidth,
                                    padding: EdgeInsets.only(top: AppDimention.size40),
                                    height: 200,
                                    
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("Bạn không có đơn hàng nào"),
                                          SizedBox(height: AppDimention.size10,),
                                          GestureDetector(
                                            onTap: (){
                                              Get.toNamed(AppRoute.SEARCH_PAGE);
                                            },
                                            child: Container(
                                            width: AppDimention.size120,
                                            height: AppDimention.size40,
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 1,color: AppColor.mainColor),
                                              borderRadius: BorderRadius.circular(AppDimention.size10)
                                            ),
                                            child: Center(
                                              child: Text("Mua hàng"),
                                            ),
                                          ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ) : ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              reverse: true,
                              itemCount: orderController.orderlist.length,
                              itemBuilder: (context, index) {
                                var orderDetails = orderController
                                    .orderlist[index].orderDetails;
                                if (orderDetails == null ||
                                    orderDetails.isEmpty) {
                                  return Container(
                                    width: AppDimention.screenWidth,
                                    height: 200,
                                    decoration: BoxDecoration(
                                        color: AppColor.yellowColor),
                                    child: Center(
                                      child: Text("Bạn không có đơn hàng nào"),
                                    ),
                                  );
                                }
                                return Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: AppDimention.size10,
                                        horizontal: AppDimention.size10,
                                      ),
                                      padding:
                                          EdgeInsets.all(AppDimention.size10),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                              AppDimention.size10),
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.grey
                                                  .withOpacity(0.2))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              height: AppDimention.size60,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      'Mã đơn hàng : ${orderController.orderlist[index].orderCode}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.5))),
                                                  GestureDetector(
                                                    onTap: () {
                                                      if(orderController.orderlist[index].status != "Đơn hàng đã bị hủy"){
                                                      Get.toNamed(AppRoute
                                                          .get_order_detail(
                                                              orderController
                                                                  .orderlist[
                                                                      index]
                                                                  .orderCode!));
                                                      }
                                                    },
                                                    child: Container(
                                                      width:
                                                          AppDimention.size100,
                                                      height:
                                                          AppDimention.size30,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors
                                                                  .black12,
                                                              width: 1),
                                                          color: orderController
                                                                      .orderlist[
                                                                          index]
                                                                      .status ==
                                                                  "Đơn hàng đã bị hủy"
                                                              ? AppColor
                                                                  .mainColor
                                                              : Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Center(
                                                        child: Text(
                                                          "${orderController.orderlist[index].status == "Đơn hàng đã bị hủy" ? "Đã hủy " : "Chi tiết"}",
                                                          style: TextStyle(
                                                              color: orderController
                                                                          .orderlist[
                                                                              index]
                                                                          .status ==
                                                                      "Đơn hàng đã bị hủy"
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          Column(
                                            children: orderDetails
                                                .map<Widget>((detail) {
                                              ProductDetail? productOrder;
                                              ComboDetail? comboOrder;
                                              Comboitem? comboitem;
                                              if (detail.type == "product")
                                                productOrder =
                                                    detail.productDetail != null
                                                        ? detail.productDetail
                                                        : null;
                                              else {
                                                comboOrder =
                                                    detail.comboDetail != null
                                                        ? detail.comboDetail
                                                        : null;
                                                comboitem =
                                                    Get.find<ComboController>()
                                                        .getcombobyId(
                                                            comboOrder!
                                                                .comboId!);
                                              }

                                              bool key = productOrder != null;
                                              Uint8List decodeImage() {
                                                if (key) {
                                                  return base64Decode(
                                                      productOrder!
                                                          .productImage!);
                                                } else {
                                                  return base64Decode(
                                                      comboitem!.image!);
                                                }
                                              }

                                              return Container(
                                                  padding: EdgeInsets.only(
                                                      top: AppDimention.size10,
                                                      left: AppDimention.size10,
                                                      bottom:
                                                          AppDimention.size20,
                                                      right:
                                                          AppDimention.size10),
                                                  width:
                                                      AppDimention.screenWidth,
                                                  margin: EdgeInsets.only(
                                                      top: AppDimention.size10),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              AppDimention
                                                                  .size10)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "Sản phẩm : ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black38),
                                                              ),
                                                              Text(
                                                                key
                                                                    ? productOrder
                                                                        .productName!
                                                                    : comboitem!
                                                                        .comboName!,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            AppDimention.size10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "Số lượng : ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black38),
                                                              ),
                                                              Text(
                                                                key
                                                                    ? productOrder
                                                                        .quantity
                                                                        .toString()
                                                                    : comboOrder!
                                                                        .quantity
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black38,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            "đ${key ? productOrder.totalPrice!.toInt() : comboOrder!.totalPrice!.toInt()}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ));
                                            }).toList(),
                                          ),
                                          Container(
                                            width: AppDimention.screenWidth,
                                            padding: EdgeInsets.only(
                                              top: AppDimention.size10,
                                            ),
                                            child: Row(
                                              children: [
                                                if (orderController
                                                        .orderlist[index]
                                                        .status ==
                                                    "Đơn hàng mới")
                                                  Container(
                                                      width:
                                                          AppDimention.size100 *
                                                              3.4,
                                                      height:
                                                          AppDimention.size30,
                                                      child: Stack(
                                                        children: [
                                                          Positioned(
                                                            left: 10,
                                                            top: 10,
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  width: AppDimention
                                                                      .size110,
                                                                  height:
                                                                      AppDimention
                                                                          .size5,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                                Container(
                                                                  width: AppDimention
                                                                      .size110,
                                                                  height:
                                                                      AppDimention
                                                                          .size5,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                                Container(
                                                                  width: AppDimention
                                                                      .size110,
                                                                  height:
                                                                      AppDimention
                                                                          .size5,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                                Container(
                                                                  width: AppDimention
                                                                      .size110,
                                                                  height:
                                                                      AppDimention
                                                                          .size5,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTapDown:
                                                                (details) {
                                                              showPopover(
                                                                  context,
                                                                  details
                                                                      .globalPosition,
                                                                  "Đơn hàng mới");
                                                            },
                                                            child: Icon(
                                                              Icons.circle,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                          )
                                                        ],
                                                      ))
                                                else if (orderController
                                                        .orderlist[index]
                                                        .status ==
                                                    "Đơn hàng đã được xác nhận")
                                                  Container(
                                                      width:
                                                          AppDimention.size100 *
                                                              3.4,
                                                      height:
                                                          AppDimention.size30,
                                                      child: Stack(
                                                        children: [
                                                          Positioned(
                                                            left: 10,
                                                            top: 10,
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  width: AppDimention
                                                                      .size110,
                                                                  height:
                                                                      AppDimention
                                                                          .size5,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                                Container(
                                                                  width: AppDimention
                                                                      .size110,
                                                                  height:
                                                                      AppDimention
                                                                          .size5,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                                Container(
                                                                  width: AppDimention
                                                                      .size110,
                                                                  height:
                                                                      AppDimention
                                                                          .size5,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Positioned(
                                                            left: 0,
                                                            top: 0,
                                                            child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTapDown:
                                                                      (details) {
                                                                    showPopover(
                                                                        context,
                                                                        details
                                                                            .globalPosition,
                                                                        "Đơn hàng mới");
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .circle,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Positioned(
                                                            left: AppDimention
                                                                .size110,
                                                            top: 0,
                                                            child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTapDown:
                                                                      (details) {
                                                                    showPopover(
                                                                        context,
                                                                        details
                                                                            .globalPosition,
                                                                        "Đã xác nhận");
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .circle,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ))
                                                else if (orderController
                                                        .orderlist[index]
                                                        .status ==
                                                    "Đơn hàng đang giao")
                                                  Container(
                                                      width:
                                                          AppDimention.size100 *
                                                              3.4,
                                                      height:
                                                          AppDimention.size30,
                                                      child: Stack(
                                                        children: [
                                                          Positioned(
                                                            left: 10,
                                                            top: 10,
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  width: AppDimention
                                                                      .size110,
                                                                  height:
                                                                      AppDimention
                                                                          .size5,
                                                                  color: Colors
                                                                      .amber,
                                                                ),
                                                                Container(
                                                                  width: AppDimention
                                                                      .size110,
                                                                  height:
                                                                      AppDimention
                                                                          .size5,
                                                                  color: Colors
                                                                      .amber,
                                                                ),
                                                                Container(
                                                                  width: AppDimention
                                                                      .size110,
                                                                  height:
                                                                      AppDimention
                                                                          .size5,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Positioned(
                                                            left: 0,
                                                            top: 0,
                                                            child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTapDown:
                                                                      (details) {
                                                                    showPopover(
                                                                        context,
                                                                        details
                                                                            .globalPosition,
                                                                        "Đơn hàng mới");
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .circle,
                                                                    color: Colors
                                                                        .amber,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Positioned(
                                                            left: AppDimention
                                                                .size110,
                                                            top: 0,
                                                            child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTapDown:
                                                                      (details) {
                                                                    showPopover(
                                                                        context,
                                                                        details
                                                                            .globalPosition,
                                                                        "Đã xác nhận");
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .circle,
                                                                    color: Colors
                                                                        .amber,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Positioned(
                                                            left: AppDimention
                                                                    .size110 *
                                                                2,
                                                            top: 0,
                                                            child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTapDown:
                                                                      (details) {
                                                                    showPopover(
                                                                        context,
                                                                        details
                                                                            .globalPosition,
                                                                        "Đang giao");
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .circle,
                                                                    color: Colors
                                                                        .amber,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ))
                                                else if (orderController
                                                        .orderlist[index]
                                                        .status ==
                                                    "Đơn hàng đã hoàn thành")
                                                  Container(
                                                      width:
                                                          AppDimention.size100 *
                                                              3.40,
                                                      height:
                                                          AppDimention.size30,
                                                      child: Stack(
                                                        children: [
                                                          Positioned(
                                                            left: 10,
                                                            top: 10,
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  width: AppDimention
                                                                      .size100,
                                                                  height:
                                                                      AppDimention
                                                                          .size5,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                                Container(
                                                                  width: AppDimention
                                                                      .size100,
                                                                  height:
                                                                      AppDimention
                                                                          .size5,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                                Container(
                                                                  width: AppDimention
                                                                      .size110,
                                                                  height:
                                                                      AppDimention
                                                                          .size5,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Positioned(
                                                            left: 0,
                                                            top: 0,
                                                            child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTapDown:
                                                                      (details) {
                                                                    showPopover(
                                                                        context,
                                                                        details
                                                                            .globalPosition,
                                                                        "Đã hoàn thành");
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .circle,
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Positioned(
                                                            right: 10,
                                                            top: 0,
                                                            child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTapDown:
                                                                      (details) {
                                                                    showPopover(
                                                                        context,
                                                                        details
                                                                            .globalPosition,
                                                                        "Đã hoàn thành");
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .circle,
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ))
                                              ],
                                            ),
                                          ),
                                          if (orderController
                                                  .orderlist[index].status
                                                  .toString() ==
                                              "Đơn hàng mới")
                                            if (!orderController
                                                .orderlist[index].feedback!)
                                              Container(
                                                  width:
                                                      AppDimention.screenWidth,
                                                  margin: EdgeInsets.only(
                                                      left: AppDimention.size10,
                                                      right:
                                                          AppDimention.size10),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      _ShowCancelOrder(
                                                          orderController
                                                              .orderlist[index]
                                                              .orderCode!, orderController
                                                              .orderlist[index]
                                                              .status!);
                                                    },
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Container(
                                                            width: AppDimention
                                                                .size100,
                                                            height: AppDimention
                                                                .size40,
                                                            decoration: BoxDecoration(
                                                                color: AppColor
                                                                    .mainColor,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        AppDimention
                                                                            .size5)),
                                                            child: Center(
                                                              child: Text(
                                                                "Hủy đơn",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                  )),
                                          Row(
                                            children: [
                                              if (orderController
                                                          .orderlist[index]
                                                          .status ==
                                                      "Đơn hàng đã bị hủy" ||
                                                  orderController
                                                          .orderlist[index]
                                                          .status ==
                                                      "Đơn hàng đã hoàn thành")
                                                GestureDetector(
                                                  onTap: () {
                                                    
                                                  },
                                                  child: Container(
                                                    width: AppDimention.size100,
                                                    height: AppDimention.size30,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.black12,
                                                            width: 1),
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Center(
                                                      child: Text(
                                                        "Mua lại",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              if (orderController
                                                      .orderlist[index].status
                                                      .toString() ==
                                                  "Đơn hàng đã hoàn thành")
                                                if (!orderController
                                                    .orderlist[index].feedback!)
                                                  Container(
                                                      width: AppDimention
                                                          .screenWidth,
                                                      margin: EdgeInsets.only(
                                                          left: AppDimention
                                                              .size10,
                                                          right: AppDimention
                                                              .size10),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          _ShowFeedBack(
                                                            orderController
                                                                    .orderlist[
                                                                index],
                                                          );
                                                        },
                                                        child: Container(
                                                          width: AppDimention
                                                              .size100,
                                                          height: AppDimention
                                                              .size40,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.blue,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      AppDimention
                                                                          .size5)),
                                                          child: Center(
                                                            child: Text(
                                                              "Đánh giá",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )
                          : CircularProgressIndicator();
                    },
                  ),
                )),
                GetBuilder<OrderController>(builder: (orderController) {
                  return !orderController.isLoading
                      ? Positioned(
                          top: AppDimention.size10,
                          left: AppDimention.size10,
                          width: AppDimention.size100 * 1.8,
                          height: AppDimention.size100 * 6,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                left: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isShowBar = !isShowBar;
                                      _toggleBar();
                                    });
                                  },
                                  child: AnimatedRotation(
                                    turns: isShowBar ? 1.0 : 0.0,
                                    duration: Duration(milliseconds: 500),
                                    child: Icon(
                                      Icons.add_circle,
                                      size: AppDimention.size50,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                              ),
                              AnimatedPositioned(
                                left: 0,
                                top: AppDimention.size50,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.fastOutSlowIn,
                                child: AnimatedContainer(
                                  width: AppDimention.size100 * 1.7,
                                  padding: EdgeInsets.all(AppDimention.size10),
                                  height: isShowBar
                                      ? AppDimention.size100 * 3.5
                                      : 0,
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(
                                          AppDimention.size10)),
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.fastOutSlowIn,
                                  child: isChildVisible
                                      ? Container(
                                          width: AppDimention.size100 * 1.7,
                                          child: Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Get.find<OrderController>()
                                                      .getall();
                                                  setState(() {
                                                    selectedStatus = "All";
                                                  });
                                                },
                                                child: AnimatedContainer(
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.easeInOut, //
                                                  width: AppDimention.size150,
                                                  padding: EdgeInsets.all(
                                                      AppDimention.size15),
                                                  decoration: BoxDecoration(
                                                      color: selectedStatus ==
                                                              "All"
                                                          ? Colors.white
                                                          : Colors.transparent,
                                                      border: Border(
                                                        bottom: BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              AppDimention
                                                                  .size10)),
                                                  child: Center(
                                                    child: Text(
                                                      "Tất cả",
                                                      style: TextStyle(
                                                        color: selectedStatus ==
                                                                "All"
                                                            ? Colors.green
                                                            : Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Get.find<OrderController>()
                                                      .getorderWithStatus(
                                                          "Đơn hàng mới");
                                                  setState(() {
                                                    selectedStatus =
                                                        "Đơn hàng mới";
                                                  });
                                                },
                                                child: AnimatedContainer(
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.easeInOut, //
                                                  width: AppDimention.size150,
                                                  padding: EdgeInsets.all(
                                                      AppDimention.size15),
                                                  decoration: BoxDecoration(
                                                      color: selectedStatus ==
                                                              "Đơn hàng mới"
                                                          ? Colors.white
                                                          : Colors.transparent,
                                                      border: Border(
                                                        bottom: BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              AppDimention
                                                                  .size10)),
                                                  child: Center(
                                                    child: Text(
                                                      "Đơn hàng mới",
                                                      style: TextStyle(
                                                        color: selectedStatus ==
                                                                "Đơn hàng mới"
                                                            ? Colors.green
                                                            : Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Get.find<OrderController>()
                                                      .getorderWithStatus(
                                                          "Đơn hàng đã được xác nhận");
                                                  setState(() {
                                                    selectedStatus =
                                                        "Đơn hàng đã được xác nhận";
                                                  });
                                                },
                                                child: AnimatedContainer(
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.easeInOut,
                                                  width: AppDimention.size150,
                                                  padding: EdgeInsets.all(
                                                      AppDimention.size15),
                                                  decoration: BoxDecoration(
                                                      color: selectedStatus ==
                                                              "Đơn hàng đã được xác nhận"
                                                          ? Colors.white
                                                          : Colors.transparent,
                                                      border: Border(
                                                        bottom: BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              AppDimention
                                                                  .size10)),
                                                  child: Center(
                                                    child: Text(
                                                      "Đã xác nhận",
                                                      style: TextStyle(
                                                        color: selectedStatus ==
                                                                "Đơn hàng đã được xác nhận"
                                                            ? Colors.black
                                                            : Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Get.find<OrderController>()
                                                      .getorderWithStatus(
                                                          "Đơn hàng đang giao");
                                                  setState(() {
                                                    selectedStatus =
                                                        "Đơn hàng đang giao";
                                                  });
                                                },
                                                child: AnimatedContainer(
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.easeInOut,
                                                  width: AppDimention.size150,
                                                  padding: EdgeInsets.all(
                                                      AppDimention.size15),
                                                  decoration: BoxDecoration(
                                                      color: selectedStatus ==
                                                              "Đơn hàng đang giao"
                                                          ? Colors.white
                                                          : Colors.transparent,
                                                      border: Border(
                                                        bottom: BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              AppDimention
                                                                  .size10)),
                                                  child: Center(
                                                    child: Text(
                                                      "Đang giao",
                                                      style: TextStyle(
                                                        color: selectedStatus ==
                                                                "Đơn hàng đang giao"
                                                            ? Colors.yellow
                                                            : Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Get.find<OrderController>()
                                                      .getorderWithStatus(
                                                          "Đơn hàng đã hoàn thành");
                                                  setState(() {
                                                    selectedStatus =
                                                        "Đơn hàng đã hoàn thành";
                                                  });
                                                },
                                                child: AnimatedContainer(
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.easeInOut,
                                                  width: AppDimention.size150,
                                                  padding: EdgeInsets.all(
                                                      AppDimention.size15),
                                                  decoration: BoxDecoration(
                                                      color: selectedStatus ==
                                                              "Đơn hàng đã hoàn thành"
                                                          ? Colors.white
                                                          : Colors.transparent,
                                                      border: Border(
                                                        bottom: BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              AppDimention
                                                                  .size10)),
                                                  child: Center(
                                                    child: Text(
                                                      "Hoàn thành",
                                                      style: TextStyle(
                                                        color: selectedStatus ==
                                                                "Đơn hàng đã hoàn thành"
                                                            ? Colors.black
                                                            : Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Get.find<OrderController>()
                                                      .getorderWithStatus(
                                                          "Đơn hàng đã bị hủy");
                                                  setState(() {
                                                    selectedStatus =
                                                        "Đơn hàng đã bị hủy";
                                                  });
                                                },
                                                child: AnimatedContainer(
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.easeInOut,
                                                  width: AppDimention.size150,
                                                  padding: EdgeInsets.all(
                                                      AppDimention.size15),
                                                  decoration: BoxDecoration(
                                                      color: selectedStatus ==
                                                              "Đơn hàng đã bị hủy"
                                                          ? Colors.white
                                                          : Colors.transparent,
                                                      border: Border(
                                                        bottom: BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              AppDimention
                                                                  .size10)),
                                                  child: Center(
                                                    child: Text(
                                                      "Bị hủy",
                                                      style: TextStyle(
                                                        color: selectedStatus ==
                                                                "Đơn hàng đã bị hủy"
                                                            ? Colors.black
                                                            : Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container();
                })
              ]));
            }
          }),
          OrderFooter()
        ],
      ),
    );
  }
}
