import 'dart:convert';

import 'package:flutter_user_github/data/controller/Cart_controller.dart';

import 'package:flutter_user_github/models/Model/CartModel.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartList extends StatefulWidget {
  const CartList({Key? key}) : super(key: key);

  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  CartController cartController = Get.find<CartController>();
  List<bool> isSelected = [];
  List<List<bool>> isProductSelected = [];
  List<int> storeSelected = [];
  List<int> cartSelected = [];
  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]}.',
        );
  }

  void _showDialogDelete(int cartId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              child: Container(
                  width: AppDimention.screenWidth * 2 / 3,
                  height: AppDimention.size100 * 1.5,
                  decoration: BoxDecoration(),
                  child: StatefulBuilder(builder: (context, setState) {
                    return Container(
                      padding: EdgeInsets.all(AppDimention.size20),
                      child: Column(
                        children: [
                          Text("Bạn muốn xóa sản phẩm này ?"),
                          SizedBox(
                            height: AppDimention.size30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  width: AppDimention.size100,
                                  height: AppDimention.size40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          AppDimention.size5),
                                      border: Border.all(
                                          width: 1, color: Colors.redAccent)),
                                  child: Center(
                                    child: Text("Hủy"),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  cartController.deleteCart(cartId);
                                  cartController.getall();
                                  cartController.getListCartV2();
                                  
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: AppDimention.size100,
                                  height: AppDimention.size40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          AppDimention.size5),
                                      border: Border.all(
                                          width: 1, color: Colors.greenAccent)),
                                  child: Center(
                                    child: Text("Đồng ý"),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  })));
        });
  }

  void _showDialogUpdate(CartData cartData) {
    ProductInCart? productInCart;
    ComboInCart? comboInCart;
    int quantity;
    bool? key;
    if (cartData.type == "product") {
      productInCart = cartData.product;
      key = true;
      quantity = cartData.product!.quantity!;
    } else {
      comboInCart = cartData.combo;
      key = false;
      quantity = cartData.combo!.quantity!;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              child: Container(
                  width: AppDimention.screenWidth * 2 / 3,
                  height: AppDimention.size100 * 2.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppDimention.size10),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: MemoryImage(base64Decode(key!
                              ? productInCart!.image!
                              : comboInCart!.image!)))),
                  child: StatefulBuilder(builder: (context, setState) {
                    return Container(
                        padding: EdgeInsets.all(AppDimention.size20),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppDimention.size10),
                            color: Colors.black.withOpacity(0.3)),
                        child: Column(children: [
                          Text(
                            "${key! ? productInCart!.productName! : comboInCart!.comboName}",
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                          SizedBox(
                            height: AppDimention.size20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (quantity > 1) {
                                      quantity = quantity - 1;
                                    }
                                  });
                                },
                                child: Container(
                                  width: AppDimention.size50,
                                  height: AppDimention.size50,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.white)),
                                  child: Center(
                                    child: Icon(Icons.remove,
                                        size: 25, color: Colors.white),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: AppDimention.size50,
                                  height: AppDimention.size50,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 1, color: Colors.white),
                                          top: BorderSide(
                                              width: 1, color: Colors.white))),
                                  child: Center(
                                    child: Text(
                                      "${quantity}",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (quantity < 11) {
                                      quantity = quantity + 1;
                                    }
                                  });
                                },
                                child: Container(
                                  width: AppDimention.size50,
                                  height: AppDimention.size50,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.white)),
                                  child: Center(
                                    child: Icon(Icons.add,
                                        size: 25, color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: AppDimention.size20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                   Navigator.pop(context);
                                },
                                child: Container(
                                  width: AppDimention.size100,
                                  height: AppDimention.size40,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.white),
                                      borderRadius: BorderRadius.circular(
                                          AppDimention.size5)),
                                  child: Center(
                                    child: Text("Hủy",
                                        style:
                                            TextStyle(color: Colors.red[100])),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: AppDimention.size20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  cartController.updateCart(cartData.cartId!,quantity);
                                  cartController.getall();
                                  cartController.getListCartV2();
                                 
                                   Navigator.pop(context);
                                },
                                child: Container(
                                  width: AppDimention.size100,
                                  height: AppDimention.size40,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.white),
                                      borderRadius: BorderRadius.circular(
                                          AppDimention.size5)),
                                  child: Center(
                                    child: Text("Đồng ý",
                                        style:
                                            TextStyle(color: Colors.green[100])),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ]));
                  })));
        });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      if (isSelected.length != cartController.listcart.length) {
        isSelected = List<bool>.filled(cartController.listcart.length, false);
      }

      if (isProductSelected.length != cartController.listcart.length) {
        isProductSelected = List.generate(
            cartController.listcart.length,
            (index) => List<bool>.filled(
                cartController.listcart[index].cartdata!.length, false));
      }

      if (cartController.listcart.isEmpty) {
        return Container(
          width: AppDimention.screenWidth,
          height: AppDimention.size170 + AppDimention.size5,
          child: Center(
            child: Text("Bạn không có món ăn trong giỏ hàng"),
          ),
        );
      } else {
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: cartController.listcart.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {},
              child: Container(
                width: AppDimention.screenWidth,
                margin: EdgeInsets.only(
                  bottom: AppDimention.size10,
                ),
                padding: EdgeInsets.only(
                  left: AppDimention.size10,
                  right: AppDimention.size10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: AppDimention.screenWidth,
                      child: Column(
                        children: [
                          Container(
                            width: AppDimention.screenWidth,
                            decoration:
                                BoxDecoration(color: AppColor.mainColor),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isSelected[index],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isSelected[index] = value!;

                                      if (value) {
                                        storeSelected.add(cartController
                                            .listcart[index]
                                            .storeitem!
                                            .storeId!);

                                        for (int i = 0;
                                            i <
                                                cartController.listcart[index]
                                                    .cartdata!.length;
                                            i++) {
                                          isProductSelected[index][i] = true;
                                          if (cartController.listcart[index]
                                                  .cartdata![i].type ==
                                              "product") {
                                            cartSelected.add(cartController
                                                .listcart[index]
                                                .cartdata![i]
                                                .product!
                                                .productId!);
                                          } else {
                                            cartSelected.add(cartController
                                                .listcart[index]
                                                .cartdata![i]
                                                .combo!
                                                .comboId!);
                                          }
                                          cartController.updateIDSelectedItem(
                                              cartController.listcart[index]
                                                  .cartdata![i].cartId!,
                                              true);
                                        }
                                        cartController.updateIDSelectedStore(
                                            cartController.listcart[index]
                                                .storeitem!.storeId!,
                                            true);
                                      } else {
                                        storeSelected.remove(cartController
                                            .listcart[index]
                                            .storeitem!
                                            .storeId!);

                                        for (int i = 0;
                                            i <
                                                cartController.listcart[index]
                                                    .cartdata!.length;
                                            i++) {
                                          isProductSelected[index][i] = false;

                                          if (cartController.listcart[index]
                                                  .cartdata![i].type ==
                                              "product") {
                                            cartSelected.remove(cartController
                                                .listcart[index]
                                                .cartdata![i]
                                                .product!
                                                .productId!);
                                          } else {
                                            cartSelected.remove(cartController
                                                .listcart[index]
                                                .cartdata![i]
                                                .combo!
                                                .comboId!);
                                          }
                                          cartController.updateIDSelectedItem(
                                              cartController.listcart[index]
                                                  .cartdata![i].cartId!,
                                              false);
                                        }
                                        cartController.updateIDSelectedStore(
                                            cartController.listcart[index]
                                                .storeitem!.storeId!,
                                            false);
                                      }
                                    });
                                  },
                                ),
                                Container(
                                  width: AppDimention.size100 * 3,
                                  child: Text(
                                    cartController
                                        .listcart[index].storeitem!.storeName!,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: AppDimention.screenWidth,
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: Column(
                              children: cartController.listcart[index].cartdata!
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                int itemIndex = entry.key;
                                var item = entry.value;
                                ProductInCart? productInCart;
                                ComboInCart? comboInCart;
                                int quantity;
                                bool? key;
                                if (item.type == "product") {
                                  productInCart = item.product;
                                  key = true;
                                  quantity = item.product!.quantity!;
                                } else {
                                  comboInCart = item.combo;
                                  key = false;
                                  quantity = item.combo!.quantity!;
                                }
                                return Column(
                                  children: [
                                    Container(
                                      width: AppDimention.screenWidth,
                                      padding: EdgeInsets.only(
                                          top: AppDimention.size10,
                                          bottom: AppDimention.size10),
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: isProductSelected[index]
                                                [itemIndex],
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isProductSelected[index]
                                                    [itemIndex] = value!;
                                                if (value) {
                                                  cartSelected.add(key!
                                                      ? productInCart!
                                                          .productId!
                                                      : comboInCart!.comboId!);
                                                  cartController
                                                      .updateIDSelectedItem(
                                                          item.cartId!, true);
                                                } else {
                                                  cartSelected.remove(key!
                                                      ? productInCart!
                                                          .productId!
                                                      : comboInCart!.comboId!);
                                                  cartController
                                                      .updateIDSelectedItem(
                                                          item.cartId!, false);
                                                }
                                              });
                                            },
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Get.toNamed(key!
                                                  ? AppRoute.get_product_detail(
                                                      productInCart!.productId!)
                                                  : AppRoute.get_combo_detail(
                                                      comboInCart!.comboId!));
                                            },
                                            child: Container(
                                              width: AppDimention.size60,
                                              height: AppDimention.size60,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.black26),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          AppDimention.size5),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: MemoryImage(
                                                          base64Decode(key
                                                              ? productInCart!
                                                                  .image!
                                                              : comboInCart!
                                                                  .image!)))),
                                            ),
                                          ),
                                          SizedBox(
                                            width: AppDimention.size20,
                                          ),
                                          Container(
                                            width: AppDimention.size100 * 2.2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(key
                                                    ? productInCart!
                                                        .productName!
                                                    : comboInCart!.comboName!),
                                                Text(
                                                    "Size : ${key ? productInCart!.size! : comboInCart!.size!}"),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "đ${_formatNumber(key ? productInCart!.unitPrice!.toInt() : comboInCart!.unitPrice!.toInt())}",
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {},
                                                          child: Container(
                                                            width: AppDimention
                                                                .size20,
                                                            height: AppDimention
                                                                .size20,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .black26)),
                                                            child: Center(
                                                              child: Icon(
                                                                  Icons.remove,
                                                                  size: 15),
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {},
                                                          child: Container(
                                                            width: AppDimention
                                                                .size20,
                                                            height: AppDimention
                                                                .size20,
                                                            decoration: BoxDecoration(
                                                                border: Border(
                                                                    bottom: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .black26),
                                                                    top: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .black26))),
                                                            child: Center(
                                                              child: Text(
                                                                "${key ? productInCart!.quantity : comboInCart!.quantity}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {},
                                                          child: Container(
                                                            width: AppDimention
                                                                .size20,
                                                            height: AppDimention
                                                                .size20,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .black26)),
                                                            child: Center(
                                                              child: Icon(
                                                                  Icons.add,
                                                                  size: 13),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: AppDimention.screenWidth,
                                      height: AppDimention.size30,
                                      padding: EdgeInsets.only(
                                          left: AppDimention.size20,
                                          right: AppDimention.size20),
                                      decoration: BoxDecoration(),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _showDialogUpdate(item);
                                            },
                                            child: Container(
                                              width: AppDimention.size25,
                                              height: AppDimention.size25,
                                              decoration: BoxDecoration(
                                                color: Colors.greenAccent,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppDimention.size5),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons
                                                      .drive_file_rename_outline_rounded,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: AppDimention.size10,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _showDialogDelete(item.cartId!);
                                            },
                                            child: Container(
                                              width: AppDimention.size25,
                                              height: AppDimention.size25,
                                              decoration: BoxDecoration(
                                                color: Colors.redAccent,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppDimention.size5),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.delete,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      }
    });
  }
}
