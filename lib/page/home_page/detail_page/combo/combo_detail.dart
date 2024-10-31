import 'dart:convert';
import 'package:flutter_user_github/caculator/function.dart';
import 'package:flutter_user_github/data/controller/Combo_controller.dart';
import 'package:flutter_user_github/data/controller/Product_controller.dart';
import 'package:flutter_user_github/data/controller/Store_Controller.dart';
import 'package:flutter_user_github/models/Dto/AddComboToCartDto.dart';
import 'package:flutter_user_github/models/Model/Item/ComboItem.dart';
import 'package:flutter_user_github/models/Model/Item/ProductItem.dart';
import 'package:flutter_user_github/models/Model/Item/StoresItem.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComboDetail extends StatefulWidget {
  final int comboId;
  const ComboDetail({Key? key, required this.comboId}) : super(key: key);

  @override
  _ComboDetailState createState() => _ComboDetailState();
}

class _ComboDetailState extends State<ComboDetail> {
  int selectSize = 1;

  ProductController productController = Get.find<ProductController>();
  Storecontroller storecontroller = Get.find<Storecontroller>();
  ComboController comboController = Get.find<ComboController>();
  FunctionMap functionMap = FunctionMap();
  bool? isloadedData = false;
  List<int> listDrinkSelected = [];
  int? drinkprice = 0;
  int quantity = 1;
  bool? isLoadPoint = false;
  Point? currentPoint;
  List<int>? groupValue = [];
  int? comboprice;
  List<Productitem>? listdrink;
  Comboitem? comboitem;
  List<Storesitem>? commonStores;

  @override
  void initState() {
    super.initState();
    loadData();
    getCurrentPosition();
  }

  void loadData() async {
    comboitem = comboController.getcombobyId(widget.comboId);

    commonStores = storecontroller.getCommonStores(comboitem!.products!);
    while (storecontroller.getloadingCommonStore) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    loadDrink();
    while (productController.getloadDrinkInCombo) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    setState(() {
      isloadedData = true;
    });
  }

  void loadDrink() async {
    List<int> listStore = [];
    for (Storesitem item in commonStores!) {
      listStore.add(item.storeId!);
    }
    listdrink = await productController.getListDrinkInCombo(listStore);
  }

  void onChanged(bool value, int price, int productId) {
    setState(() {
      if (value) {
        drinkprice = drinkprice! + price;
        groupValue!.add(productId);
      } else {
        drinkprice = drinkprice! - price;
        groupValue!.remove(productId);
      }
    });
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]}.',
        );
  }

  // Get current position of user
  Future<void> getCurrentPosition() async {
    currentPoint = await functionMap.getCurrentLocation();
    setState(() {
      isLoadPoint = true;
    });
  }

  // Add combo to cart
  void addtoCart(int storeId) {
    int comboId = widget.comboId;
    int quantityCombo = quantity;
    int storeIdSelected = storeId;
    List<int> drinkId = listDrinkSelected;

    Combotocartdto combotocartdto = Combotocartdto(
        comboId: comboId,
        quantity: quantityCombo,
        storeId: storeIdSelected,
        drinkId: drinkId);
    comboController.addcombotocart(combotocartdto);
  }

  void _showDropdown() {
    List<Storesitem> items =
        storecontroller.getCommonStores(comboitem!.products!);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.grey.withOpacity(0.2),
          height: 400,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  addtoCart(items[index].storeId!);
                  Navigator.pop(context);
                },
                child: Container(
                  width: AppDimention.screenWidth,
                  padding: EdgeInsets.only(
                      left: AppDimention.size10,
                      right: AppDimention.size10,
                      top: AppDimention.size20,
                      bottom: AppDimention.size20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(width: 1, color: Colors.black26))),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.blue,
                          ),
                          Text(
                            "${(functionMap.calculateDistance(items[index].latitude!, items[index].longitude!, isLoadPoint! ? currentPoint!.latitude! : 0, isLoadPoint! ? currentPoint!.longtitude! : 0) / 1000).toInt()} ",
                            style: TextStyle(color: Colors.blue),
                          ),
                          Text(
                            "( km )",
                            style: TextStyle(color: Colors.blue),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: AppDimention.size10),
                        width: AppDimention.screenWidth * 0.7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              items[index].storeName!,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: AppDimention.size5,
                            ),
                            Text(
                              items[index].location!,
                              textAlign: TextAlign.justify,
                              style: TextStyle(color: Colors.black45),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ComboController>(builder: (comboControler) {
      return !isloadedData!
          ? Container(
              width: AppDimention.screenWidth,
              height: AppDimention.screenHeight,
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Scaffold(
              body: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  height: AppDimention.size100 * 2.7,
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
                  top: AppDimention.size100 * 2.7,
                  left: 0,
                  child: Container(
                    width: AppDimention.screenWidth,
                    height: AppDimention.screenHeight * 0.6,
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
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppDimention.size10)),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            ),
                            Column(
                              children: listdrink!.map((item) {
                                // Check if the current item is selected
                                bool isSelected =
                                    listDrinkSelected.contains(item.productId!);

                                return Container(
                                  padding: EdgeInsets.only(
                                      left: AppDimention.size10,
                                      right: AppDimention.size10,
                                      top: AppDimention.size10),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: isSelected,
                                        onChanged: (bool? newValue) {
                                          setState(() {
                                            if (newValue == true) {
                                              if (listDrinkSelected.length ==
                                                  2) {
                                                listDrinkSelected.removeAt(0);
                                              }
                                              listDrinkSelected
                                                  .add(item.productId!);
                                              print(listDrinkSelected.length);
                                            } else {
                                              listDrinkSelected
                                                  .remove(item.productId!);
                                            }
                                            onChanged(
                                                newValue!,
                                                item.price!.toInt(),
                                                item.productId!);
                                          });
                                        },
                                      ),
                                      Container(
                                        width: AppDimention.screenWidth * 0.8,
                                        padding:
                                            EdgeInsets.all(AppDimention.size10),
                                        decoration: BoxDecoration(
                                            color: isSelected
                                                ? Colors.greenAccent
                                                : Colors.white,
                                            border: Border.all(
                                                width: 1,
                                                color: Colors.black26),
                                            borderRadius: BorderRadius.circular(
                                                AppDimention.size5)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(item.productName!),
                                            Text(
                                                "đ${_formatNumber(item.price!.toInt())}"),
                                          ],
                                        ),
                                      ),
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
                    width: AppDimention.screenWidth * 0.65,
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
                          Center(
                            child: Text(
                              "đ${_formatNumber(comboitem!.price!.toInt() * quantity + drinkprice!)}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black38,
                                shadows: [
                                  Shadow(
                                      blurRadius: AppDimention.size10,
                                      offset: Offset(2.0, 2.0),
                                      color: Colors.amber)
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: AppDimention.screenWidth * 0.55,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (quantity > 1) {
                                        quantity = quantity - 1;
                                      }
                                    });
                                  },
                                  child:
                                      Icon(Icons.remove_circle_outline_sharp),
                                ),
                                Text("${quantity}"),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (quantity < 10) {
                                        quantity = quantity + 1;
                                      }
                                    });
                                  },
                                  child: Icon(Icons.add_circle_outline_sharp),
                                ),
                              ],
                            ),
                          )
                        ]),
                  ),
                ),
                Positioned(
                    top: AppDimention.size150,
                    left: 0,
                    height: AppDimention.size100 * 2.7,
                    child: Center(
                      child: Container(
                        height: AppDimention.size100 * 2,
                        width: AppDimention.screenWidth * 0.25,
                        decoration: BoxDecoration(
                            color: AppColor.mainColor,
                            borderRadius: BorderRadius.only(
                                bottomRight:
                                    Radius.circular(AppDimention.size100),
                                topRight:
                                    Radius.circular(AppDimention.size100)),
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
                // Bottom of combo page
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
                        GestureDetector(
                          onTap: () {
                            _showDropdown();
                          },
                          child: Container(
                            width: AppDimention.screenWidth * 0.2,
                            height: AppDimention.size50,
                            margin: EdgeInsets.only(left: AppDimention.size10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(AppDimention.size5)),
                            child: Center(
                              child: Icon(Icons.shopping_cart_outlined),
                            ),
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
                            width: AppDimention.screenWidth * 0.2,
                            height: AppDimention.size50,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.emoji_food_beverage,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Bỏ nước",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoute.orderCombo(comboitem!.comboId!,
                                groupValue!.length == 0 ? [0] : groupValue!));
                          },
                          child: Container(
                            width: AppDimention.screenWidth * 0.5,
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
