import 'dart:convert';

import 'package:flutter_user_github/data/controller/Store_Controller.dart';
import 'package:flutter_user_github/models/Model/Item/StoresItem.dart';
import 'package:flutter_user_github/page/chat_page/store_chat/AutoChat.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StoreChatDetail extends StatefulWidget {
  final int storeid;
  const StoreChatDetail({
    required this.storeid,
    Key? key,
  }) : super(key: key);

  @override
  _StoreChatDetailState createState() => _StoreChatDetailState();
}

class _StoreChatDetailState extends State<StoreChatDetail> {
  int indexChat = 0;
  List<List<String>> listQuestion = [];
  List<Widget> listWidgets = [];
  late Quiz quiz;
  Storecontroller storecontroller = Get.find<Storecontroller>();
  Storesitem? storesitem;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    loadQuestion();
    quiz = Quiz(storeId: widget.storeid);
    loadingData();
  }

  void loadingData() async {
    storecontroller.getbyid(widget.storeid);
    while (storecontroller.isLoadingItem) {
      await Future.delayed(const Duration(microseconds: 100));
    }
    storesitem = storecontroller.storeItem;
    setState(() {
      loaded = true;
    });
  }

  String formatTime(String isoDateTime) {
    DateTime dateTime = DateTime.parse(isoDateTime);
    return DateFormat('hh:mm').format(dateTime);
  }

  void loadQuestion() {
    listQuestion.addAll([
      [
        "Tôi muốn xem danh mục sản phẩm của cửa hàng bạn .",
        "Tôi muốn xem danh sách sản phẩm của cửa hàng .",
        "Tôi muốn xem danh sách các combo đang có .",
        "Hãy hiển thị bản đồ đến cửa hàng của bạn .",
        "Thời gian mà cửa hàng hoạt động trong ngày .",
        "Xem chi tiết cửa hàng ."
      ],
    ]);
  }

  Widget newWidget(String answers) {
    for (Question item in quiz.questions) {
      if (item.selection.contains(answers)) {
        return FutureBuilder<Widget>(
          future: item.answers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return snapshot.data ?? Container();
            }
          },
        );
      }
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> combinedList = [];
    for (int i = 0; i <= indexChat; i++) {
      combinedList.add(Align(
        alignment: Alignment.centerRight,
        child: Container(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
            margin: EdgeInsets.only(top: 10, right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimention.size10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppDimention.screenWidth * 2 / 3,
                  margin: EdgeInsets.only(bottom: AppDimention.size10),
                  child: Text(
                      "Chào bạn , chúng tôi có thể giúp gì cho bạn không ?"),
                ),
                Column(
                  children: List.generate(
                    listQuestion[0].length,
                    (j) => GestureDetector(
                      onTap: () {
                        setState(() {
                          indexChat = indexChat + 1;
                          listWidgets.add(newWidget(listQuestion[0][j]));
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(AppDimention.size10),
                        margin: EdgeInsets.only(bottom: AppDimention.size10),
                        width: AppDimention.screenWidth * 2 / 3,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 244, 250, 255),
                          borderRadius:
                              BorderRadius.circular(AppDimention.size5),
                        ),
                        child: Text(
                          listQuestion[0][j],
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ));

      if (i < listWidgets.length) {
        combinedList.add(listWidgets[i]);
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFF4F4F4),
      body: Column(
        children: [
          Container(
            width: AppDimention.screenWidth,
            height: AppDimention.size100,
            padding: EdgeInsets.only(
                left: AppDimention.size10, right: AppDimention.size10),
            decoration: BoxDecoration(color: AppColor.mainColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                loaded ?
                GestureDetector(
                  onTap: () {
                    Get.toNamed(
                        AppRoute.user_chat_detail(storesitem!.managerId!));
                  },
                  child: Container(
                    width: AppDimention.size100 * 2,
                    height: AppDimention.size60,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(AppDimention.size10)),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${storesitem!.storeName}"),
                          Text("Liên hệ chủ cửa hàng"),
                        ],
                      ),
                    ),
                  ),
                ):Center(child: CircularProgressIndicator(),)
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.only(bottom: AppDimention.size40),
                  child: Column(
                    children: [
                      loaded
                          ? Column(
                              children: [
                                Container(
                                  width: AppDimention.screenWidth,
                                  margin: EdgeInsets.only(
                                      top: AppDimention.size10,
                                      left: AppDimention.size10,
                                      right: AppDimention.size10),
                                  height: AppDimention.size100 * 2.2,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                              AppDimention.size10),
                                          topRight: Radius.circular(
                                              AppDimention.size10)),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: MemoryImage(base64Decode(
                                              storesitem!.image!)))),
                                ),
                                Container(
                                  width: AppDimention.screenWidth,
                                  margin: EdgeInsets.only(
                                      bottom: AppDimention.size10,
                                      left: AppDimention.size10,
                                      right: AppDimention.size10),
                                  padding: EdgeInsets.all(AppDimention.size10),
                                  height: AppDimention.size100 * 2.3,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(
                                              AppDimention.size10),
                                          bottomRight: Radius.circular(
                                              AppDimention.size10)),
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 1, color: Colors.black12),
                                          left: BorderSide(
                                              width: 1, color: Colors.black12),
                                          right: BorderSide(
                                              width: 1,
                                              color: Colors.black12))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Cửa hàng : ${storesitem!.storeName}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: AppDimention.size10,
                                      ),
                                      Text("Địa chỉ : ${storesitem!.location}"),
                                      SizedBox(
                                        height: AppDimention.size10,
                                      ),
                                      Text(
                                          "Số điện thoại : ${storesitem!.numberPhone}"),
                                      SizedBox(
                                        height: AppDimention.size10,
                                      ),
                                      Text(
                                          "Thời gian hoạt động : ${formatTime(storesitem!.openingTime!) + " - " + formatTime(storesitem!.closingTime!)}"),
                                      SizedBox(
                                        height: AppDimention.size10,
                                      ),
                                      Center(
                                          child: GestureDetector(
                                        onTap: () {
                                          Get.toNamed(AppRoute.get_store_detail(
                                              storesitem!.storeId!));
                                        },
                                        child: Container(
                                          width: AppDimention.size120,
                                          height: AppDimention.size40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppDimention.size10),
                                              border: Border.all(
                                                  width: 1,
                                                  color: AppColor.yellowColor)),
                                          child: Center(
                                            child: Text(
                                              "Chi tiết",
                                              style: TextStyle(
                                                  color: AppColor.mainColor),
                                            ),
                                          ),
                                        ),
                                      ))
                                    ],
                                  ),
                                )
                              ],
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
                      Column(
                        children: combinedList,
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
