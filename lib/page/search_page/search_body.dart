import 'dart:convert';

import 'package:flutter_user_github/data/controller/Category_controller.dart';
import 'package:flutter_user_github/data/controller/Product_controller.dart';
import 'package:flutter_user_github/models/Model/Item/CategoryItem.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBody extends StatefulWidget {
  const SearchBody({
    Key? key,
  }) : super(key: key);

  @override
  _SearchBodyState createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  late CategoryController categorycontroller = Get.find<CategoryController>();
  late ProductController productController = Get.find<ProductController>();
  RangeValues _currentRangeValues = RangeValues(0, 200000);
  @override
  void initState() {
    super.initState();
    Get.find<ProductController>().search();
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]}.',
        );
  }

  List<String> listrecommend = [];
  String? selectedCategory = "Tất cả";

  void _filterProduct() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<String> dropdownItems = ["Tất cả"];
        for (Categoryitem item in categorycontroller.categoryList) {
          dropdownItems.add(item.categoryName!);
        }
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimention.size5),
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: AppDimention.size100 * 3,
                padding: EdgeInsets.only(
                    left: AppDimention.size10,
                    right: AppDimention.size10,
                    top: AppDimention.size20,
                    bottom: AppDimention.size20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<String>(
                      value: selectedCategory,
                      hint: Text('Chọn danh mục'),
                      items: dropdownItems.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      },
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RangeSlider(
                            values: _currentRangeValues,
                            min: 0,
                            max: 200000,
                            divisions: 40,
                            labels: RangeLabels(
                              _currentRangeValues.start.toStringAsFixed(0),
                              _currentRangeValues.end.toStringAsFixed(0),
                            ),
                            onChanged: (RangeValues values) {
                              setState(() {
                                _currentRangeValues = values;
                              });
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                  "đ${_formatNumber(_currentRangeValues.start.toInt())}"),
                              SizedBox(
                                width: AppDimention.size60,
                              ),
                              Text(
                                  "đ${_formatNumber(_currentRangeValues.end.toInt())}"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: AppDimention.screenWidth,
                      child: Center(
                          child: GestureDetector(
                        onTap: () {
                            productController.filterProduct(selectedCategory!,_currentRangeValues.start.toInt(),_currentRangeValues.end.toInt());
                            Navigator.of(context).pop();
                          },
                        child: Container(
                          width: AppDimention.size100,
                          height: AppDimention.size40,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size5),
                              border: Border.all(width: 1, color: Colors.red)),
                          child: Center(
                            child: Text("Lọc"),
                          ),
                        ),
                      )),
                    )
                  ],
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
    return GetBuilder<ProductController>(builder: (productController) {
      return Column(
        children: [
          Container(
            width: AppDimention.screenWidth,
            height: AppDimention.size50,
            margin: EdgeInsets.only(left: AppDimention.size10),
            decoration: BoxDecoration(color: Colors.white),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: (){
                        productController.getallProductSearch();
                    },
                    child: Container(
                    width: AppDimention.size80,
                    height: AppDimention.size40,
                    margin: EdgeInsets.only(right: AppDimention.size10),
                    child: Row(
                      children: [
                        Text("Tất cả"),
                      ],
                    ),
                  ),
                  ),
                  GestureDetector(
                    onTap: (){
                        productController.sortDes(1);
                    },
                    child: Container(
                    width: AppDimention.size80,
                    height: AppDimention.size40,
                    margin: EdgeInsets.only(right: AppDimention.size10),
                    child: Row(
                      children: [
                        Text("Giá"),
                        Transform.rotate(
                          angle: 0 * 3.141592653589793 / 180,
                          child: Icon(
                            Icons.arrow_drop_down_outlined,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ),
                  GestureDetector(
                    onTap: (){
                        productController.sortDes(2);
                    },
                    child: Container(
                    width: AppDimention.size80,
                    height: AppDimention.size40,
                    margin: EdgeInsets.only(right: AppDimention.size10),
                    child: Row(
                      children: [
                        Text("Giá"),
                        Transform.rotate(
                          angle: 180 * 3.141592653589793 / 180,
                          child: Icon(
                            Icons.arrow_drop_down_outlined,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _filterProduct();
                    },
                    child: Container(
                      width: AppDimention.size60,
                      height: AppDimention.size40,
                      margin: EdgeInsets.only(right: AppDimention.size10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Lọc"),
                          Transform.rotate(
                            angle: 180 * 3.141592653589793 / 180,
                            child: Icon(
                              Icons.account_tree_outlined,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            
          ),
          Container(
            width: AppDimention.screenWidth,
            padding: EdgeInsets.only(
                top: AppDimention.size10, bottom: AppDimention.size10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: listrecommend.map((item) {
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        productController.updateTextSearch(item);
                        productController.search();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item,
                            style: TextStyle(color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                listrecommend.remove(item);
                              });
                            },
                            child: Icon(
                              Icons.clear,
                              size: 13,
                            ),
                          )
                        ],
                      ),
                    ));
              }).toList(),
            ),
          ),
          productController.productListSearch.length == 0
              ? Center(
                  child: Text("Không có món ăn nào được hiển thị"),
                )
              : GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: productController.productListSearch.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoute.get_product_detail(
                              productController
                                  .productListSearch[index].productId!));
                          setState(() {
                            if (listrecommend.length < 3) {
                              if (!listrecommend.contains(productController
                                  .productListSearch[index].productName))
                                listrecommend.add(productController
                                    .productListSearch[index].productName!);
                            } else {
                              if (!listrecommend.contains(productController
                                  .productListSearch[index].productName)) {
                                listrecommend.removeAt(0);
                                listrecommend.add(productController
                                    .productListSearch[index].productName!);
                              }
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                width: 1,
                                color: Color.fromRGBO(218, 218, 218, 0.494)),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 170,
                                height: 150,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: MemoryImage(base64Decode(
                                        productController
                                            .productListSearch[index].image!)),
                                  ),
                                ),
                              ),
                              Container(
                                width: 170,
                                padding:
                                    EdgeInsets.only(left: AppDimention.size10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: AppDimention.size5,
                                    ),
                                    Text(
                                      productController.productListSearch[index]
                                          .productName!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.mainColor),
                                    ),
                                    Text(
                                      "${_formatNumber(productController.productListSearch[index].price!.toInt())} vnđ",
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Wrap(
                                              children: List.generate(
                                                  5,
                                                  (index) => Icon(Icons.star,
                                                      color: AppColor.mainColor,
                                                      size: 8)),
                                            ),
                                            Text(
                                              "(5)",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppColor.mainColor),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "1028",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              Icons.chat_bubble_outline_rounded,
                                              size: 12,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: AppDimention.size15),
                                    Row(
                                      children: [
                                        Icon(Icons.delivery_dining_sharp),
                                        Text(
                                          "Miễn phí vận chuyển",
                                          style: TextStyle(fontSize: 10),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ));
                  },
                )
        ],
      );
    });
  }
}
