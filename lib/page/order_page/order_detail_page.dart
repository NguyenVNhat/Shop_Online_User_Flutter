import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_user_github/data/controller/Combo_controller.dart';
import 'package:flutter_user_github/data/controller/Order_controller.dart';
import 'package:flutter_user_github/data/controller/Store_Controller.dart';
import 'package:flutter_user_github/models/Model/Item/ComboItem.dart';
import 'package:flutter_user_github/models/Model/OrderModel.dart';
import 'package:flutter_user_github/page/order_page/order_footer.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderCode;
  const OrderDetailPage({Key? key, required this.orderCode}) : super(key: key);
  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  void initState() {
    super.initState();
    Get.find<OrderController>().getorderbyOrdercode(widget.orderCode);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController) {
      return !orderController.isLoading
          ? Scaffold(
              backgroundColor: Colors.grey[200],
              resizeToAvoidBottomInset: false,
              body: Column(
                children: [
                  Container(
                    width: AppDimention.screenWidth,
                    height: AppDimention.size100,
                    padding: EdgeInsets.only(top: AppDimention.size40),
                    decoration: BoxDecoration(color: AppColor.mainColor),
                    child: Center(
                      child: Text("Chi tiết đơn hàng",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: AppDimention.size25,
                          )),
                    ),
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      children: [
                        GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.6,
                            ),
                            itemCount: orderController
                                .orderdetail?.orderDetails?.length,
                            itemBuilder: (context, index) {
                              OrderDetails detail = orderController
                                  .orderdetail!.orderDetails![index];

                              ProductDetail? productOrder;
                              ComboDetail? comboOrder;
                              Comboitem? comboitem;
                              if (detail.type == "product")
                                productOrder = detail.productDetail != null
                                    ? detail.productDetail
                                    : null;
                              else {
                                comboOrder = detail.comboDetail != null
                                    ? detail.comboDetail
                                    : null;
                                comboitem = Get.find<ComboController>()
                                    .getcombobyId(comboOrder!.comboId!);
                              }

                              bool key = productOrder != null;

                              Uint8List decodeImage() {
                                if (key) {
                                  return base64Decode(
                                      productOrder!.productImage!);
                                } else {
                                  return base64Decode(comboitem!.image!);
                                }
                              }

                              return GestureDetector(
                                  onTap: () {
                                    key
                                        ? Get.toNamed(
                                            AppRoute.get_product_detail(
                                                productOrder!.productId!))
                                        : Get.toNamed(
                                            AppRoute.get_combo_detail(index));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(AppDimention.size10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 1,
                                          color: Color.fromRGBO(
                                              218, 218, 218, 0.494)),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 170,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: MemoryImage(decodeImage()),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 170,
                                          padding: EdgeInsets.only(
                                              left: AppDimention.size10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: AppDimention.size5,
                                              ),
                                              Text(
                                                "[ ${index + 1} ] ${key ? productOrder.productName : comboitem!.comboName!}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColor.mainColor),
                                              ),
                                              Text(
                                                "${key ? productOrder.unitPrice : comboOrder!.unitPrice} vnđ",
                                                style: TextStyle(fontSize: 13),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Wrap(
                                                        children: List.generate(
                                                            5,
                                                            (index) => Icon(
                                                                Icons.star,
                                                                color: AppColor
                                                                    .mainColor,
                                                                size: 8)),
                                                      ),
                                                      Text(
                                                        "(5)",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: AppColor
                                                                .mainColor),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "1028",
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .chat_bubble_outline_rounded,
                                                        size: 12,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                  height: AppDimention.size15),
                                              Row(
                                                children: [
                                                  Icon(Icons
                                                      .delivery_dining_sharp),
                                                  Text(
                                                    "Miễn phí vận chuyển",
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ));
                            }),
                        GetBuilder<Storecontroller>(builder: (controller) {
                          OrderDetails detail =
                              orderController.orderdetail!.orderDetails![0];
                          ProductDetail? productOrder;
                          ComboDetail? comboOrder;
                          Comboitem? comboitem;
                          if (detail.type == "product")
                            productOrder = detail.productDetail != null
                                ? detail.productDetail
                                : null;
                          else {
                            comboOrder = detail.comboDetail != null
                                ? detail.comboDetail
                                : null;
                            comboitem = Get.find<ComboController>()
                                .getcombobyId(comboOrder!.comboId!);
                          }
                          bool key = productOrder != null;

                          return Container(
                            width: AppDimention.screenWidth,
                            padding: EdgeInsets.all(AppDimention.size10),
                            margin: EdgeInsets.only(
                                left: AppDimention.size10,
                                right: AppDimention.size10,
                                top: AppDimention.size20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(AppDimention.size5)),
                            child: Text(
                              "Địa chỉ cửa hàng : ${controller.addressOfStore(key ? productOrder.storeId! : comboOrder!.storeId!)}",
                              textAlign: TextAlign.start,
                            ),
                          );
                        }),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: orderController
                                .orderdetail?.orderDetails?.length,
                            itemBuilder: (context, index) {
                              OrderDetails detail =  orderController
                                  .orderdetail!.orderDetails![0];

                              ProductDetail? productOrder;
                                              ComboDetail? comboOrder;
                                              Comboitem? comboitem;
                                              if(detail.type== "product")
                                                productOrder = detail.productDetail != null ? detail.productDetail : null;
                                              else{
                                                comboOrder = detail.comboDetail != null ? detail.comboDetail : null;
                                                comboitem =Get.find<ComboController>().getcombobyId(comboOrder!.comboId!);
                                              }

                              
                              bool key = productOrder != null;
                            

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              AppDimention.size5)),
                                      margin: EdgeInsets.only(
                                          left: AppDimention.size10,
                                          right: AppDimention.size10,
                                          bottom: AppDimention.size10),
                                      padding:
                                          EdgeInsets.all(AppDimention.size10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (index != 0)
                                            SizedBox(
                                              height: AppDimention.size20,
                                            ),
                                          Text(
                                            "[ ${index + 1} ] ${key ? productOrder.productName : comboitem!.comboName}",
                                            style: TextStyle(
                                                fontSize: AppDimention.size20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: AppDimention.size10,
                                          ),
                                          Container(
                                            width: AppDimention.screenWidth -
                                                AppDimention.size40,
                                            height: AppDimention.size40,
                                            padding: EdgeInsets.only(
                                                top: AppDimention.size10),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        width: 1,
                                                        color:
                                                            Colors.black12))),
                                            child: Text(
                                                "Giá : ${key ? productOrder.unitPrice : comboOrder?.unitPrice} vnđ"),
                                          ),
                                          Container(
                                              width: AppDimention.screenWidth -
                                                  AppDimention.size40,
                                              height: AppDimention.size40,
                                              padding: EdgeInsets.only(
                                                  top: AppDimention.size10),
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          width: 1,
                                                          color:
                                                              Colors.black12))),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      "Tổng giá : ${key ? productOrder.totalPrice : comboOrder!.totalPrice} vnđ "),
                                                  Text(
                                                      "Size : ${key ? productOrder.size : comboOrder!.size} "),
                                                ],
                                              )),
                                        ],
                                      )),
                                ],
                              );
                            }),
                        SizedBox(
                          height: AppDimention.size30,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: AppDimention.size20),
                          width: AppDimention.screenWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Chi tiết",
                                  style: TextStyle(
                                    fontSize: AppDimention.size30,
                                  )),
                              Container(
                                width: AppDimention.screenWidth -
                                    AppDimention.size40,
                                height: AppDimention.size150 * 2,
                                padding: EdgeInsets.all(AppDimention.size20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        AppDimention.size10),
                                    border: Border.all(
                                        width: 1, color: Colors.black26)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Mã đơn hàng : ${orderController.orderdetail?.orderCode}"),
                                    SizedBox(
                                      height: AppDimention.size10,
                                    ),
                                    Text(
                                        "Tổng giá đơn hàng : ${orderController.orderdetail?.totalAmount} vnđ"),
                                    SizedBox(
                                      height: AppDimention.size10,
                                    ),
                                    Text(
                                        "Ngày đặt đơn : ${orderController.orderdetail?.orderDate}"),
                                    SizedBox(
                                      height: AppDimention.size10,
                                    ),
                                    Text(
                                        "Địa chỉ giao hàng : ${orderController.orderdetail?.deliveryAddress}"),
                                    SizedBox(
                                      height: AppDimention.size10,
                                    ),
                                    SizedBox(
                                      height: AppDimention.size10,
                                    ),
                                    Text(
                                        "Trạng thái đơn hàng : ${orderController.orderdetail?.status}"),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
                  OrderFooter()
                ],
              ),
            )
          : CircularProgressIndicator();
    });
  }
}
