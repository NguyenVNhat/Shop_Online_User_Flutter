import 'package:flutter_user_github/data/controller/Product_controller.dart';
import 'package:flutter_user_github/pages/home_page/home_banner.dart';
import 'package:flutter_user_github/pages/home_page/home_combo.dart';
import 'package:flutter_user_github/pages/home_page/home_folder.dart';
import 'package:flutter_user_github/pages/home_page/home_footer.dart';
import 'package:flutter_user_github/pages/home_page/home_header.dart';

import 'package:flutter_user_github/pages/profile_page/promotion_page/promotion_body.dart';
import 'package:flutter_user_github/pages/profile_page/promotion_page/promotion_header.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PromotionPage extends StatefulWidget {
  const PromotionPage({
    Key? key,
  }) : super(key: key);
  @override
  _PromotionPageState createState() => _PromotionPageState();
}

class _PromotionPageState extends State<PromotionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          PromotionHeader(),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                PromotionBody(),
              ],
            ),
          )),

        ],
      ),
    );
  }
}
