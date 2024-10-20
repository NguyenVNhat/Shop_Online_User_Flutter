
import 'package:flutter_user_github/page/chat_page/search_chart/search_chat_body.dart';
import 'package:flutter_user_github/page/chat_page/search_chart/search_chat_header.dart';
import 'package:flutter_user_github/page/profile_page/profile_footer.dart';
import 'package:flutter/material.dart';

class SearchChat extends StatefulWidget {
  const SearchChat({
    Key? key,
  }) : super(key: key);
  @override
  _SearchChatState createState() => _SearchChatState();
}

class _SearchChatState extends State<SearchChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:  Color(0xFFF4F4F4),
      body: Column(
        children: [
          SearchChatHeader(),
          Expanded(
              child: SingleChildScrollView(
            child: SearchChatBody()
          )),
        ProfileFooter()
        ],
      ),
    );
  }
}
