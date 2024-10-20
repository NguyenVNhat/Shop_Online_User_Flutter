import 'package:flutter_user_github/data/controller/Cart_controller.dart';
import 'package:flutter_user_github/data/controller/Category_controller.dart';
import 'package:flutter_user_github/data/controller/Combo_controller.dart';
import 'package:flutter_user_github/data/controller/Product_controller.dart';
import 'package:flutter_user_github/data/controller/Size_controller.dart';
import 'package:flutter_user_github/data/controller/Store_Controller.dart';
import 'package:flutter_user_github/data/controller/User_controller.dart';
import 'package:flutter_user_github/page/login_page/loading/animation.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BarLoadingScreen extends StatefulWidget {
  @override
  _BarLoadingScreenState createState() => _BarLoadingScreenState();
}

class _BarLoadingScreenState extends State<BarLoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  CartController cartController = Get.find<CartController>();
  UserController userController = Get.find<UserController>();
  SizeController sizeController = Get.find<SizeController>();
  ComboController comboController = Get.find<ComboController>();
  ProductController productController = Get.find<ProductController>();
  Storecontroller storecontroller = Get.find<Storecontroller>();
  CategoryController categoryController = Get.find<CategoryController>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _controller.repeat().orCancel;
    loading();
  }


  void loading() async {
    while (cartController.isLoading ||
        userController.isLoading ||
        sizeController.isLoading ||
        comboController.isLoading ||
        productController.isLoading ||
        storecontroller.isLoading ||
        categoryController.isLoading!) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    Get.toNamed(AppRoute.HOME_PAGE);
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  Tween<double> tween = Tween<double>(begin: 0.0, end: 1.00);
  Animation<double> get stepOne => tween.animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.0,
            0.125,
            curve: Curves.linear,
          ),
        ),
      );
  Animation<double> get stepTwo => tween.animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.125,
            0.26,
            curve: Curves.linear,
          ),
        ),
      );
  Animation<double> get stepThree => tween.animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.25,
            0.375,
            curve: Curves.linear,
          ),
        ),
      );
  Animation<double> get stepFour => tween.animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.375,
            0.5,
            curve: Curves.linear,
          ),
        ),
      );
  Animation<double> get stepFive => tween.animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.5,
            0.625,
            curve: Curves.linear,
          ),
        ),
      );
  Animation<double> get stepSix => tween.animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.625,
            0.75,
            curve: Curves.linear,
          ),
        ),
      );
  Animation<double> get stepSeven => tween.animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.75,
            0.875,
            curve: Curves.linear,
          ),
        ),
      );
  Animation<double> get stepEight => tween.animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.875,
            1.0,
            curve: Curves.linear,
          ),
        ),
      );

  Widget get forwardStaggeredAnimation {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PivotBar(
            alignment: FractionalOffset.centerLeft,
            controller: _controller,
            animations: [
              stepOne,
              stepTwo,
            ],
            marginRight: 0.0,
            marginLeft: 0.0,
            isClockwise: true,
          ),
          PivotBar(
            controller: _controller,
            animations: [
              stepThree,
              stepEight,
            ],
            marginRight: 0.0,
            marginLeft: 0.0,
            isClockwise: false,
          ),
          PivotBar(
            controller: _controller,
            animations: [
              stepFour,
              stepSeven,
            ],
            marginRight: 0.0,
            marginLeft: 32.0,
            isClockwise: true,
          ),
          PivotBar(
            controller: _controller,
            animations: [
              stepFive,
              stepSix,
            ],
            marginRight: 0.0,
            marginLeft: 32.0,
            isClockwise: false,
          ),
        ],
      ),
    );
  }

  Widget getForwardStaggeredAnimation() {
    return forwardStaggeredAnimation;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: AppDimention.screenWidth,
        height: AppDimention.screenHeight,
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/image/LoadingBg.png"))),
        child: forwardStaggeredAnimation,);
  }
}
