import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_user_github/caculator/function.dart';
import 'package:flutter_user_github/data/controller/Combo_controller.dart';
import 'package:flutter_user_github/data/controller/Order_controller.dart';
import 'package:flutter_user_github/data/controller/Product_controller.dart';
import 'package:flutter_user_github/data/controller/Store_Controller.dart';
import 'package:flutter_user_github/data/controller/User_controller.dart';
import 'package:flutter_user_github/models/Model/Item/ComboItem.dart';
import 'package:flutter_user_github/models/Model/Item/ProductItem.dart';
import 'package:flutter_user_github/models/Model/OrderModel.dart';
import 'package:flutter_user_github/models/Model/UserModel.dart';
import 'package:flutter_user_github/page/order_page/order_footer.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderCode;
  const OrderDetailPage({Key? key, required this.orderCode}) : super(key: key);
  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  ProductController productController = Get.find<ProductController>();
  Storecontroller storecontroller = Get.find<Storecontroller>();
  User? shipper;
  @override
  void initState() {
    super.initState();
    Get.find<OrderController>().getorderbyOrdercode(widget.orderCode);
    _fetchShipper();
  }

  Future<void> _fetchShipper() async {
    final orderController = Get.find<OrderController>();
    while (orderController.isLoading) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    if (orderController.orderdetail!.shipperId != 0) {
      final userController = Get.find<UserController>();
      shipper =
          await userController.getbyid(orderController.orderdetail!.shipperId!);
      setState(() {});
    }
  }
  List<LatLng> routePoints = [];
  bool? isShowRoute = false;
  Future<void> getRoute(LatLng startPoint, LatLng endPoint) async {
    final apiKey = '5b3ce3597851110001cf62482f6aa59251a040bca10bfec215ef276c';
    final url =
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${startPoint.longitude},${startPoint.latitude}&end=${endPoint.longitude},${endPoint.latitude}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> coordinates =
          data['features'][0]['geometry']['coordinates'];

      setState(() {
        routePoints =
            coordinates.map((point) => LatLng(point[1], point[0])).toList();
        print("Lấy thành công");
      });
    } else {
      print("Failed to fetch route");
    }
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]}.',
        );
  }

  FunctionMap mapfuntion = FunctionMap();
  MapController mapController = MapController();
  double zoomValue = 14;
  LatLng daNangCoordinates = LatLng(16.0544, 108.2022);

  void _showDialogRoad(User shipper ,double latitude,double longitude) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              child: Container(
            width: AppDimention.screenWidth,
            height: AppDimention.size100 * 4,
            child: Container(
                width: AppDimention.screenWidth,
                height: AppDimention.size100 * 3,
                decoration: BoxDecoration(color: Colors.amber),
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        initialCenter: daNangCoordinates,
                        initialZoom: zoomValue,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                                width: 100.0,
                                height: 80.0,
                                point: LatLng(shipper.latitude!, shipper.longitude!),
                                child: Column(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.all(AppDimention.size10),
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(
                                              AppDimention.size5)),
                                      child: Text(
                                        "Shipper",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.blue,
                                    ),
                                  ],
                                )),
                            Marker(
                                width: 100.0,
                                height: 80.0,
                                point: LatLng(latitude, longitude),
                                child: Column(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.all(AppDimention.size10),
                                      decoration: BoxDecoration(
                                          color: Colors.yellow,
                                          borderRadius: BorderRadius.circular(
                                              AppDimention.size5)),
                                      child: Text(
                                        "Điểm giao",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.yellow,
                                    ),
                                  ],
                                )),
                           
                          ],
                        ),
                        if (isShowRoute!)
                          PolylineLayer(
                            polylines: [
                              Polyline(
                                points: routePoints,
                                strokeWidth: 4.0,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                      ],
                    ),
                    Positioned(
                        bottom: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () {
                            mapController.move(LatLng(shipper.latitude!, shipper.longitude!), zoomValue);
                          },
                          child: Container(
                            width: AppDimention.size40,
                            height: AppDimention.size40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(AppDimention.size5),
                                border: Border.all(
                                    width: 1, color: Colors.black26)),
                            child: Center(
                              child: Icon(
                                Icons.my_location,
                                size: 20,
                              ),
                            ),
                          ),
                        )),
                    Positioned(
                        bottom: 10,
                        left: 10,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              zoomValue = zoomValue + 1;
                            });
                            mapController.move(LatLng(shipper.latitude!, shipper.longitude!), zoomValue);
                          },
                          child: Container(
                            width: AppDimention.size40,
                            height: AppDimention.size40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(AppDimention.size5),
                                border: Border.all(
                                    width: 1, color: Colors.black26)),
                            child: Center(
                              child: Icon(
                                Icons.zoom_out_map_outlined,
                                size: 20,
                              ),
                            ),
                          ),
                        )),
                    Positioned(
                        bottom: 10,
                        left: 60,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              zoomValue = zoomValue - 1;
                            });
                            mapController.move(LatLng(shipper.latitude!, shipper.longitude!), zoomValue);
                          },
                          child: Container(
                            width: AppDimention.size40,
                            height: AppDimention.size40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(AppDimention.size5),
                                border: Border.all(
                                    width: 1, color: Colors.black26)),
                            child: Center(
                              child: Icon(
                                Icons.zoom_in_map_outlined,
                                size: 20,
                              ),
                            ),
                          ),
                        )),
                    Positioned(
                        bottom: 10,
                        left: 110,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              getRoute(
                                  LatLng(shipper.latitude!, shipper.longitude!),
                                  LatLng(latitude, longitude));
                              isShowRoute = !isShowRoute!;
                            });
                          },
                          child: Container(
                            width: AppDimention.size40,
                            height: AppDimention.size40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    AppDimention.size5),
                                border: Border.all(
                                    width: 1, color: Colors.black26)),
                            child: Center(
                              child: Icon(
                                Icons.roundabout_left,
                                size: 20,
                              ),
                            ),
                          ),
                        )),
                  ],
                )),
          ));
        });
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  void _sendSMS(String phoneNumber) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
    );
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      throw 'Could not send SMS to $phoneNumber';
    }
  }

  void _sendEmail(String email, String subject, String body) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not send email to $email';
    }
  }

  void _showDialogContact(User shipper) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              child: Container(
            width: AppDimention.screenWidth,
            height: AppDimention.size100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    _sendEmail("${shipper.email}",
                        "Khách hàng đơn hàng được giao", "");
                  },
                  child: Container(
                    width: AppDimention.size100,
                    height: AppDimention.size40,
                    decoration: BoxDecoration(color: Colors.green),
                    child: Center(
                      child: Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _sendSMS("${shipper.phoneNumber}");
                  },
                  child: Container(
                    width: AppDimention.size100,
                    height: AppDimention.size40,
                    decoration: BoxDecoration(color: Colors.green),
                    child: Center(
                      child: Icon(
                        Icons.chat_bubble_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _makePhoneCall("${shipper.phoneNumber}");
                  },
                  child: Container(
                    width: AppDimention.size100,
                    height: AppDimention.size40,
                    decoration: BoxDecoration(color: Colors.green),
                    child: Center(
                      child: Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController) {
      return !orderController.isLoading
          ? Scaffold(
              backgroundColor: Colors.grey[200],
              resizeToAvoidBottomInset: false,
              body: Column(
                children: [
                  Container(
                    width: AppDimention.screenWidth,
                    height: AppDimention.size100,
                    padding: EdgeInsets.only(top: AppDimention.size40),
                    decoration: BoxDecoration(color: AppColor.mainColor),
                    child: Center(
                      child: Text("Chi tiết đơn hàng",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: AppDimention.size25,
                          )),
                    ),
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: AppDimention.screenWidth,
                          margin: EdgeInsets.all(AppDimention.size10),
                          padding: EdgeInsets.all(AppDimention.size10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Mã đơn hàng : ${orderController.orderdetail!.orderCode}"),
                                  Text(
                                      "Ngày đặt hàng : ${orderController.orderdetail!.createdAt}"),
                                  Container(
                                    width: AppDimention.screenWidth -
                                        AppDimention.size40,
                                    child: Text(
                                        "Địa chỉ giao hàng : ${orderController.orderdetail!.deliveryAddress}"),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        if (orderController.orderdetail!.shipperId != 0)
                          shipper == null
                              ? CircularProgressIndicator()
                              : Column(
                                  children: [
                                    Container(
                                      width: AppDimention.screenWidth,
                                      margin:
                                          EdgeInsets.all(AppDimention.size10),
                                      padding:
                                          EdgeInsets.all(AppDimention.size10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            AppDimention.size10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: AppDimention.size150,
                                            height: AppDimention.size100 * 1.8,
                                            decoration: BoxDecoration(
                                                color: AppColor.yellowColor,
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: shipper!.avatar == null ? AssetImage("assets/image/default_avatar.jpg") : MemoryImage(base64Decode(shipper!.avatar!))
                                                )),
                                          ),
                                          Container(
                                            width: AppDimention.size100 * 2,
                                            height: AppDimention.size100 * 1.8,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("${shipper!.fullName!}"),
                                                Text(
                                                    "Số điện thoại : ${shipper!.phoneNumber!}"),
                                                Text("Email : ${shipper!.email!}"),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.all(AppDimention.size10),
                                      width: AppDimention.screenWidth,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _showDialogContact(shipper!);
                                            },
                                            child: Container(
                                              width: AppDimention.size100 * 1.8,
                                              height: AppDimention.size50,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          AppDimention.size10),
                                                  color: Colors.green),
                                              child: Center(
                                                child: Text(
                                                  "Liên hệ",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _showDialogRoad(shipper!,orderController.orderdetail!.latitude!,orderController.orderdetail!.longitude!);
                                            },
                                            child: Container(
                                              width: AppDimention.size100 * 1.8,
                                              height: AppDimention.size50,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          AppDimention.size10),
                                                  color: Colors.green),
                                              child: Center(
                                                child: Text(
                                                  "Lộ trình",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        Column(
                          children: orderController.orderdetail!.orderDetails!
                              .map((item) {
                            OrderDetails detail = item;

                            ProductDetail? productOrder;
                            ComboDetail? comboOrder;
                            Comboitem? comboitem;
                            bool? key;
                            if (detail.type == "product") {
                              productOrder = detail.productDetail;
                              key = true;
                            } else {
                              comboOrder = detail.comboDetail;
                              comboitem = Get.find<ComboController>()
                                  .getcombobyId(comboOrder!.comboId!);
                              key = false;
                            }

                            return GestureDetector(
                              onTap: () {},
                              child: key
                                  ? Container(
                                      width: AppDimention.screenWidth,
                                      margin:
                                          EdgeInsets.all(AppDimention.size10),
                                      padding:
                                          EdgeInsets.all(AppDimention.size10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              AppDimention.size5),
                                          color: Colors.white),
                                      child: Container(
                                          width: AppDimention.screenWidth,
                                          padding: EdgeInsets.all(
                                              AppDimention.size10),
                                          margin: EdgeInsets.only(
                                              bottom: AppDimention.size10),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppDimention.size5)),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: AppDimention.size80,
                                                    height: AppDimention.size80,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: MemoryImage(
                                                                base64Decode(
                                                                    productOrder!
                                                                        .productImage!))),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    AppDimention
                                                                        .size5)),
                                                  ),
                                                  SizedBox(
                                                    width: AppDimention.size10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          "${productOrder.productName}"),
                                                      Text(
                                                          "đ${_formatNumber(productOrder.unitPrice!.toInt())}"),
                                                      Container(
                                                        width: AppDimention
                                                                .size100 *
                                                            2.3,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                "Size : ${productOrder.size}"),
                                                            Text(
                                                                "Số lượng : ${productOrder.quantity}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        width: AppDimention
                                                                .size100 *
                                                            2.3,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                Get.toNamed(AppRoute
                                                                    .get_product_detail(
                                                                        productOrder!
                                                                            .productId!));
                                                              },
                                                              child: Center(
                                                                child: Text(
                                                                    "Chi tiết"),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: AppDimention.size10,
                                              ),
                                              Text(
                                                  "Cửa hàng : ${storecontroller.addressOfStore(productOrder.storeId!)}")
                                            ],
                                          )),
                                    )
                                  : Container(
                                      width: AppDimention.screenWidth,
                                      margin:
                                          EdgeInsets.all(AppDimention.size10),
                                      padding:
                                          EdgeInsets.all(AppDimention.size10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              AppDimention.size5),
                                          color: Colors.white),
                                      child: Column(
                                        children: [
                                          Text(
                                            "${comboitem!.comboName!}",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Container(
                                              width: AppDimention.screenWidth,
                                              padding: EdgeInsets.all(
                                                  AppDimention.size20),
                                              decoration: BoxDecoration(
                                                  color: Colors.amber
                                                      .withOpacity(0.8),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          AppDimention.size10)),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text("Chi tiết combo"),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          "đ${_formatNumber(comboOrder!.totalPrice!.toInt())}"),
                                                      Text(
                                                          "Số lượng ${comboOrder.quantity}"),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          "Size : ${comboOrder.size}"),
                                                      Text(
                                                          "${comboOrder.status}"),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: AppDimention.size20,
                                                  ),
                                                  Text(
                                                      "Cửa hàng :${storecontroller.addressOfStore(comboOrder.storeId!)} ")
                                                ],
                                              )),
                                          SizedBox(
                                            height: AppDimention.size20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text("Danh sách sản phẩm"),
                                            ],
                                          ),
                                          Column(
                                            children: comboitem.products!
                                                .map((item) => Container(
                                                      child: Container(
                                                        width: AppDimention
                                                            .screenWidth,
                                                        padding: EdgeInsets.all(
                                                            AppDimention
                                                                .size10),
                                                        margin: EdgeInsets.only(
                                                            top: AppDimention
                                                                .size10),
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .grey[200],
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    AppDimention
                                                                        .size5)),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width:
                                                                  AppDimention
                                                                      .size80,
                                                              height:
                                                                  AppDimention
                                                                      .size80,
                                                              decoration: BoxDecoration(
                                                                  image: DecorationImage(
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      image: MemoryImage(
                                                                          base64Decode(item
                                                                              .image!))),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          AppDimention
                                                                              .size5)),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  AppDimention
                                                                      .size10,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    "${item.productName}"),
                                                                Text(
                                                                    "đ${_formatNumber(item.price!.toInt())}"),
                                                                Row(
                                                                  children: [
                                                                    Wrap(
                                                                      children:
                                                                          List.generate(
                                                                              5,
                                                                              (index) {
                                                                        if (index <
                                                                            item.averageRate!
                                                                                .floor()) {
                                                                          return Icon(
                                                                              Icons.star,
                                                                              color: Colors.red,
                                                                              size: AppDimention.size15);
                                                                        } else if (index == item.averageRate!.floor() &&
                                                                            item.averageRate! % 1 !=
                                                                                0) {
                                                                          return Icon(
                                                                              Icons.star_half,
                                                                              color: Colors.red,
                                                                              size: AppDimention.size15);
                                                                        } else {
                                                                          return Icon(
                                                                              Icons.star_border,
                                                                              color: Colors.red,
                                                                              size: AppDimention.size15);
                                                                        }
                                                                      }),
                                                                    ),
                                                                    Text(
                                                                      "(${item.averageRate})",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .red,
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Container(
                                                                  width: AppDimention
                                                                          .size100 *
                                                                      2.3,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Get.toNamed(
                                                                              AppRoute.get_product_detail(item.productId!));
                                                                        },
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text("Chi tiết"),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                          ),
                                          if (!comboOrder.drinkId!.isEmpty)
                                            Column(
                                              children: [
                                                SizedBox(
                                                  height: AppDimention.size20,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        "Danh sách nước uống mua thêm"),
                                                  ],
                                                ),
                                                Column(
                                                  children: comboOrder.drinkId!
                                                      .map((item) {
                                                    Productitem? productitem =
                                                        productController
                                                            .getproductbyid(
                                                                int.parse(
                                                                    item));
                                                    return Container(
                                                      child: Container(
                                                        width: AppDimention
                                                            .screenWidth,
                                                        padding: EdgeInsets.all(
                                                            AppDimention
                                                                .size10),
                                                        margin: EdgeInsets.only(
                                                            top: AppDimention
                                                                .size10),
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .grey[200],
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    AppDimention
                                                                        .size5)),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width:
                                                                  AppDimention
                                                                      .size80,
                                                              height:
                                                                  AppDimention
                                                                      .size80,
                                                              decoration: BoxDecoration(
                                                                  image: DecorationImage(
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      image: MemoryImage(base64Decode(
                                                                          productitem!
                                                                              .image!))),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          AppDimention
                                                                              .size5)),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  AppDimention
                                                                      .size10,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    "${productitem.productName}"),
                                                                Text(
                                                                    "đ${_formatNumber(productitem.price!.toInt())}"),
                                                                Row(
                                                                  children: [
                                                                    Wrap(
                                                                      children:
                                                                          List.generate(
                                                                              5,
                                                                              (index) {
                                                                        if (index <
                                                                            productitem.averageRate!
                                                                                .floor()) {
                                                                          return Icon(
                                                                              Icons.star,
                                                                              color: Colors.red,
                                                                              size: AppDimention.size15);
                                                                        } else if (index == productitem.averageRate!.floor() &&
                                                                            productitem.averageRate! % 1 !=
                                                                                0) {
                                                                          return Icon(
                                                                              Icons.star_half,
                                                                              color: Colors.red,
                                                                              size: AppDimention.size15);
                                                                        } else {
                                                                          return Icon(
                                                                              Icons.star_border,
                                                                              color: Colors.red,
                                                                              size: AppDimention.size15);
                                                                        }
                                                                      }),
                                                                    ),
                                                                    Text(
                                                                      "(${productitem.averageRate})",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .red,
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Container(
                                                                  width: AppDimention
                                                                          .size100 *
                                                                      2.3,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Get.toNamed(
                                                                              AppRoute.get_product_detail(productitem.productId!));
                                                                        },
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text("Chi tiết"),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            )
                                        ],
                                      ),
                                    ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  )),
                  OrderFooter()
                ],
              ),
            )
          : CircularProgressIndicator();
    });
  }
}
