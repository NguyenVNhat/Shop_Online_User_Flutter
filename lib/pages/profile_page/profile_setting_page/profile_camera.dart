import 'dart:convert';
import 'dart:io';

import 'package:flutter_user_github/data/controller/User_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart' as get_multipart;

import 'package:http/http.dart' as http;

class ProfileCamera extends StatefulWidget {
  const ProfileCamera({
    super.key,
  });

  @override
  ProfileCameraState createState() => ProfileCameraState();
}

class ProfileCameraState extends State<ProfileCamera>
    with SingleTickerProviderStateMixin {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _rotationAnimation =
        Tween<double>(begin: 0, end: 90).animate(_animationController);

    _setupCameraController();
  }

  @override
  void dispose() {
    _animationController.dispose();
    cameraController?.dispose();
    super.dispose();
  }

  Future<void> _setupCameraController() async {
    List<CameraDescription> _camera = await availableCameras();
    if (_camera.isNotEmpty) {
      setState(() {
        cameras = _camera;
        cameraController =
            CameraController(_camera.first, ResolutionPreset.high);
      });
      cameraController?.initialize().then((_) {
        setState(() {});
      });
    }
  }

  Future<void> _onTap() async {
  if (_animationController.status == AnimationStatus.completed) {
    _animationController.reverse();
  } else {
    _animationController.forward().then((_) async {
      await Future.delayed(const Duration(microseconds: 100));

      try {
        final image = await cameraController?.takePicture();

         if (image != null) {
          final imagePath = image.path; 
          final imageFile = File(imagePath); 

          final bytes = await imageFile.readAsBytes();
          final base64Image = base64Encode(bytes);

          Get.find<UserController>().updateAvatar(base64Image);
        }
      } catch (e) {
        print('Lỗi khi chụp ảnh: $e');
      }

      _animationController.reverse();
    });
  }
}


  Widget _buildUI() {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SafeArea(
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                SizedBox(
                  child: CameraPreview(cameraController!),
                ),
                Positioned(
                  bottom: 20,
                  left: AppDimention.screenWidth / 2 - AppDimention.size60,
                  child: GestureDetector(
                    onTap: _onTap,
                    child: AnimatedBuilder(
                      animation: _rotationAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle:
                              _rotationAnimation.value * (3.1415926535 / 180),
                          child: const Icon(
                            Icons.camera,
                            color: Colors.white,
                            size: 100,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_circle_left,
                      size: 50,
                      color: AppColor.mainColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }
}
