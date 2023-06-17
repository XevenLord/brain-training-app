import 'package:brain_training_app/patient/chat/domain/service/camera_controller.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class CameraPage extends GetView<UserCameraController> {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: controller.isCameraPermissionGranted.value
            ? controller.isCameraInitialized.value
                ? Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 1 / controller.cameraC!.value.aspectRatio,
                        child: Stack(
                          children: [
                            // CameraPreview(
                            //   controller.cameraC!,
                            //   child: LayoutBuilder(builder:
                            //       (BuildContext context,
                            //           BoxConstraints constraints) {
                            //     return GestureDetector(
                            //       behavior: HitTestBehavior.opaque,
                            //       onTapDown: (details) =>
                            //           onViewFinderTap(details, constraints),
                            //     );
                            //   }),
                            // ),
                            // TODO: Uncomment to preview the overlay
                            // Center(
                            //   child: Image.asset(
                            //     'assets/camera_aim.png',
                            //     color: Colors.greenAccent,
                            //     width: 150,
                            //     height: 150,
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                16.0,
                                8.0,
                                16.0,
                                8.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black87,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8.0,
                                          right: 8.0,
                                        ),
                                        child: DropdownButton<ResolutionPreset>(
                                          dropdownColor: Colors.black87,
                                          underline: Container(),
                                          value: controller
                                              .currentResolutionPreset,
                                          items: [
                                            for (ResolutionPreset preset
                                                in controller.resolutionPresets)
                                              DropdownMenuItem(
                                                value: preset,
                                                child: Text(
                                                  preset
                                                      .toString()
                                                      .split('.')[1]
                                                      .toUpperCase(),
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                          ],
                                          onChanged: (value) {
                                            controller.currentResolutionPreset =
                                                value!;
                                            controller.isCameraInitialized
                                                .value = false;
                                            controller.onNewCameraSelected(
                                                controller
                                                    .cameraC!.description);
                                          },
                                          hint: const Text("Select item"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, top: 16.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          controller.currentExposureOffset.value
                                                  .toStringAsFixed(1) +
                                              'x',
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: RotatedBox(
                                      quarterTurns: 3,
                                      child: Container(
                                        height: 30,
                                        child: Slider(
                                          value: controller
                                              .currentExposureOffset.value,
                                          min: controller
                                              .minAvailableExposureOffset.value,
                                          max: controller
                                              .maxAvailableExposureOffset.value,
                                          activeColor: Colors.white,
                                          inactiveColor: Colors.white30,
                                          onChanged: (value) async {
                                            controller.currentExposureOffset
                                                .value = value;
                                            await controller.cameraC!
                                                .setExposureOffset(value);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Slider(
                                          value:
                                              controller.currentZoomLevel.value,
                                          min:
                                              controller.minAvailableZoom.value,
                                          max:
                                              controller.maxAvailableZoom.value,
                                          activeColor: Colors.white,
                                          inactiveColor: Colors.white30,
                                          onChanged: (value) async {
                                            controller.currentZoomLevel.value =
                                                value;
                                            await controller.cameraC!
                                                .setZoomLevel(value);
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black87,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              controller.currentZoomLevel.value
                                                      .toStringAsFixed(1) +
                                                  'x',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // InkWell(
                                      //   onTap: _isRecordingInProgress
                                      //       ? () async {
                                      //           if (cameraC!
                                      //               .value.isRecordingPaused) {
                                      //             await resumeVideoRecording();
                                      //           } else {
                                      //             await pauseVideoRecording();
                                      //           }
                                      //         }
                                      //       : () {
                                      //           setState(() {
                                      //             _isCameraInitialized = false;
                                      //           });
                                      //           onNewCameraSelected(cameras[
                                      //               _isRearCameraSelected
                                      //                   ? 1
                                      //                   : 0]);
                                      //           setState(() {
                                      //             _isRearCameraSelected =
                                      //                 !_isRearCameraSelected;
                                      //           });
                                      //         },
                                      //   child: Stack(
                                      //     alignment: Alignment.center,
                                      //     children: [
                                      //       Icon(
                                      //         Icons.circle,
                                      //         color: Colors.black38,
                                      //         size: 60,
                                      //       ),
                                      //       _isRecordingInProgress
                                      //           ? cameraC!
                                      //                   .value.isRecordingPaused
                                      //               ? Icon(
                                      //                   Icons.play_arrow,
                                      //                   color: Colors.white,
                                      //                   size: 30,
                                      //                 )
                                      //               : Icon(
                                      //                   Icons.pause,
                                      //                   color: Colors.white,
                                      //                   size: 30,
                                      //                 )
                                      //           : Icon(
                                      //               _isRearCameraSelected
                                      //                   ? Icons.camera_front
                                      //                   : Icons.camera_rear,
                                      //               color: Colors.white,
                                      //               size: 30,
                                      //             ),
                                      //     ],
                                      //   ),
                                      // ),
                                      // InkWell(
                                      //   onTap: _isVideoCameraSelected
                                      //       ? () async {
                                      //           if (_isRecordingInProgress) {
                                      //             XFile? rawVideo =
                                      //                 await stopVideoRecording();
                                      //             File videoFile =
                                      //                 File(rawVideo!.path);

                                      //             int currentUnix = DateTime
                                      //                     .now()
                                      //                 .millisecondsSinceEpoch;

                                      //             final directory =
                                      //                 await getApplicationDocumentsDirectory();

                                      //             String fileFormat = videoFile
                                      //                 .path
                                      //                 .split('.')
                                      //                 .last;

                                      //             _videoFile =
                                      //                 await videoFile.copy(
                                      //               '${directory.path}/$currentUnix.$fileFormat',
                                      //             );

                                      //             _startVideoPlayer();
                                      //           } else {
                                      //             await startVideoRecording();
                                      //           }
                                      //         }
                                      //       : () async {
                                      //           XFile? rawImage =
                                      //               await takePicture();
                                      //           File imageFile =
                                      //               File(rawImage!.path);

                                      //           int currentUnix = DateTime.now()
                                      //               .millisecondsSinceEpoch;

                                      //           final directory =
                                      //               await getApplicationDocumentsDirectory();

                                      //           String fileFormat = imageFile
                                      //               .path
                                      //               .split('.')
                                      //               .last;

                                      //           print(fileFormat);

                                      //           await imageFile.copy(
                                      //             '${directory.path}/$currentUnix.$fileFormat',
                                      //           );

                                      //           refreshAlreadyCapturedImages();
                                      //         },
                                      //   child: Stack(
                                      //     alignment: Alignment.center,
                                      //     children: [
                                      //       Icon(
                                      //         Icons.circle,
                                      //         color: _isVideoCameraSelected
                                      //             ? Colors.white
                                      //             : Colors.white38,
                                      //         size: 80,
                                      //       ),
                                      //       Icon(
                                      //         Icons.circle,
                                      //         color: _isVideoCameraSelected
                                      //             ? Colors.red
                                      //             : Colors.white,
                                      //         size: 65,
                                      //       ),
                                      //       _isVideoCameraSelected &&
                                      //               _isRecordingInProgress
                                      //           ? Icon(
                                      //               Icons.stop_rounded,
                                      //               color: Colors.white,
                                      //               size: 32,
                                      //             )
                                      //           : Container(),
                                      //     ],
                                      //   ),
                                      // ),
                                      InkWell(
                                        onTap: controller.imageFile != null
                                            ? () {
                                                //TODO: Route to previe the image screen
                                                // Navigator.of(context).push(
                                                //   MaterialPageRoute(
                                                //     builder: (context) =>
                                                //         PreviewScreen(
                                                //       imageFile: _imageFile!,
                                                //       fileList: allFileList,
                                                //     ),
                                                //   ),
                                                // );
                                              }
                                            : null,
                                        child: Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                            image: controller.imageFile != null
                                                ? DecorationImage(
                                                    image: FileImage(
                                                        controller.imageFile!),
                                                    fit: BoxFit.cover,
                                                  )
                                                : null,
                                          ),
                                          // child: videoController != null &&
                                          //         videoController!
                                          //             .value.isInitialized
                                          //     ? ClipRRect(
                                          //         borderRadius:
                                          //             BorderRadius.circular(
                                          //                 8.0),
                                          //         child: AspectRatio(
                                          //           aspectRatio:
                                          //               videoController!
                                          //                   .value.aspectRatio,
                                          //           child: VideoPlayer(
                                          //               videoController!),
                                          //         ),
                                          //       )
                                          //     : Container(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    // Expanded(
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.only(
                                    //       left: 8.0,
                                    //       right: 4.0,
                                    //     ),
                                    //     child: TextButton(
                                    //       onPressed: _isRecordingInProgress
                                    //           ? null
                                    //           : () {
                                    //               if (_isVideoCameraSelected) {
                                    //                 setState(() {
                                    //                   _isVideoCameraSelected =
                                    //                       false;
                                    //                 });
                                    //               }
                                    //             },
                                    //       style: TextButton.styleFrom(
                                    //         primary: _isVideoCameraSelected
                                    //             ? Colors.black54
                                    //             : Colors.black,
                                    //         backgroundColor:
                                    //             _isVideoCameraSelected
                                    //                 ? Colors.white30
                                    //                 : Colors.white,
                                    //       ),
                                    //       child: Text('IMAGE'),
                                    //     ),
                                    //   ),
                                    // ),
                                    // Expanded(
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.only(
                                    //         left: 4.0, right: 8.0),
                                    //     child: TextButton(
                                    //       onPressed: () {
                                    //         if (!_isVideoCameraSelected) {
                                    //           setState(() {
                                    //             _isVideoCameraSelected = true;
                                    //           });
                                    //         }
                                    //       },
                                    //       style: TextButton.styleFrom(
                                    //         primary: _isVideoCameraSelected
                                    //             ? Colors.black
                                    //             : Colors.black54,
                                    //         backgroundColor:
                                    //             _isVideoCameraSelected
                                    //                 ? Colors.white
                                    //                 : Colors.white30,
                                    //       ),
                                    //       child: Text('VIDEO'),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 8.0, 16.0, 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        controller.currentFlashMode =
                                            FlashMode.off;
                                        await controller.cameraC!.setFlashMode(
                                          FlashMode.off,
                                        );
                                      },
                                      child: Icon(
                                        Icons.flash_off,
                                        color: controller.currentFlashMode ==
                                                FlashMode.off
                                            ? Colors.amber
                                            : Colors.white,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        controller.currentFlashMode =
                                            FlashMode.auto;
                                        await controller.cameraC!.setFlashMode(
                                          FlashMode.auto,
                                        );
                                      },
                                      child: Icon(
                                        Icons.flash_auto,
                                        color: controller.currentFlashMode ==
                                                FlashMode.auto
                                            ? Colors.amber
                                            : Colors.white,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        controller.currentFlashMode =
                                            FlashMode.always;
                                        await controller.cameraC!.setFlashMode(
                                          FlashMode.always,
                                        );
                                      },
                                      child: Icon(
                                        Icons.flash_on,
                                        color: controller.currentFlashMode ==
                                                FlashMode.always
                                            ? Colors.amber
                                            : Colors.white,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        controller.currentFlashMode =
                                            FlashMode.torch;
                                        await controller.cameraC!.setFlashMode(
                                          FlashMode.torch,
                                        );
                                      },
                                      child: Icon(
                                        Icons.highlight,
                                        color: controller.currentFlashMode ==
                                                FlashMode.torch
                                            ? Colors.amber
                                            : Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      'LOADING',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(),
                  Text(
                    'Permission denied',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      controller.getPermissionStatus();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Give permission',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}