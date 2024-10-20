import 'package:flutter_user_github/data/controller/Cart_controller.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CartFooter extends StatefulWidget {
  const CartFooter({
    Key? key,
  }) : super(key: key);
  @override
  _CartFooterState createState() => _CartFooterState();
}

class _CartFooterState extends State<CartFooter> {
  TextEditingController addressController = TextEditingController();
  String? selectedPaymentMethod;
  CartController cartController = Get.find<CartController>();
  void checkItem() {
    if (cartController.IDSelectedItem.isEmpty &&
        cartController.IDSelectedStore.isEmpty) {
      Get.snackbar(
        "Thông báo",
        "Vui lòng chọn sản phẩm",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: Colors.black,
        icon: Icon(Icons.warning, color: Colors.red),
        borderRadius: 10,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 1),
        isDismissible: true,
        
      );
    } else {
      Get.toNamed(AppRoute.ORDER_CART_PAGE);
    }
  }

  void _order() async {
    String address = addressController.text.trim();
    String paymentMethod = selectedPaymentMethod!;

    await cartController.orderall(address, paymentMethod);
    if (paymentMethod == "MOMO") {
      var payUrl = cartController.qrcode.payUrl;
      final Uri _url = Uri.parse(payUrl!);
      if (!await launchUrl(_url)) {
        throw Exception('Could not launch $_url');
      }
    }
  }

  void _showDropdown() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông tin giao hàng'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      hintText: "Địa chỉ của bạn",
                      prefixIcon: Icon(Icons.location_on_outlined,
                          color: AppColor.yellowColor),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.0, color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.0, color: Colors.white),
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text("Phương thức thanh toán:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ListTile(
                    title: Text("Thanh toán tiền mặt"),
                    leading: Radio<String>(
                      value: "CASH",
                      groupValue: selectedPaymentMethod,
                      onChanged: (String? value) {
                        setState(() {
                          selectedPaymentMethod = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text("Chuyển khoản ngân hàng"),
                    leading: Radio<String>(
                      value: "MOMO",
                      groupValue: selectedPaymentMethod,
                      onChanged: (String? value) {
                        setState(() {
                          selectedPaymentMethod = value;
                        });
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Đóng"),
                ),
                ElevatedButton(
                  onPressed: () {
                    _order();
                    Navigator.of(context).pop();
                  },
                  child: Text("Đặt hàng"),
                )
              ],
            )
          ],
        );
      },
    );
  }
   String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]}.',
        );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartcontrolelr) {
      return Container(
        width: AppDimention.screenWidth,
        height: AppDimention.size60,
        decoration: BoxDecoration(color: AppColor.yellowColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                width: AppDimention.size30,
                height: AppDimention.size30,
                decoration: BoxDecoration(
                    color: AppColor.mainColor,
                    borderRadius: BorderRadius.circular(AppDimention.size30)),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
            Row(
              children: [
                
                Text(
                  "đ${_formatNumber( cartcontrolelr.totalprice.toInt() )}",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                checkItem();
              },
              child: Container(
                width: AppDimention.size120,
                height: AppDimention.size50,
                decoration: BoxDecoration(
                    color: AppColor.mainColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: Text(
                    "Mua ngay",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
