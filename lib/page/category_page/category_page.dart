import 'package:flutter_user_github/page/category_page/category_header.dart';
import 'package:flutter_user_github/page/category_page/category_list.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({
    Key? key,
  }) : super(key: key);
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CategoryHeader(),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [CategoryList()],
            ),
          )),
        ],
      ),
    );
  }
}
