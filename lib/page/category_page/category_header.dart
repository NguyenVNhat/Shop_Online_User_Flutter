import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryHeader extends StatefulWidget {
  const CategoryHeader({Key? key}) : super(key: key);

  @override
  _CategoryHeaderState createState() => _CategoryHeaderState();
}

class _CategoryHeaderState extends State<CategoryHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: AppDimention.screenWidth,
          height: AppDimention.size100,
          decoration: BoxDecoration(color: AppColor.mainColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.highlight_remove_rounded,
                  color: Colors.white,
                  size: AppDimention.size40,
                ),
              ),
              Container(
                width: AppDimention.size100 * 2,
                child: Center(
                  child: Text(
                    "THỰC ĐƠN",
                    style: TextStyle(
                      fontSize: AppDimention.size20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoute.CART_PAGE);
                },
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                  size: AppDimention.size40,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
