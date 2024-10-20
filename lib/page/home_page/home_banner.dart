import 'package:flutter_user_github/route/app_route.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:get/get.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({Key? key}) : super(key: key);

  @override
  _HomeBannerState createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  PageController pageController = PageController(viewportFraction: 1);
  double currentPageValue = 0.0;
  final double _scaleFactor = 0.8;
  final double _height = AppDimention.size100 * 3;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        if (pageController.page != null) {
          currentPageValue = pageController.page!;
        }
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      width: double.maxFinite,
      child: Column(
        children: [
          Container(
            height: AppDimention.size100 * 2.5,
           
            child: PageView.builder(
              controller: pageController,
              itemCount: 3,
              itemBuilder: (context, position) {
                return _buildView(position);
              },
            ),
          ),
          DotsIndicator(
            dotsCount: 3,
            position: currentPageValue,
            decorator: DotsDecorator(
              activeColor: AppColor.mainColor,
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildView(int index) {
    Matrix4 matrix = Matrix4.identity();
    if (index == currentPageValue.floor()) {
      var currentScale = 1 - (currentPageValue - index) * (1 - _scaleFactor);
      var currentTransform = _height * (1 - currentScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, currentTransform, 0);
    } else if (index == currentPageValue.floor() + 1) {
      var currentScale =
          _scaleFactor + (currentPageValue - index + 1) * (1 - _scaleFactor);
      var currentTransform = _height * (1 - currentScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, currentTransform, 0);
    } else if (index == currentPageValue.floor() - 1) {
      var currentScale = 1 - (currentPageValue - index) * (1 - _scaleFactor);
      var currentTransform = _height * (1 - currentScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, currentTransform, 0);
    } else {
      matrix = Matrix4.diagonal3Values(1, _scaleFactor, 1)
        ..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 0);
    }

    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoute.get_combo_detail(index));
            },
            child: Container(
              height: AppDimention.size100 * 2.4,
               margin: EdgeInsets.only(left: AppDimention.size10,right: AppDimention.size10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimention.size10),
                color: Color(0xFF69c5df),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/image/banner_${index + 1}.jpg"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
