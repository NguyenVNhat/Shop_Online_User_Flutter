import 'dart:convert';
import 'package:flutter_user_github/data/controller/Product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({
    super.key,
  });

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage>
    with SingleTickerProviderStateMixin {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  ProductController productController = Get.find<ProductController>();

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

  Future<void> _captureImage() async {
    try {
      if (cameraController != null && cameraController!.value.isInitialized) {
        final XFile image = await cameraController!.takePicture();
        final bytes = await image.readAsBytes();
        final String base64Image = base64Encode(bytes);
        productController.searchByImage(base64Image);

        Get.back();
        
      }
    } catch (e) {
      print("Error capturing image: $e");
    }
  }

  void _onTap() {
    if (_animationController.status == AnimationStatus.completed) {
      _animationController.reverse();
    } else {
      _animationController.forward().then((_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _animationController.reverse();
          _captureImage();
        });
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
