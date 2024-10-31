import 'package:flutter_user_github/data/controller/Cart_controller.dart';
import 'package:flutter_user_github/page/cart_page/cart_footer.dart';
import 'package:flutter_user_github/page/cart_page/cart_header.dart';
import 'package:flutter_user_github/page/cart_page/cart_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    Key? key,
  }) : super(key: key);
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  CartController cartController =  Get.find<CartController>();
  @override
  void initState() {
    super.initState();
    cartController.getall();
    cartController.getListCartV2();
    cartController.resetIDSelected();
    cartController.getDistinctStoreId();

    cartController.updateTotal(cartController.totalprice, false);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CartHeader(),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                CartList(),
              ],
            ),
          )),
          CartFooter()
        ],
      ),
    );
  }
}
