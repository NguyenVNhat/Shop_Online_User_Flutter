import 'dart:convert';

import 'package:flutter_user_github/data/controller/Category_controller.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({
    Key? key,
  }) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController) {
      return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 1.0,
        ),
        itemCount: categoryController.categoryList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Get.toNamed(AppRoute.get_product_bycategoryid_detail(
                  categoryController.categoryList[index].categoryId!,
                  categoryController.categoryList[index].categoryName!));
            },
            child: Container(
              width: 150,
              height: 150,
              margin: index % 2 == 0
                  ? EdgeInsets.only(left: AppDimention.size10)
                  : EdgeInsets.only(right: AppDimention.size10),
              decoration: BoxDecoration(
                color: AppColor.mainColor,
                border:
                    Border.all(width: 1, color: Color.fromRGBO(0, 0, 0, 0.5)),
                borderRadius: BorderRadius.circular(AppDimention.size10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: MemoryImage(base64Decode(
                      categoryController.categoryList[index].image!)),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Container(
                      width: AppDimention.size150 + AppDimention.size30,
                      height: AppDimention.size50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(AppDimention.size10),
                              bottomRight:
                                  Radius.circular(AppDimention.size10)),
                          color: AppColor.mainColor),
                      child: Center(
                        child: Text(
                          categoryController.categoryList[index].categoryName!,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: AppDimention.size20),
                        ),
                      ))
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
