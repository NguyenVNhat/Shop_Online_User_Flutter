import 'dart:convert';

import 'package:flutter_user_github/data/controller/Category_controller.dart';
import 'package:flutter_user_github/data/controller/Combo_controller.dart';
import 'package:flutter_user_github/data/controller/Product_controller.dart';
import 'package:flutter_user_github/data/controller/Size_controller.dart';
import 'package:flutter_user_github/data/controller/User_controller.dart';
import 'package:flutter_user_github/helper/dependencies.dart';
import 'package:flutter_user_github/models/Model/Item/CategoryItem.dart';
import 'package:flutter_user_github/models/Model/Item/ComboItem.dart';
import 'package:flutter_user_github/models/Model/Item/ProductItem.dart';
import 'package:flutter_user_github/models/Model/UserModel.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/src/widgets/framework.dart';

class Question {
  String selection;
  Future<Widget> Function() answers;

  Question(this.selection, this.answers);
}

class Quiz {
  int storeId;
  List<Question> questions;

  Quiz({required this.storeId}) : questions = [] {
    questions.add(
      Question(
        "Tôi muốn xem danh mục sản phẩm của cửa hàng bạn .",
        () => displayCategory(Get.context),
      ),
    );

    questions.add(
      Question(
        "Tôi muốn xem danh sách sản phẩm của cửa hàng .",
        () => displayProduct(Get.context),
      ),
    );

    questions.add(
      Question(
        "Tôi muốn xem danh sách các combo đang có .",
        () => displayCombo(Get.context),
      ),
    );
    questions.add(
      Question(
        "Hãy hiển thị bản đồ đến cửa hàng của bạn .",
        () => displayProduct(Get.context),
      ),
    );
    questions.add(
      Question(
        "Thời gian mà cửa hàng hoạt động trong ngày .",
        () => displayProduct(Get.context),
      ),
    );
    questions.add(
      Question(
        "Xem chi tiết cửa hàng .",
        () => displayProduct(Get.context),
      ),
    );
  }

  Future<Widget> displayCategory(BuildContext? context) async {
    CategoryController categoryController = Get.find<CategoryController>();
    ProductController productController = Get.find<ProductController>();
    List<Productitem> listproduct;
    UserController userController = Get.find<UserController>();
    User user = userController.userprofile!;
    await categoryController.getbystoreid(storeId);
    while (categoryController.isLoadingStore) {
      await Future.delayed(const Duration(microseconds: 100));
    }
    String _formatNumber(int number) {
      return number.toString().replaceAllMapped(
            RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
            (Match match) => '${match[1]}.',
          );
    }

    List<Categoryitem> listCategory = categoryController.categoryListStoreId;
    void _showDropdown(int categoryId) async {
      listproduct = await productController.getProductByStoreCategoryIdV2(
          storeId, categoryId);

      showDialog(
          context: context!,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(AppDimention.size10),
                    child: SingleChildScrollView(
                      child: Column(
                      children: listproduct.length == 0
                          ? [Text("Hiện không có sản phẩm")]
                          : listproduct
                              .map((item) => Container(
                                    width: AppDimention.screenWidth,
                                    margin: EdgeInsets.only(
                                        bottom: AppDimention.size10),
                                    height: AppDimention.size150 + AppDimention.size10,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: MemoryImage(
                                                base64Decode(item.image!))),
                                        borderRadius: BorderRadius.circular(
                                            AppDimention.size10)),
                                    child: Container(
                                      width: AppDimention.screenWidth,
                                      height: AppDimention.size150 + AppDimention.size10,
                                      padding:
                                          EdgeInsets.all(AppDimention.size20),
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(
                                              AppDimention.size10)),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("${item.productName}",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white)),
                                          SizedBox(height: AppDimention.size10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "đ${_formatNumber(item.price!.toInt())}",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                              Row(
                                                children: [
                                                  Wrap(
                                                    children: List.generate(5,
                                                        (index) {
                                                      if (index <
                                                          item.averageRate!
                                                              .floor()) {
                                                        return Icon(Icons.star,
                                                            color: Colors.white,
                                                            size: AppDimention
                                                                .size15);
                                                      } else if (index ==
                                                              item.averageRate!
                                                                  .floor() &&
                                                          item.averageRate! %
                                                                  1 !=
                                                              0) {
                                                        return Icon(
                                                            Icons.star_half,
                                                            color: Colors.white,
                                                            size: AppDimention
                                                                .size15);
                                                      } else {
                                                        return Icon(
                                                            Icons.star_border,
                                                            color: Colors.white,
                                                            size: AppDimention
                                                                .size15);
                                                      }
                                                    }),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          AppDimention.size10),
                                                  Text(
                                                    "(${item.averageRate})",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height:AppDimention.size10),
                                          Center(
                                            child: GestureDetector(
                                              onTap: (){
                                                  Get.toNamed(AppRoute.get_product_detail(item.productId!));
                                              },
                                              child: Container(
                                                  
                                              width: AppDimention.size100,
                                              height: AppDimention.size30,
                                              decoration: BoxDecoration(
                                                border: Border.all(width: 1,color: Colors.greenAccent),
                                                borderRadius: BorderRadius.circular(AppDimention.size10)
                                              ),
                                              child: Center(
                                                child: Text("Chi tiết",style: TextStyle(color: Colors.white),),
                                              ),
                                            ),
                                            )
                                          )
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(),
                    ),
                    )
                  ));
            });
          });
    }

    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(AppDimention.size10),
          margin: EdgeInsets.all(AppDimention.size10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimention.size10)),
          child: Column(
            children: [
              Container(
                width: AppDimention.screenWidth,
                child: Text(
                  "Danh mục sản phẩm : ",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
              ),
              Container(
                width: AppDimention.screenWidth,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: listCategory.map((item) {
                      return GestureDetector(
                        onTap: () {
                          _showDropdown(item.categoryId!);
                        },
                        child: Container(
                          width: AppDimention.screenWidth / 2 - 10,
                          height: AppDimention.size100,
                          margin: EdgeInsets.only(
                              left: AppDimention.size10,
                              top: AppDimention.size10),
                          decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size10)),
                          child: Center(
                            child: Text(
                              "${item.categoryName}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<Widget> displayProduct(BuildContext? context) async {
    String _formatNumber(int number) {
      return number.toString().replaceAllMapped(
            RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
            (Match match) => '${match[1]}.',
          );
    }

    int selectSize = 1;
    String selectSizeString = "M";
    ProductController productController = Get.find<ProductController>();
    List<Productitem> listProduct =
        await productController.getbystoreId(storeId);

    void addtocart(
        int productid, int quantity, int idstore, String sizename) async {
      await Get.find<SizeController>().getbyidl(selectSize);
      String sizename = Get.find<SizeController>().sizename;
      Get.find<ProductController>()
          .addtocart(productid, quantity, idstore, sizename);
    }

    void _order(int productId, String selectSizeStr, int quantity) {
      Get.toNamed(AppRoute.order_product(productId, selectSizeStr, quantity));
    }

    void _showDialodProduct(Productitem item) {
      int quantity = 1;
      showDialog(
        context: context!,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                    width: AppDimention.size100 * 3,
                    height: AppDimention.size100 * 4,
                    padding: EdgeInsets.all(AppDimention.size20),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: MemoryImage(base64Decode(item.image!))),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      width: AppDimention.size100 * 2.6,
                      height: AppDimention.size100 * 3.6,
                      padding: EdgeInsets.all(AppDimention.size10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: AppDimention.size10,
                              spreadRadius: 7,
                              offset: Offset(1, 10),
                              color: Colors.white)
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${item.productName}",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                          SizedBox(height: AppDimention.size10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "đ${_formatNumber(item.price!.toInt())}",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                              Row(
                                children: [
                                  Wrap(
                                    children: List.generate(5, (index) {
                                      if (index < item.averageRate!.floor()) {
                                        return Icon(Icons.star,
                                            color: Colors.white,
                                            size: AppDimention.size15);
                                      } else if (index ==
                                              item.averageRate!.floor() &&
                                          item.averageRate! % 1 != 0) {
                                        return Icon(Icons.star_half,
                                            color: Colors.white,
                                            size: AppDimention.size15);
                                      } else {
                                        return Icon(Icons.star_border,
                                            color: Colors.white,
                                            size: AppDimention.size15);
                                      }
                                    }),
                                  ),
                                  SizedBox(height: AppDimention.size10),
                                  Text(
                                    "(${item.averageRate})",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: AppDimention.size20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GetBuilder<SizeController>(
                                  builder: (sizecontroller) {
                                return Row(
                                  children: sizecontroller.sizelist.map((item) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectSize = item.id!;
                                          selectSizeString = item.name!;
                                        });
                                      },
                                      child: Container(
                                        width: AppDimention.size30,
                                        height: AppDimention.size30,
                                        margin: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          color: item.id == selectSize
                                              ? Colors.greenAccent
                                              : Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Center(
                                          child: Text(item.name!),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              }),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (quantity > 1) {
                                          quantity--;
                                        }
                                      });
                                    },
                                    child: Icon(
                                      Icons.remove,
                                      size: AppDimention.size20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: AppDimention.size15),
                                  Text(
                                    "$quantity",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                  SizedBox(width: AppDimention.size15),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (quantity < 11) {
                                          quantity++;
                                        }
                                      });
                                    },
                                    child: Icon(Icons.add,
                                        size: AppDimention.size20,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: AppDimention.size30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  addtocart(item.productId!, quantity, storeId,
                                      selectSizeString);
                                },
                                child: Container(
                                  width: AppDimention.size100,
                                  height: AppDimention.size40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 1, color: Colors.greenAccent)),
                                  child: Center(
                                    child: Icon(
                                      Icons.shopping_cart_outlined,
                                      color: Colors.greenAccent,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _order(item.productId!, selectSizeString,
                                      quantity);
                                },
                                child: Container(
                                  width: AppDimention.size100,
                                  height: AppDimention.size40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 1, color: Colors.greenAccent)),
                                  child: Center(
                                    child: Icon(
                                      Icons.login,
                                      color: Colors.greenAccent,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )),
              );
            },
          );
        },
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: AppDimention.screenWidth * 2 / 2.5,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: listProduct.map((item) {
              return GestureDetector(
                onTap: () {
                  _showDialodProduct(item);
                },
                child: Container(
                  width: AppDimention.size100 * 2.5,
                  height: AppDimention.size100 * 3.6,
                  padding: EdgeInsets.all(AppDimention.size10),
                  margin: EdgeInsets.only(
                      left: AppDimention.size10,
                      right: AppDimention.size15,
                      top: AppDimention.size10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDimention.size10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: AppDimention.screenWidth,
                        height: AppDimention.size100 * 2.4,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppDimention.size10),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: MemoryImage(base64Decode(item.image!)),
                          ),
                        ),
                      ),
                      SizedBox(height: AppDimention.size20),
                      Text(item.productName!,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                      SizedBox(height: AppDimention.size10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Wrap(
                                children: List.generate(5, (index) {
                                  if (index < item.averageRate!.floor()) {
                                    return Icon(Icons.star,
                                        color: AppColor.mainColor,
                                        size: AppDimention.size15);
                                  } else if (index ==
                                          item.averageRate!.floor() &&
                                      item.averageRate! % 1 != 0) {
                                    return Icon(Icons.star_half,
                                        color: AppColor.mainColor,
                                        size: AppDimention.size15);
                                  } else {
                                    return Icon(Icons.star_border,
                                        color: AppColor.mainColor,
                                        size: AppDimention.size15);
                                  }
                                }),
                              ),
                              Text(
                                "(${item.averageRate})",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          Text(
                            "đ${_formatNumber(item.price!.toInt())}",
                            style: TextStyle(
                                color: AppColor.mainColor, fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Future<Widget> displayCombo(BuildContext? context) async {
    ComboController comboController = Get.find<ComboController>();
    List<Comboitem> listcombo =
        await comboController.getcombobyStoreId(storeId);

    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: AppDimention.screenWidth,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: listcombo.length == 0
                  ? [
                      Center(
                        child: Text("Hiện tại cửa hàng không có combo nào"),
                      )
                    ]
                  : listcombo.map((item) {
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoute.get_combo_detail(item.comboId!));
                        },
                        child: Container(
                          width: AppDimention.size100 * 3,
                          padding: EdgeInsets.only(
                              top: AppDimention.size10,
                              bottom: AppDimention.size10),
                          margin: EdgeInsets.only(
                              left: AppDimention.size5,
                              right: AppDimention.size5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size10)),
                          child: Row(
                            children: [
                              Container(
                                width: AppDimention.size80,
                                height: AppDimention.size100,
                                margin:
                                    EdgeInsets.only(left: AppDimention.size10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size10),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        MemoryImage(base64Decode(item.image!)),
                                  ),
                                ),
                              ),
                              Container(
                                width: AppDimention.size100 * 2,
                                padding: EdgeInsets.only(
                                    top: AppDimention.size20,
                                    left: AppDimention.size20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.comboName ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.star_purple500_sharp,
                                            size: 18,
                                            color: Colors.yellow[700]),
                                        const Text(" 4.7"),
                                        const Text(
                                          "(1450)",
                                          style:
                                              TextStyle(color: Colors.black38),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
            ),
          ),
        ));
  }
}
