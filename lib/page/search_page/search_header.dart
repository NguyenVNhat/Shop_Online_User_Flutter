import 'package:flutter_user_github/data/controller/Product_controller.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchHeader extends StatefulWidget {
  const SearchHeader({
    Key? key,
  }) : super(key: key);

  @override
  _SearchHeaderState createState() => _SearchHeaderState();
}

class _SearchHeaderState extends State<SearchHeader> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      searchController.text = productController.textSearch;
      return Container(
        margin: EdgeInsets.only(
            top: AppDimention.size40, bottom: AppDimention.size20),
        padding: EdgeInsets.only(
            left: AppDimention.size20, right: AppDimention.size20),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoute.CAMERA_PAGE);
              },
              child: Icon(
                Icons.camera_alt_outlined,
                color: AppColor.mainColor,
              ),
            ),
            SizedBox(width: AppDimention.size10),
            Expanded(
              child: TextField(
                onChanged: (Text) {
                  productController.textSearch = searchController.text;
                  productController.search();
                },
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search ... ",
                  prefixIcon: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: AppColor.yellowColor,
                    ),
                    onPressed: () {
                      productController.search();
                    },
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimention.size30),
                    borderSide: BorderSide(width: 1.0, color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimention.size30),
                    borderSide: BorderSide(width: 1.0, color: Colors.white),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimention.size30),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: AppDimention.size5,
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoute.CART_PAGE);
              },
              child: Icon(Icons.shopping_cart_outlined),
            )
          ],
        ),
      );
    });
  }
}
