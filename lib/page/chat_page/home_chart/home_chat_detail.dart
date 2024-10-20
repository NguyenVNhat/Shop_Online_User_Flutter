import 'dart:convert';
import 'dart:io';

import 'package:flutter_user_github/data/controller/Chart_controller.dart';
import 'package:flutter_user_github/data/controller/User_controller.dart';
import 'package:flutter_user_github/models/Model/ChartModel.dart';
import 'package:flutter_user_github/models/Model/Messagemodel.dart';
import 'package:flutter_user_github/models/Model/UserModel.dart';
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

  // connect websocket
  late IOWebSocketChannel _channel;

  @override
  void initState() {
    super.initState();
    loadData(widget.idreceiver);

    HttpClient client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    _channel = IOWebSocketChannel.connect(
      Uri.parse('ws://192.168.1.39:8080/ws/chat'),
      customClient: client,
    );
    startSessionSocket();

    _channel.stream.listen((message) {
      setState(() {
        var decodedMessage = jsonDecode(message);
        listchart.add(Usermessage.fromJson(decodedMessage));
      });
      print("Tin nhắn nhận được: $message");
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
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
  }

  void loadData(int idreceiver) async {
    setState(() {
      loaded = false;
    });
    listchart = [];
    user1 = userController.userprofile;
    await chatController.getlistmessage(idreceiver);
    user2 = await userController.getbyid(idreceiver);
    while (chatController.getisLoadingMessage) {
      Future.delayed(const Duration(milliseconds: 100));
    }
    setState(() {
      listchart = chatController.getlistusermesage;
      loaded = true;
    });
    _scrollToBottom();
  }

  bool isPicking = false;
  bool haveImage = false;
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

  void _reconnect() {
    Future.delayed(Duration(seconds: 5), () {
      HttpClient client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      _channel = IOWebSocketChannel.connect(
        Uri.parse('ws://192.168.1.39:8080/ws/chat'),
        customClient: client,
      );
      startSessionSocket();
      _channel.stream.listen(
        (message) {
          setState(() {
            try {
              var decodedMessage = jsonDecode(message);
              setState(() {
                listchart.add(Usermessage.fromJson(decodedMessage));
              });
            } catch (e) {
              print("Lỗi khi giải mã tin nhắn: $e");
            }
          });
          print("Tin nhắn nhận được: $message");
        },
        onError: (error) {
          print("Lỗi WebSocket: $error");
        },
        onDone: () {
          print("Kết nối WebSocket đã đóng");
          _reconnect();
        },
      );
    });
  }

  void _sendMessage() {
    String message = sendController.text.trim();
    if (message.isNotEmpty) {
      final data = {
        "sender": user1!.id,
        "receiver": user2!.id,
        "message": message,
        "localTime": "",
        "image": "",
      };

      _channel.sink.add(jsonEncode(data));
      sendController.clear();
      userController.addannouceV2(user2!.id!, "Thông báo",
          "Bạn vừa có tin nhắn từ ${user1!.fullName!}");
    }
    if (!imagebase64.isEmpty) {
      chatController.senImage(user1!.id!, user2!.id!, imagebase64);
      updateData(user2!.id!);
    }
    setState(() {
      haveImage = false;
    });
    _scrollToBottom();
  }

  Future<void> updateData(int idreceiver) async {
    listchart.clear();

    loadData(idreceiver);
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
    _channel.sink.close();
    focusNode.dispose();
    sendController.dispose();
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
