
import 'package:flutter_user_github/page/profile_page/promotion_page/promotion_body.dart';
import 'package:flutter_user_github/page/profile_page/promotion_page/promotion_header.dart';
import 'package:flutter/material.dart';

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
