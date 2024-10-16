import 'dart:convert';

import 'package:flutter_user_github/data/controller/Product_controller.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeProduct extends StatefulWidget {
  const HomeProduct({
    Key? key,
  }) : super(key: key);

  @override
  _HomeProductState createState() => _HomeProductState();
}

class _HomeProductState extends State<HomeProduct> {
  @override
  void initState() {
    super.initState();
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]}.',
        );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      return productController.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: AppDimention.size10,
                    ),
                    Text(
                      "Sản phẩm bán chạy",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
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
                                        .productList[index].image!)),
                              ),
                            ),
                          ),
                          Container(
                            width: 170,
                            padding: EdgeInsets.only(left: AppDimention.size10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: AppDimention.size5,
                                ),
                                Text(
                                  productController
                                      .productList[index].productName!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.mainColor),
                                ),
                                Text(
                                  "đ${ _formatNumber(productController.productList[index].price!.toInt()) }",
                                  style: TextStyle(fontSize: 13),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                       Wrap(
                                                          children:
                                                              List.generate(5,
                                                                  (index) {
                                                            if (index <
                                                                productController.productList[index].averageRate!
                                                                    .floor()) {
                                                           
                                                              return Icon(
                                                                  Icons.star,
                                                                  color: AppColor
                                                                      .mainColor,
                                                                  size: AppDimention
                                                                      .size15);
                                                            } else if (index ==
                                                                    productController.productList[index].averageRate!
                                                                        .floor() &&
                                                                productController.productList[index].averageRate! %
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
                    );
                  },
                )
              ],
            );
    });
  }
}
