import 'dart:convert';

import 'package:flutter_user_github/data/controller/Combo_controller.dart';
import 'package:flutter_user_github/data/controller/Product_controller.dart';
import 'package:flutter_user_github/data/controller/Size_controller.dart';
import 'package:flutter_user_github/models/Model/Item/ComboItem.dart';
import 'package:flutter_user_github/models/Model/Item/ProductItem.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ComboDetail extends StatefulWidget {
  final int comboId;
  const ComboDetail({Key? key, required this.comboId}) : super(key: key);

  @override
  _ComboDetailState createState() => _ComboDetailState();
}

class _ComboDetailState extends State<ComboDetail> {
   String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]}.',
        );
  }
  int selectSize = 1;

  ProductController productController = Get.find<ProductController>();
  ComboController comboController = Get.find<ComboController>();
  int? groupValue;
  int? comboprice;
  int? drinkprice = 0;
  List<Productitem>? listdrink;
  Comboitem? comboitem;

  bool? isloadedData = false;

  void onChanged(int? value, int price) {
    setState(() {
      groupValue = value;
      drinkprice = price;
    });
  }

  @override
  void initState() {
    super.initState();
    comboitem = comboController.getcombobyId(widget.comboId);
    listdrink = productController.getlistdrink();
    
    setState(() {
      isloadedData = true;
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ComboController>(builder: (comboControler) {

      return !isloadedData! ?CircularProgressIndicator() : Scaffold(
          body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            height: AppDimention.size100 * 3 - AppDimention.size30,
            width: AppDimention.screenWidth,
            child: Container(
              width: AppDimention.screenWidth,
              height: AppDimention.screenHeight,
              padding: EdgeInsets.all(AppDimention.size20),
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: MemoryImage(
                    base64Decode(comboitem!.image!),
                  ),
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5),
                    BlendMode.dstATop,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoute.CART_PAGE);
                        },
                        child: Icon(Icons.shopping_cart_outlined,
                            color: Colors.white, size: 30),
                      )
                    ],
                  ),
                  SizedBox(
                    height: AppDimention.size10,
                  ),
                  Text(
                    comboitem!.comboName!,
                    style: TextStyle(
                      fontSize: AppDimention.size40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                            blurRadius: AppDimention.size10,
                            offset: Offset(2.0, 2.0),
                            color: Colors.amber)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: AppDimention.size100 * 3 - AppDimention.size30,
            left: 0,
            child: Container(
              width: AppDimention.screenWidth,
              height: AppDimention.screenHeight - AppDimention.size100 * 2.7,
              color: const Color.fromARGB(106, 255, 255, 255),
              child: SingleChildScrollView(
                child: Container(
                  width: AppDimention.screenWidth,
                  child: Column(
                    children: [
                      Container(
                        width: AppDimention.screenWidth,
                        height: AppDimention.size150,
                        child: Stack(
                          children: [
                            Positioned(
                                bottom: 0,
                                left: 0,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: AppDimention.size10,
                                    ),
                                    Text("Danh sách nước uống thêm",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontStyle: FontStyle.italic,
                                        )),
                                    SizedBox(
                                      width: AppDimention.size10,
                                    ),
                                    Container(
                                      width: AppDimention.screenWidth,
                                      height: AppDimention.size5,
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(
                                              AppDimention.size10)),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                      Column(
                        children:
                            listdrink!.map((item) {
                          return Container(
                            padding: EdgeInsets.only(
                                left: AppDimention.size10,
                                right: AppDimention.size10,
                                top: AppDimention.size10),
                            child: Row(
                              children: [
                                Radio<int>(
                                  value: item.productId!,
                                  groupValue: groupValue,
                                  onChanged: (int? newValue) {
                                    onChanged(newValue, item.price!.toInt());
                                  },
                                ),
                                Container(
                                  width: AppDimention.screenWidth -
                                      AppDimention.size80,
                                  padding: EdgeInsets.all(AppDimention.size10),
                                  decoration: BoxDecoration(
                                      color: groupValue == item.productId!
                                          ? Colors.greenAccent
                                          : Colors.white,
                                      border: Border.all(
                                          width: 1, color: Colors.black26),
                                      borderRadius: BorderRadius.circular(
                                          AppDimention.size5)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(item.productName!),
                                      Text("đ${_formatNumber(item.price!.toInt())}"),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: AppDimention.size100,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: AppDimention.size100 * 1.8,
            right: AppDimention.size20,
            child: Container(
              width: AppDimention.size100 * 2.5,
              height: AppDimention.size100 * 2,
              padding: EdgeInsets.all(AppDimention.size20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimention.size10),
                boxShadow: [
                  BoxShadow(
                      blurRadius: AppDimention.size10,
                      spreadRadius: 3,
                      offset: Offset(1, 2),
                      color: Colors.amber)
                ],
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Center(
                        child: Text(
                          "Sản phẩm",
                          style: TextStyle(
                              fontSize: AppDimention.size25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppDimention.size10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: comboitem!.products!.map<Widget>((item) {
                        return Row(children: [
                          Icon(
                            Icons.circle,
                            size: AppDimention.size10,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            item.productName!,
                            style: TextStyle(
                              height: 2,
                            ),
                          )
                        ]);
                      }).toList(),
                    ),
                    Text(
                      "đ${_formatNumber(comboitem!.price!.toInt())}",
                      style: TextStyle(
                        fontSize: AppDimention.size20,
                        color: Colors.black38,
                        shadows: [
                          Shadow(
                              blurRadius: AppDimention.size10,
                              offset: Offset(2.0, 2.0),
                              color: Colors.amber)
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
          Positioned(
              top: AppDimention.size150,
              left: 0,
              height: AppDimention.size100 * 3 - AppDimention.size30,
              child: Center(
                child: Container(
                  height: AppDimention.size100 * 2,
                  width: AppDimention.size100,
                  decoration: BoxDecoration(
                      color: AppColor.mainColor,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(AppDimention.size100),
                          topRight: Radius.circular(AppDimention.size100)),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: MemoryImage(
                          base64Decode(comboitem!.image!),
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: AppDimention.size10,
                            spreadRadius: 3,
                            offset: Offset(1, 2),
                            color: Colors.amber)
                      ]),
                ),
              )),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: AppDimention.screenWidth,
              height: AppDimention.size80,
              decoration: BoxDecoration(color: AppColor.mainColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: AppDimention.size130,
                    height: AppDimention.size50,
                    margin: EdgeInsets.only(left: AppDimention.size10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(AppDimention.size5)),
                    child: Center(
                      child: Text("đ${_formatNumber(comboitem!.price!.toInt() + drinkprice!)}"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        drinkprice = 0;
                        groupValue = null;
                      });
                    },
                    child: Container(
                      width: AppDimention.size80,
                      height: AppDimention.size60,
                      child: Column(
                        children: [
                          Icon(
                            Icons.emoji_food_beverage,
                            color: Colors.white,
                          ),
                          Text(
                            "Bỏ nước",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                 GestureDetector(
                  onTap: (){
                    Get.toNamed(AppRoute.order_combo(comboitem!.comboId!, groupValue == null ? 0 : groupValue!));
                  },
                  child:  Container(
                    width: AppDimention.size130,
                    height: AppDimention.size50,
                    margin: EdgeInsets.only(right: AppDimention.size10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(AppDimention.size5)),
                    child: Center(
                      child: Text("Mua ngay"),
                    ),
                  ),
                 )
                ],
              ),
            ),
          )
        ],
      ));
    });
  }
}
