import 'package:flutter_user_github/data/controller/Chart_controller.dart';
import 'package:flutter_user_github/data/controller/Store_Controller.dart';
import 'package:flutter_user_github/models/Model/Item/StoresItem.dart';
import 'package:flutter_user_github/models/Model/Messagemodel.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreChatBody extends StatefulWidget {
  const StoreChatBody({
    Key? key,
  }) : super(key: key);
  @override
  _StoreChatBodyState createState() => _StoreChatBodyState();
}

class _StoreChatBodyState extends State<StoreChatBody> {
  Storecontroller storecontroller = Get.find<Storecontroller>();
  List<Storesitem> listStore = [];
  bool loaded = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    
  }
  void loadData(){
    setState(() {
      listStore =  storecontroller.storeList;
      loaded = true;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChartController>(
      builder: (listusercontroller) {
        return !loaded
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: listStore.map((item) {
                  return GestureDetector(
                    onTap: ()  {
                      Get.toNamed(AppRoute.store_chat_detail(item.storeId!));
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
                                    item.storeName.toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
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
