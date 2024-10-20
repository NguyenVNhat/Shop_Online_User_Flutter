import 'package:flutter_user_github/page/chat_page/home_chart/home_chat_body.dart';
import 'package:flutter_user_github/page/chat_page/home_chart/home_chat_header.dart';
import 'package:flutter_user_github/page/profile_page/profile_footer.dart';
import 'package:flutter/material.dart';

class HomeChat extends StatefulWidget {
  const HomeChat({
    Key? key,
  }) : super(key: key);
  @override
  _HomeChatState createState() => _HomeChatState();
}

class _HomeChatState extends State<HomeChat> {
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
            child: HomeChatBody()
          )),
        ProfileFooter()
        ],
      ),
    );
  }
}
