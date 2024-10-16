import 'dart:convert';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_user_github/data/controller/Category_controller.dart';
import 'package:flutter_user_github/data/controller/Product_controller.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';

class HomeFolder extends StatefulWidget {
  const HomeFolder({Key? key}) : super(key: key);

  @override
  _HomeFolderState createState() => _HomeFolderState();
}

class _HomeFolderState extends State<HomeFolder> {
  int? categorySelected = 0;
  final ProductController productController = Get.find<ProductController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final ScrollController _scrollController = ScrollController();

  bool? loaded = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]}.',
        );
  }

  Future<void> loadData() async {
    while (categoryController.isLoading == true) {
      await Future.delayed(Duration(seconds: 1));
    }
    await productController
        .getProductByCategoryId(categoryController.categoryList[0].categoryId!);
    categorySelected = categoryController.categoryList[0].categoryId;
    setState(() {
      loaded = true;
    });
  }

  void _onCategorySelected(int selectedCategoryId, int index) {
    productController.getProductByCategoryId(selectedCategoryId);
    setState(() {
      categorySelected = selectedCategoryId;
    });

    _scrollController.animateTo(
      index * (AppDimention.size150 + AppDimention.size10),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(
      builder: (categoryController) {
        return categoryController.isLoading!
            ? Container(
                width: AppDimention.screenWidth,
                child: Center(child: CircularProgressIndicator()),
              )
            : Container(
                width: AppDimention.screenWidth,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: AppDimention.size10),
                        Text(
                          "Danh mục sản phẩm",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Container(
                      width: AppDimention.screenWidth,
                      padding: EdgeInsets.only(
                          top: AppDimention.size5, bottom: AppDimention.size15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom:
                                BorderSide(width: 1, color: Colors.black12)),
                      ),
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: _scrollController,
                          child: loaded == true
                              ? Row(
                                  children: List.generate(
                                      categoryController.categoryList.length,
                                      (index) {
                                    final item =
                                        categoryController.categoryList[index];
                                    return GestureDetector(
                                      onTap: () => _onCategorySelected(
                                          item.categoryId!, index),
                                      child: Container(
                                        width: AppDimention.size150,
                                        height: AppDimention.size50,
                                        margin: EdgeInsets.only(
                                            left: AppDimention.size10,
                                            top: AppDimention.size10),
                                        decoration: BoxDecoration(
                                          gradient: item.categoryId ==
                                                  categorySelected
                                              ? LinearGradient(
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                  colors: [
                                                    Colors.amber,
                                                    Colors.white
                                                  ],
                                                )
                                              : null,
                                          border: Border(
                                            bottom: BorderSide(
                                              width: 2,
                                              color: item.categoryId ==
                                                      categorySelected
                                                  ? Colors.amber
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                        child: Center(
                                            child: Text(item.categoryName!)),
                                      ),
                                    );
                                  }),
                                )
                              : Container(
                                  width: AppDimention.screenWidth,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )),
                    ),
                    SizedBox(height: AppDimention.size10),
                    if (loaded == true)
                      Container(
                        width: AppDimention.screenWidth,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: GetBuilder<ProductController>(
                            builder: (productController) {
                              return productController
                                      .isLoadingProductIncategory!
                                  ? CircularProgressIndicator()
                                  : Row(
                                      children: productController
                                          .productListBycategory
                                          .map((item) {
                                        return GestureDetector(
                                          onTap: () {
                                            Get.toNamed(
                                                AppRoute.get_product_detail(
                                                    item.productId!));
                                          },
                                          child: Container(
                                            width: AppDimention.size100 * 2.5,
                                            height: AppDimention.size100 * 3.6,
                                            padding: EdgeInsets.all(
                                                AppDimention.size10),
                                            margin: EdgeInsets.only(
                                                left: AppDimention.size10,
                                                right: AppDimention.size15,
                                                top: AppDimention.size10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppDimention.size10),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width:
                                                      AppDimention.screenWidth,
                                                  height: AppDimention.size100 *
                                                      2.4,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            AppDimention
                                                                .size10),
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: MemoryImage(
                                                          base64Decode(
                                                              item.image!)),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height:
                                                        AppDimention.size20),
                                                Text(item.productName!,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                SizedBox(
                                                    height:
                                                        AppDimention.size10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Wrap(
                                                          children:
                                                              List.generate(5,
                                                                  (index) {
                                                            if (index <
                                                                item.averageRate!
                                                                    .floor()) {
                                                           
                                                              return Icon(
                                                                  Icons.star,
                                                                  color: AppColor
                                                                      .mainColor,
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
                                                                  color: AppColor
                                                                      .mainColor,
                                                                  size: AppDimention
                                                                      .size15);
                                                            } else {
                                                             
                                                              return Icon(
                                                                  Icons
                                                                      .star_border,
                                                                  color: AppColor
                                                                      .mainColor,
                                                                  size: AppDimention
                                                                      .size15);
                                                            }
                                                          }),
                                                        ),
                                                        Text(
                                                            "(${item.averageRate})",style: TextStyle(color: Colors.red),),
                                                      ],
                                                    ),
                                                    Text(
                                                      "đ${_formatNumber(item.price!.toInt())}",
                                                      style: TextStyle(
                                                          color: AppColor
                                                              .mainColor,
                                                          fontSize: 18),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              );
      },
    );
  }
}
