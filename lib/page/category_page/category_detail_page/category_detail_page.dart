import 'package:flutter_user_github/page/category_page/category_detail_page/category_detail_header.dart';
import 'package:flutter_user_github/page/category_page/category_detail_page/category_detail_list.dart';
import 'package:flutter/material.dart';

class CategoryDetailPage extends StatefulWidget {
  final int categoryid;
  final String categoryname;
  const CategoryDetailPage({
    Key? key,
    required this.categoryid,
    required this.categoryname,
  }) : super(key: key);
  @override
  _CategoryDetailPageState createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CategoryDetailHeader(categoryname: widget.categoryname),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [CategoryDetailList(categoryid: widget.categoryid)],
            ),
          )),
        ],
      ),
    );
  }
}
