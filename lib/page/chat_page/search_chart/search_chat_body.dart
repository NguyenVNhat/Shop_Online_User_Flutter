import 'package:flutter_user_github/data/controller/Chart_controller.dart';
import 'package:flutter_user_github/models/Model/Messagemodel.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchChatBody extends StatefulWidget {
  const SearchChatBody({
    Key? key,
  }) : super(key: key);
  @override
  _SearchChatBodyState createState() => _SearchChatBodyState();
}

class _SearchChatBodyState extends State<SearchChatBody> {
  ChartController chartController = Get.find<ChartController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChartController>(
      builder: (listusercontroller) {
        return  listusercontroller.igetLoadingSearch ? Center(child: Text("Không tìm thấy người dùng"),) : Column(
                children: listusercontroller.listUserSearch.map((item) {
                  return GestureDetector(
                    onTap: ()  {
                      Get.toNamed(AppRoute.user_chat_detail(item.id!));
                    },
                    child: Container(
                      width: AppDimention.screenWidth,
                      height: AppDimention.size80,
                      padding: EdgeInsets.only(left: AppDimention.size10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: AppDimention.size60,
                            height: AppDimention.size60,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(AppDimention.size100),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        "assets/image/LoadingBg.png"))),
                          ),
                          SizedBox(width: AppDimention.size10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.circle,color: Colors.green,size: 18,),
                                  SizedBox(width: AppDimention.size5,),
                                  Text(
                                    item.fullName.toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: AppDimention.size100 * 2.2,
                                margin:
                                    EdgeInsets.only(top: AppDimention.size10),
                                child: Text(
                                  "Hope you are my best best best best best best  ",
                                  style: TextStyle(color: Colors.black54),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
      },
    );
  }
}
