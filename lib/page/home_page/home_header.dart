import 'package:flutter_user_github/data/controller/Auth_controller.dart';
import 'package:flutter_user_github/data/controller/Cart_controller.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final TextEditingController searchController = TextEditingController();
  final authController = Get.find<AuthController>();
  late int lenghtcart = 0 ;
  @override
  void initState() {
    super.initState();
    lenghtcart = Get.find<CartController>().cartlist.length;
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search ...",
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColor.yellowColor,
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
          Obx(() {
            if (!authController.IsLogin.value) {
              return Container(
              );
            } else {
              return Container(
                  width: 40,
                  height: 40,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoute.CART_PAGE);
                          },
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.black,
                            size: AppDimention.size30,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        width: 20,
                        height: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            border: Border.all(color: Colors.white, width: 2),
                            color: AppColor.mainColor,
                          ),
                          child: Container(
                              width: AppDimention.size10,
                              height: AppDimention.size10,
                              child: Center(
                                child: Text(
                                 lenghtcart.toString(),
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              )),
                        ),
                      )
                    ],
                  ),
                );
              }
            }
          ),

          
        ],
      ),
    );
  }
}
