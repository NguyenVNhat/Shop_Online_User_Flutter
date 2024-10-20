import 'package:flutter_user_github/page/chat_page/home_chart/home_chat.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeChatHeader extends StatefulWidget {
  const HomeChatHeader({
    Key? key,
  }) : super(key: key);
  @override
  _HomeChatHeaderState createState() => _HomeChatHeaderState();
}

class _HomeChatHeaderState extends State<HomeChatHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimention.screenWidth,
      height: AppDimention.size100 * 1.6,
      padding: EdgeInsets.only(
          left: AppDimention.size20, right: AppDimention.size20),
      decoration: BoxDecoration(color: AppColor.mainColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                 Get.to(HomeChat());
                },
                child: Text("Tin nhắn",
                    style: GoogleFonts.fuzzyBubbles(
                      textStyle: TextStyle(
                          fontSize: AppDimention.size30, color: Colors.white),
                    )),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoute.STORE_CHAT_PAGE);
                },
                child: Icon(
                  Icons.store,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoute.SEARCH_CHAT_PAGE);
                },
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 30,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
