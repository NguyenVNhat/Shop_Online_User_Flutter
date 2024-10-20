import 'package:flutter_user_github/page/profile_page/profile_setup_page/shipper_register/shipper_register_body.dart';
import 'package:flutter_user_github/page/profile_page/profile_setup_page/shipper_register/shipper_register_header.dart';
import 'package:flutter/material.dart';
class ShipperRegisterPage extends StatefulWidget{
   const ShipperRegisterPage({
       Key? key,
   }): super(key:key);
   @override
   _ShipperRegisterPageState createState() => _ShipperRegisterPageState();
}
class _ShipperRegisterPageState extends State<ShipperRegisterPage>{
   @override
   Widget build(BuildContext context) {
      return Scaffold(
      body: Column(
        children: [
          ShipperRegisterHeader(),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
               ShipperRegisterBody(),
              ],
            ),
          )),
        ],
      ),
    );
   }
}