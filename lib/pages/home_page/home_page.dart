import 'package:flutter_user_github/data/controller/Product_controller.dart';
import 'package:flutter_user_github/pages/home_page/home_banner.dart';
import 'package:flutter_user_github/pages/home_page/home_combo.dart';
import 'package:flutter_user_github/pages/home_page/home_folder.dart';
import 'package:flutter_user_github/pages/home_page/home_footer.dart';
import 'package:flutter_user_github/pages/home_page/home_header.dart';
import 'package:flutter_user_github/pages/home_page/home_header.dart';
import 'package:flutter_user_github/pages/home_page/home_product.dart';

import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:  Color(0xFFF4F4F4),
      body: Column(
        children: [
          HomeHeader(),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeBanner(),
                HomeFolder(),
                SizedBox(
                  height: AppDimention.size15,
                ),
           
                 Row(
                  children: [
                    SizedBox(width: AppDimention.size10,),
                    Text("Combo trong tuần",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600),),
                  ],
                ),
                SizedBox(
                  height: AppDimention.size10,
                ),
                HomeCombo(),
                SizedBox(
                  height: AppDimention.size15,
                ),
                SizedBox(
                  height: AppDimention.size15,
                ),
                HomeProduct(),
                
                if (Get.find<ProductController>().productList.length > 10)
                  Container(
                    width: AppDimention.screenWidth,
                    height: 50,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoute.SEARCH_PAGE);
                        },
                        child: Text("Xem thêm"),
                      ),
                    ),
                  )
              ],
            ),
          )),
          HomeFooter(),
        ],
      ),
    );
  }
}
