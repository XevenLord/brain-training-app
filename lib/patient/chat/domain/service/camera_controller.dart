import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class UserCameraController extends GetxService with WidgetsBindingObserver {
  CameraController? cameraC;

  File? imageFile;

  List<CameraDescription> cameras = [];

  // Initial values
  RxBool isCameraInitialized = false.obs;
  RxBool isCameraPermissionGranted = false.obs;
  RxBool isRearCameraSelected = true.obs;
  RxBool isVideoCameraSelected = false.obs;
  RxBool isRecordingInProgress = false.obs;
  RxDouble minAvailableExposureOffset = 0.0.obs;
  RxDouble maxAvailableExposureOffset = 0.0.obs;
  RxDouble minAvailableZoom = 1.0.obs;
  RxDouble maxAvailableZoom = 1.0.obs;

  // Current values
  RxDouble currentZoomLevel = 1.0.obs;
  RxDouble currentExposureOffset = 0.0.obs;
  FlashMode? currentFlashMode;

  List<File> allFileList = [];

  final resolutionPresets = ResolutionPreset.values.obs;

  ResolutionPreset currentResolutionPreset = ResolutionPreset.high;

  getPermissionStatus() async {
    await Permission.camera.request();
    var status = await Permission.camera.status;

    if (status.isGranted) {
      debugPrint('Camera Permission: GRANTED');
      isCameraPermissionGranted.value = true;
      // Set and initialize the new camera
      onNewCameraSelected(cameras[0]);
      refreshAlreadyCapturedImages();
    } else {
      debugPrint('Camera Permission: DENIED');
    }
  }

  refreshAlreadyCapturedImages() async {
    final directory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> fileList = await directory.list().toList();
    allFileList.clear();
    List<Map<int, dynamic>> fileNames = [];

    fileList.forEach((file) {
      if (file.path.contains('.jpg') || file.path.contains('.mp4')) {
        allFileList.add(File(file.path));

        String name = file.path.split('/').last.split('.').first;
        fileNames.add({0: int.parse(name), 1: file.path.split('/').last});
      }
    });

    if (fileNames.isNotEmpty) {
      final recentFile =
          fileNames.reduce((curr, next) => curr[0] > next[0] ? curr : next);
      String recentFileName = recentFile[1];
      imageFile = File('${directory.path}/$recentFileName');
    }
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = cameraC;

    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
      return null;
    }
  }

  void resetCameraValues() async {
    currentZoomLevel.value = 1.0;
    currentExposureOffset.value = 0.0;
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = cameraC;

    final CameraController cameraController = CameraController(
      cameraDescription,
      currentResolutionPreset,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await previousCameraController?.dispose();

    resetCameraValues();

    // if (mounted) {
      cameraC = cameraController;
    // }

    // Update UI if cameraC updated
    cameraController.addListener(() {
      // if (mounted) {
      // }
    });

    try {
      await cameraController.initialize();
      await Future.wait([
        cameraController
            .getMinExposureOffset()
            .then((value) => minAvailableExposureOffset.value = value),
        cameraController
            .getMaxExposureOffset()
            .then((value) => maxAvailableExposureOffset.value = value),
        cameraController
            .getMaxZoomLevel()
            .then((value) => maxAvailableZoom.value = value),
        cameraController
            .getMinZoomLevel()
            .then((value) => minAvailableZoom.value = value),
      ]);

      currentFlashMode = cameraC!.value.flashMode;
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    // if (mounted) {
      isCameraInitialized.value = cameraC!.value.isInitialized;
    // }
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (cameraC == null) {
      return;
    }

    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraC!.setExposurePoint(offset);
    cameraC!.setFocusPoint(offset);
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    cameras = await availableCameras();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    getPermissionStatus();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = cameraC;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    cameraC?.dispose();
  }
}