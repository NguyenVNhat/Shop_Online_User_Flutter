import 'package:flutter_user_github/page/profile_page/profile_setup_page/manifest_social/dataManifest.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManifestSocial extends StatefulWidget {
  const ManifestSocial({
    Key? key,
  }) : super(key: key);
  @override
  _ManifestSocialState createState() => _ManifestSocialState();
}

class _ManifestSocialState extends State<ManifestSocial> {
  Datamanifest datamanifest = Datamanifest();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFF4F4F4),
      body: Column(
        children: [
          Container(
            width: AppDimention.screenWidth,
            height: AppDimention.size60,
            padding: EdgeInsets.all(AppDimention.size10),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Colors.black26))),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back_ios_new),
                ),
                SizedBox(
                  width: AppDimention.size20,
                ),
                Text(
                  "Tiêu chuẩn cộng đồng",
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppDimention.screenWidth,
                  height: AppDimention.size100 * 1.5,
                  child: Center(
                    child: Text(
                      "TIÊU CHUẨN CỘNG ĐỒNG",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  width: AppDimention.screenWidth,
                  padding: EdgeInsets.all(AppDimention.size10),
                  child: Text(
                    "${datamanifest.first}",
                    textAlign: TextAlign.justify,
                  ),
                ),
                Container(
                  width: AppDimention.screenWidth,
                  height: AppDimention.size80,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1, color: Colors.black54))),
                  child: Center(
                    child: Text(
                      "Những việc nên làm",
                      style: TextStyle(
                          fontSize: 25,
                          color: const Color.fromARGB(255, 24, 230, 168),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Column(
                  children: datamanifest.second
                      .map((item) => Container(
                            width: AppDimention.screenWidth,
                            padding: EdgeInsets.all(AppDimention.size10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${item.keys.join(', ')}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                                SizedBox(
                                  height: AppDimention.size10,
                                ),
                                Text(
                                  "${item.values.join(', ')}",
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
                Container(
                  width: AppDimention.screenWidth,
                  height: AppDimention.size80,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1, color: Colors.black54))),
                  child: Center(
                    child: Text(
                      "Những việc không nên làm",
                      style: TextStyle(
                          fontSize: 25,
                          color: const Color.fromARGB(255, 24, 230, 168),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Column(
                  children: datamanifest.third
                      .map((item) => Container(
                            width: AppDimention.screenWidth,
                            padding: EdgeInsets.all(AppDimention.size10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${item.keys.join(', ')}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                                SizedBox(
                                  height: AppDimention.size10,
                                ),
                                Text(
                                  "${item.values.join(', ')}",
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
                Container(
                  width: AppDimention.screenWidth,
                  height: AppDimention.size80,
                  margin: EdgeInsets.all(AppDimention.size10),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1,color: Colors.black54))
                  ),
                ),
                Container(
                  width: AppDimention.screenWidth,
                  padding: EdgeInsets.all(AppDimention.size10),
                  margin: EdgeInsets.only(bottom:  AppDimention.size10),
                  child: Text("${datamanifest.fourth}",textAlign: TextAlign.justify,),
                ),
                 Container(
                  width: AppDimention.screenWidth,
                  padding: EdgeInsets.all(AppDimention.size10),
                  margin: EdgeInsets.only(bottom:  AppDimention.size10),
                  child: Text("${datamanifest.fifth}",textAlign: TextAlign.justify,),
                ),
                Container(
                  width: AppDimention.screenWidth,
                  padding: EdgeInsets.all(AppDimention.size10),
                  margin: EdgeInsets.only(bottom:  AppDimention.size10),
                  child: Text("Được xây dựng bởi đội ngũ thân thiện của",textAlign: TextAlign.justify,),
                ),
                Center(
                  child: Container(
                    width: AppDimention.size100,
                    height: AppDimention.size100,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage("assets/image/logo.png"),fit: BoxFit.cover)
                    ),
                  ),
                )


              ],
            ),
          )),
        ],
      ),
    );
  }
}
