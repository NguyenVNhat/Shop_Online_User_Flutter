import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';

class LoginTextfield extends StatefulWidget {
  final TextEditingController? controller;
  final String? title;
  final int? type;

  LoginTextfield({
    this.controller,
    this.title,
    this.type,
    Key? key,
  }) : super(key: key);

  @override
  _LoginTextfieldState createState() => _LoginTextfieldState();
}

class _LoginTextfieldState extends State<LoginTextfield> {
  late TextEditingController? controller;
  late String? title;
  late int? type;

  
  bool isShow = true;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    title = widget.title;
    type = widget.type;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimention.screenWidth,
      padding: EdgeInsets.only(
        left: AppDimention.size20,
        right: AppDimention.size20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title!,
            style: TextStyle(color: Colors.black54, fontSize: 18),
          ),
          SizedBox(height: AppDimention.size10),
          type == 1
              ? Container(
                  width: AppDimention.screenWidth,
                  height: AppDimention.size60,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimention.size20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "......",
                      hintStyle: TextStyle(color: Colors.black26, fontSize: 13),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: AppDimention.size15),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 0, color: Colors.grey.withOpacity(0.1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 0, color: Colors.grey.withOpacity(0.1)),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimention.size30),
                      ),
                    ),
                  ),
                )
              : Container(
                  width: AppDimention.screenWidth,
                  height: AppDimention.size60,
                  padding: EdgeInsets.symmetric(
                      horizontal: AppDimention.size10),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: AppDimention.screenWidth * 0.76,
                        height: AppDimention.size60,
                        child: TextField(
                          obscureText: isShow, 
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: "......",
                            hintStyle:
                                TextStyle(color: Colors.black26, fontSize: 13),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: AppDimention.size15),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size30),
                              borderSide: BorderSide(
                                  width: 0,
                                  color: Colors.grey.withOpacity(0.1)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size30),
                              borderSide: BorderSide(
                                  width: 0,
                                  color: Colors.grey.withOpacity(0.1)),
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size30),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isShow = !isShow; 
                          });
                        },
                        child: Icon(
                          isShow
                              ? Icons.visibility 
                              : Icons.visibility_off, 
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
