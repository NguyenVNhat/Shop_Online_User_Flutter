
import 'package:flutter_user_github/data/controller/Store_Controller.dart';
import 'package:flutter_user_github/models/Model/Item/StoresItem.dart';
import 'package:flutter_user_github/page/chat_page/home_chart/home_chat_header.dart';
import 'package:flutter_user_github/page/chat_page/store_chat/store_chat_body.dart';
import 'package:flutter_user_github/page/profile_page/profile_footer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreChat extends StatefulWidget {
  const StoreChat({
    Key? key,
  }) : super(key: key);
  @override
  _StoreChatState createState() => _StoreChatState();
}

class _StoreChatState extends State<StoreChat> {

  Storecontroller storecontroller = Get.find<Storecontroller>();
  List<Storesitem> liststore  = [];

  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    liststore = storecontroller.storeList;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:  Color(0xFFF4F4F4),
      body: Column(
        children: [
          HomeChatHeader(),
          Expanded(
              child: SingleChildScrollView(
            child: StoreChatBody()
          )),
        ProfileFooter()
        ],
      ),
    );
  }
}
