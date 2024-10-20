import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Bar extends StatelessWidget {
  final double marginLeft;
  final double marginRight;

  const Bar({Key? key,required this.marginLeft,required this.marginRight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 35.0,
      height: 15.0,
      margin: new EdgeInsets.only(left: marginLeft, right: marginRight),
      decoration: new BoxDecoration(
          color: const Color.fromRGBO(0, 0, 255, 1.0),
          borderRadius: new BorderRadius.circular(10.0),
          boxShadow: [
            new BoxShadow(
              color: Colors.black12,
              blurRadius: 8.0,
              spreadRadius: 1.0,
              offset: new Offset(1.0, 0.0),
            ),
            new BoxShadow(
              color: Colors.black26,
              blurRadius: 6.0,
              spreadRadius: 1.5,
              offset: new Offset(1.0, 0.0),
            ),
          ]),
    );
  }
}

class PivotBar extends AnimatedWidget {
  final Animation<double> controller;
  final FractionalOffset alignment;
  final List<Animation<double>> animations;
  final bool isClockwise;
  final double marginLeft;
  final double marginRight;

  PivotBar({
    Key? key,
    this.alignment = FractionalOffset.centerRight,
    required this.controller,
    required this.animations,
    required this.isClockwise,
    this.marginLeft = 15.0,
    this.marginRight = 0.0,
  }) : super(key: key, listenable: controller);

  Matrix4 clockwiseHalf(animation) =>
      new Matrix4.rotationZ((animation.value * math.pi * 2.0) * .5);
  Matrix4 counterClockwiseHalf(animation) =>
      new Matrix4.rotationZ(-(animation.value * math.pi * 2.0) * .5);

  @override
  Widget build(BuildContext context) {
    var transformOne;
    var transformTwo;
    if (isClockwise) {
      transformOne = clockwiseHalf(animations[0]);
      transformTwo = clockwiseHalf(animations[1]);
    } else {
      transformOne = counterClockwiseHalf(animations[0]);
      transformTwo = counterClockwiseHalf(animations[1]);
    }

    return new Transform(
      transform: transformOne,
      alignment: alignment,
      child: new Transform(
        transform: transformTwo,
        alignment: alignment,
        child: Container(
          width: AppDimention.size40,
          height: AppDimention.size15,
          margin: EdgeInsets.only(left: marginLeft,right: marginRight),
          decoration: BoxDecoration(
            boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: Offset(0, 0), 
                ),
              ],
            color: Colors.amber,
            borderRadius: BorderRadius.circular(AppDimention.size10)
          ),
        ),
      ),
    );
  }
}