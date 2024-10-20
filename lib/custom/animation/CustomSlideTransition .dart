import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSlideTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0), 
        end: Offset.zero, 
      ).animate(animation), 
      child: child,
    );
  }
}
