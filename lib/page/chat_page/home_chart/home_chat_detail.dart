import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_user_github/data/api/AppConstant.dart';
import 'package:flutter_user_github/data/controller/Chart_controller.dart';
import 'package:flutter_user_github/data/controller/User_controller.dart';
import 'package:flutter_user_github/models/Model/ChartModel.dart';
import 'package:flutter_user_github/models/Model/Messagemodel.dart';
import 'package:flutter_user_github/models/Model/UserModel.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_socket_channel/io.dart';

class HomeChatDetail extends StatefulWidget {
  final int idreceiver;
  const HomeChatDetail({
    required this.idreceiver,
    Key? key,
  }) : super(key: key);
  @override
  _HomeChatDetailState createState() => _HomeChatDetailState();
}

class _HomeChatDetailState extends State<HomeChatDetail> {
  List<Usermessage> listchart = [];
  late ChartController chatController = Get.find<ChartController>();
  TextEditingController sendController = TextEditingController();
  late UserController userController = Get.find<UserController>();
  ScrollController _scrollController = ScrollController();
  FocusNode focusNode = FocusNode();

  User? user2;
  User? user1;
  bool loaded = false;
  File? _image;
  String imagebase64 = "";

  late IOWebSocketChannel _channel;
  StreamSubscription? _subscription;

  bool isPicking = false;
  bool haveImage = false;
  @override
  void initState() {
    super.initState();
    loadData(widget.idreceiver);
    print("Start socket");
    HttpClient client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    _channel = IOWebSocketChannel.connect(
      Uri.parse('ws://${Appconstant.IP}:${Appconstant.PORT}/ws/chat'),
      customClient: client,
    );
    startSessionSocket();

    _subscription = _channel.stream.listen((message) {
      setState(() {
        var decodedMessage = jsonDecode(message);
        //if(decodedMessage["type"] =="sendMessage")
            listchart.add(Usermessage.fromJson(decodedMessage));
        
      });
      print("Tin nhắn nhận được: $message");
      _scrollToBottom();
    });

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        print(":focus");
        _scrollToBottom();
      }
    });
  }

  void startSessionSocket() {
    final data = {
      "type": "identify",
      "userId": user1!.id,
    };
    _channel.sink.add(jsonEncode(data));
    print("Start success");
  }

  Future<void> loadData(int idreceiver) async {
    setState(() {
      loaded = false;
      listchart.clear();
    });

    user1 = userController.userprofile;
    await chatController.getlistmessage(idreceiver);
    user2 = await userController.getbyid(idreceiver);

    // Đợi cho đến khi dữ liệu được tải xong
    while (chatController.getisLoadingMessage || userController.loadreceiver!) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    setState(() {
      listchart = chatController.getlistusermesage;
      loaded = true;
    });
    _scrollToBottom();
  }

  Future<void> _pickImage() async {
    if (isPicking) return;
    setState(() {
      isPicking = true;
    });
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        List<int> imageBytes = await imageFile.readAsBytes();
        String base64Image = base64Encode(imageBytes);
        setState(() {
          _image = imageFile;
          imagebase64 = base64Image;
          haveImage = true;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    } finally {
      setState(() {
        isPicking = false;
      });
    }
  }

  void _sendMessage() {
    String message = sendController.text.trim();
    if (imagebase64.isEmpty == false) {
      final data = {
        "sender": user1!.id,
        "receiver": user2!.id,
        "message": "",
        "localTime": "",
        "image": "",
        "type": "sendImage"
      };
      chatController.senImage(user1!.id!, user2!.id!, imagebase64);
    
      Usermessage usermessage = Usermessage(
          image: imagebase64,
          localTime: "",
          message: "",
          receiver: user2!.id,
          sender: user1!.id);
      listchart.add(usermessage);
      imagebase64 = "";
        
      _channel.sink.add(jsonEncode(data));
    } else {
      final data = {
        "sender": user1!.id,
        "receiver": user2!.id,
        "message": message,
        "localTime": "",
        "image": "",
        "type": "sendMessage"
      };
      _channel.sink.add(jsonEncode(data));
    }


    sendController.clear();
    userController.addannouceV2(
        user2!.id!, "Thông báo", "Bạn vừa có tin nhắn từ ${user1!.fullName!}");

    setState(() {
      haveImage = false;
    });
    _scrollToBottom();
  }

  Future<void> updateData(int idreceiver) async {
    await loadData(idreceiver);
    setState(() {
      _image = null;
      imagebase64 = "";
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _subscription?.cancel(); // Hủy bỏ listener khi dispose
    _channel.sink.close();
    focusNode.dispose();
    sendController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFF4F4F4),
      body: Column(
        children: [
          // header
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
                loaded
                    ? Text(
                        user2!.fullName!,
                        style: TextStyle(
                            color: Colors.white, fontSize: AppDimention.size20),
                      )
                    : CircularProgressIndicator()
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
                controller: _scrollController,
                child: !loaded
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                        padding: EdgeInsets.only(bottom: AppDimention.size40),
                        child: Column(
                          children: listchart
                              .map((item) => Align(
                                  alignment: item.sender == user2!.id
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  child: Column(
                                    children: [
                                      if (item.image != null &&
                                          item.image!.isNotEmpty)
                                        Container(
                                          width: AppDimention.size100 * 2,
                                          height: AppDimention.size100 * 2,
                                          padding: EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              bottom: 10,
                                              top: 10),
                                          margin: EdgeInsets.only(top: 10),
                                          decoration: BoxDecoration(
                                            color: item.sender == user2!.id
                                                ? const Color.fromARGB(
                                                    66, 48, 40, 15)
                                                : AppColor.mainColor,
                                            borderRadius: BorderRadius.circular(
                                                AppDimention.size10),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: MemoryImage(
                                                  base64Decode(item.image!)),
                                            ),
                                          ),
                                        )
                                      else
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              bottom: 10,
                                              top: 10),
                                          margin: EdgeInsets.only(top: 10),
                                          decoration: BoxDecoration(
                                            color: item.sender == user2!.id
                                                ? const Color.fromARGB(
                                                    66, 48, 40, 15)
                                                : AppColor.mainColor,
                                            borderRadius: BorderRadius.circular(
                                                AppDimention.size40),
                                          ),
                                          child: Text(
                                            item.message.toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                    ],
                                  )))
                              .toList(),
                        ),
                      )),
          ),

          Container(
              width: AppDimention.screenWidth,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              padding: EdgeInsets.only(
                  bottom: AppDimention.size10, top: AppDimention.size10),
              child: Column(
                children: [
                  if (haveImage)
                    Container(
                        width: AppDimention.screenWidth,
                        height: AppDimention.size100 * 3,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: MemoryImage(base64Decode(imagebase64)))),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _image = null;
                                  imagebase64 = "";
                                  haveImage = false;
                                });
                              },
                              child: Container(
                                width: AppDimention.size30,
                                height: AppDimention.size30,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(
                                            AppDimention.size10),
                                        bottomRight: Radius.circular(
                                            AppDimention.size10))),
                                child: Center(
                                  child: Icon(Icons.remove_circle_outline),
                                ),
                              ),
                            )
                          ],
                        )),
                  Row(
                    children: [
                      SizedBox(
                        width: AppDimention.size10,
                      ),
                      GestureDetector(
                        onTap: () {
                          _pickImage();
                        },
                        child: Icon(Icons.image, color: Colors.amber),
                      ),
                      SizedBox(
                        width: AppDimention.size10,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius:
                                BorderRadius.circular(AppDimention.size5),
                          ),
                          padding: EdgeInsets.only(
                              left: AppDimention.size10,
                              right: AppDimention.size10),
                          child: TextField(
                            controller: sendController,
                            focusNode: focusNode,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: "Chart ...",
                              hintStyle: TextStyle(color: Colors.black12),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1.0, color: Colors.transparent),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1.0, color: Colors.transparent),
                              ),
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: AppDimention.size10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: AppDimention.size10,
                      ),
                      GestureDetector(
                        onTap: () {
                          _sendMessage();
                        },
                        child: Icon(Icons.send, color: Colors.amber),
                      ),
                      SizedBox(
                        width: AppDimention.size10,
                      ),
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
