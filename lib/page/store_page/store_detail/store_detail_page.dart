import 'dart:convert';

import 'package:flutter_user_github/data/controller/Category_controller.dart';
import 'package:flutter_user_github/data/controller/Product_controller.dart';
import 'package:flutter_user_github/data/controller/Store_Controller.dart';

import 'package:flutter_user_github/models/Model/Item/StoresItem.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StoreDetailPage extends StatefulWidget {
  final int storeId;
  const StoreDetailPage({
    required this.storeId,
    Key? key,
  }) : super(key: key);
  @override
  _StoreDetailPageState createState() => _StoreDetailPageState();
}

class _StoreDetailPageState extends State<StoreDetailPage> {
  bool _isLoad = true;
  int? categorySelected;
  Storesitem? storesitem;
  String? title;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadData();
    _loadInfomation();
  }

  Future<void> _loadData() async {
    await Get.find<CategoryController>().getbystoreid(widget.storeId);
    await Get.find<Storecontroller>().getbyid(widget.storeId);
    setState(() {
      _isLoad = false;
    });
  }

  void _loadProduct(int storeid, int categoryId) async {
    await Get.find<ProductController>()
        .getProductByStoreCategoryId(storeid, categoryId);
  }

  String formatTime(String isoDateTime) {
    DateTime dateTime = DateTime.parse(isoDateTime);
    return DateFormat('hh:mm').format(dateTime);
  }

  void _loadInfomation() {
    if (!_isLoad) {
      categorySelected =
          Get.find<CategoryController>().categoryListStoreId[0].categoryId;
      title =
          Get.find<CategoryController>().categoryListStoreId[0].categoryName;
      storesitem = Get.find<Storecontroller>().storeItem!;

      _loadProduct(storesitem!.storeId!,
          Get.find<CategoryController>().categoryListStoreId[0].categoryId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Storecontroller>(builder: (controller) {
      return _isLoad
          ? Container(
              width: AppDimention.screenWidth,
              height: AppDimention.screenHeight,
              decoration: BoxDecoration(color: Colors.white),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text(
                      "Loading ...",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    )
                  ],
                ),
              ),
            )
          : Scaffold(
              body: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: AppDimention.screenWidth,
                    height: AppDimention.size100 * 2,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      fit: BoxFit.cover,
                      image: MemoryImage(base64Decode(storesitem!.image!)),
                    )),
                    child: Container(
                        width: AppDimention.screenWidth,
                        height: AppDimention.size100 * 2,
                        padding: EdgeInsets.all(AppDimention.size20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Container(
                                    width: AppDimention.size40,
                                    height: AppDimention.size40,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            132, 255, 255, 255),
                                        borderRadius: BorderRadius.circular(
                                            AppDimention.size30)),
                                    child: Center(
                                      child: Icon(
                                        Icons.arrow_back_ios_new,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(AppRoute.CART_PAGE);
                                  },
                                  child: Container(
                                    width: AppDimention.size40,
                                    height: AppDimention.size40,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            132, 255, 255, 255),
                                        borderRadius: BorderRadius.circular(
                                            AppDimention.size30)),
                                    child: Center(
                                      child: Icon(
                                        Icons.shopping_cart_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: AppDimention.size100 * 2,
                  child: Container(
                      width: AppDimention.screenWidth,
                      height: 600,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: AppDimention.size80,
                            ),
                            Text(
                              storesitem!.storeName.toString(),
                              style: TextStyle(
                                  fontSize: AppDimention.size20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              width: AppDimention.screenWidth,
                              padding: EdgeInsets.only(
                                  left: AppDimention.size10,
                                  right: AppDimention.size10),
                              child: Center(
                                child: Text(
                                  "Địa chỉ :${storesitem!.location} ",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black38),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: AppDimention.size10,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: AppDimention.size130,
                                  height: AppDimention.size60,
                                  decoration: BoxDecoration(
                                      border: Border(
                                    right: BorderSide(
                                        width: 1, color: Colors.black26),
                                  )),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                          ),
                                          Text(
                                            "4.1",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "50+ đánh giá",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: AppDimention.size130,
                                  height: AppDimention.size60,
                                  decoration: BoxDecoration(
                                      border: Border(
                                    right: BorderSide(
                                        width: 1, color: Colors.black26),
                                  )),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.timelapse_sharp,
                                            color: Colors.blue,
                                          ),
                                          Text(
                                            "10-20 phút",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Dự kiến giao",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: AppDimention.size120,
                                  height: AppDimention.size60,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.av_timer,
                                            color: Colors.red,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        formatTime(storesitem!.openingTime!) +
                                            " - " +
                                            formatTime(
                                                storesitem!.closingTime!),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: AppDimention.size15,
                            ),
                            Container(
                              width: AppDimention.screenWidth,
                              height: AppDimention.size60,
                              padding:
                                  EdgeInsets.only(right: AppDimention.size10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1, color: Colors.black12),
                                      top: BorderSide(
                                          width: 1, color: Colors.black12))),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: Get.find<CategoryController>()
                                      .categoryListStoreId
                                      .map((item) => Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    categorySelected =
                                                        item.categoryId;
                                                    title = item.categoryName;
                                                  });

                                                  _loadProduct(
                                                      storesitem!.storeId!,
                                                      categorySelected!);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left:
                                                          AppDimention.size10),
                                                  padding: EdgeInsets.only(
                                                      left: AppDimention.size20,
                                                      right:
                                                          AppDimention.size20),
                                                  height: AppDimention.size50,
                                                  decoration: BoxDecoration(
                                                      color: item.categoryId ==
                                                              categorySelected
                                                          ? Colors.amber
                                                          : Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              AppDimention
                                                                  .size5)),
                                                  child: Center(
                                                    child: Text(
                                                      item.categoryName!,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              Colors.black54),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ))
                                      .toList(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: AppDimention.size20,
                            ),
                            Container(
                              width: AppDimention.screenWidth,
                              padding: EdgeInsets.only(
                                  left: AppDimention.size10,
                                  right: AppDimention.size10),
                              child: Text(
                                title!,
                                style: TextStyle(
                                    fontSize: AppDimention.size25,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                            ),
                            SizedBox(
                              height: AppDimention.size20,
                            ),
                            GetBuilder<ProductController>(
                                builder: (productcontroller) {
                              return productcontroller.isLoadingStoreCategory
                                  ? CircularProgressIndicator()
                                  : Column(
                                      children: Get.find<ProductController>()
                                          .productListBycategorystore
                                          .map((item) => Container(
                                                width: AppDimention.screenWidth,
                                                height: AppDimention.size130,
                                                padding: EdgeInsets.only(
                                                    top: AppDimention.size10,
                                                    bottom:
                                                        AppDimention.size10),
                                                margin: EdgeInsets.only(
                                                    bottom:
                                                        AppDimention.size10),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[100]),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: AppDimention
                                                              .size10,
                                                          right: AppDimention
                                                              .size10),
                                                      width:
                                                          AppDimention.size100,
                                                      height:
                                                          AppDimention.size100,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  AppDimention
                                                                      .size10),
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: MemoryImage(
                                                                  base64Decode(item
                                                                      .image!)))),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(item.productName!,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            )),
                                                        Row(
                                                          children: [
                                                            Wrap(
                                                              children:
                                                                  List.generate(
                                                                      5,
                                                                      (index) {
                                                                if (index <
                                                                    item.averageRate!
                                                                        .floor()) {
                                                                  return Icon(
                                                                      Icons
                                                                          .star,
                                                                      color: Colors
                                                                          .amber,
                                                                      size: AppDimention
                                                                          .size15);
                                                                } else if (index ==
                                                                        item.averageRate!
                                                                            .floor() &&
                                                                    item.averageRate! %
                                                                            1 !=
                                                                        0) {
                                                                  return Icon(
                                                                      Icons
                                                                          .star_half,
                                                                      color: Colors
                                                                          .amber,
                                                                      size: AppDimention
                                                                          .size15);
                                                                } else {
                                                                  return Icon(
                                                                      Icons
                                                                          .star_border,
                                                                      color: Colors
                                                                          .amber,
                                                                      size: AppDimention
                                                                          .size15);
                                                                }
                                                              }),
                                                            ),
                                                            Text(
                                                              "(${item.averageRate})",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .amber,
                                                                  fontSize: 12),
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              item.discountedPrice !=
                                                                      0
                                                                  ? "đ${item.discountedPrice!.toInt()}"
                                                                  : "đ${item.price!.toInt()}",
                                                              style: TextStyle(
                                                                  color: AppColor
                                                                      .mainColor),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  AppDimention
                                                                      .size5,
                                                            ),
                                                            Stack(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  item.discountedPrice !=
                                                                          0
                                                                      ? "đ${item.price!.toInt()}"
                                                                      : "",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black26,
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                                if (item.discountedPrice !=
                                                                    0)
                                                                  Positioned(
                                                                    child:
                                                                        Container(
                                                                      width: 60,
                                                                      height: 1,
                                                                      color: Colors
                                                                          .black26,
                                                                      transform:
                                                                          Matrix4.rotationZ(
                                                                              0),
                                                                    ),
                                                                  ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .delivery_dining_sharp,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                                Text(
                                                                  "Miễn phí vận chuyển",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  AppDimention
                                                                      .size30,
                                                            ),
                                                            GestureDetector(
                                                                onTap: () {
                                                                  Get.toNamed(AppRoute
                                                                      .get_product_detail(
                                                                          item.productId!));
                                                                },
                                                                child:
                                                                    Container(
                                                                  width:
                                                                      AppDimention
                                                                          .size80,
                                                                  height: AppDimention
                                                                          .size40 -
                                                                      1,
                                                                  decoration: BoxDecoration(
                                                                      color: AppColor
                                                                          .mainColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              AppDimention.size5)),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Mua",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                )),
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ))
                                          .toList());
                            }),
                            SizedBox(
                              height: AppDimention.size40,
                            ),
                          ],
                        ),
                      )),
                ),
                Positioned(
                    top: AppDimention.size100 * 2 -
                        AppDimention.size70 -
                        AppDimention.size5,
                    left: 0,
                    child: Column(
                      children: [
                        Container(
                          width: AppDimention.screenWidth,
                          height: AppDimention.size150,
                          child: Center(
                            child: Container(
                              height: AppDimention.size150,
                              width: AppDimention.size150,
                              decoration: BoxDecoration(
                                  color: AppColor.mainColor,
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size150),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: MemoryImage(
                                        base64Decode(storesitem!.image!)),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            ));
    });
  }
}
