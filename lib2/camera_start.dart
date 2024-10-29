import 'dart:async';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';








String cameraInfoPublic = 'Unknown';
List<CameraDescription> camerasPublic = <CameraDescription>[];
int cameraIndexPublic = 0;
int cameraIdPublic = -1;
bool initializedPublic = false;
bool recordingPublic = false;
bool recordingTimedPublic = false;
bool recordAudioPublic = true;
bool previewPausedPublic = false;

ResolutionPreset _resolutionPreset = ResolutionPreset.veryHigh;
StreamSubscription<CameraErrorEvent>? _errorStreamSubscription;
StreamSubscription<CameraClosingEvent>? _cameraClosingStreamSubscription;
Future<void> fetchCameras() async {
  String? cameraInfo;
  List<CameraDescription> cameras = <CameraDescription>[];

  int cameraIndex = 0;
  try {
    cameras = await CameraPlatform.instance.availableCameras();
    for(int i=0;i<cameras.length;i++){
      if(cameras[i].name.contains('Snap Camera')){
        cameraIndex = i;
        cameraInfo = 'Found camera: ${cameras[cameraIndex].name}';
        break ;
      }
    }

    // if (cameras.isEmpty) {
    //   cameraInfo = 'No available cameras';
    // } else {
    //   cameraIndex = _cameraIndex % cameras.length;
    //   cameraInfo = 'Found camera: ${cameras[cameraIndex].name}';
    // }
  } on PlatformException catch (e) {
    cameraInfo = 'Failed to get cameras: ${e.code}: ${e.message}';
  }

  cameraIndexPublic = cameraIndex;
  camerasPublic = cameras;
  cameraInfoPublic = cameraInfo??"";
  initializeCamera();
}


Future<void> disposeCurrentCamera() async {
  if (cameraIdPublic >= 0 && initializedPublic) {
    try {
      await CameraPlatform.instance.dispose(cameraIdPublic);

      initializedPublic = false;
      cameraIdPublic = -1;
      recordingPublic = false;
      recordingTimedPublic = false;
      previewPausedPublic = false;
      cameraInfoPublic = 'Camera disposed';
    } on CameraException catch (e) {
      cameraInfoPublic =
      'Failed to dispose camera: ${e.code}: ${e.description}';
    }
  }
}
void onCameraError(CameraErrorEvent event) {
  disposeCurrentCamera();
  fetchCameras();
}
void onCameraClosing(CameraClosingEvent event) {

}
Future<void> initializeCamera() async {
  assert(!initializedPublic);

  if (camerasPublic.isEmpty) {
    return;
  }

  int cameraId = -1;
  try {
    final int cameraIndex = cameraIndexPublic % camerasPublic.length;
    final CameraDescription camera = camerasPublic[cameraIndex];

    cameraId = await CameraPlatform.instance.createCamera(
      camera,
      _resolutionPreset,
      enableAudio: recordAudioPublic,
    );

    _errorStreamSubscription?.cancel();
    _errorStreamSubscription = CameraPlatform.instance
        .onCameraError(cameraId)
        .listen(onCameraError);

    _cameraClosingStreamSubscription?.cancel();
    _cameraClosingStreamSubscription = CameraPlatform.instance
        .onCameraClosing(cameraId)
        .listen(onCameraClosing);

    final Future<CameraInitializedEvent> initialized =
        CameraPlatform.instance.onCameraInitialized(cameraId).first;

    await CameraPlatform.instance.initializeCamera(
      cameraId,
    );


    initializedPublic = true;
    cameraIdPublic = cameraId;
    cameraIndexPublic = cameraIndex;
    cameraInfoPublic = 'Capturing camera: ${camera.name}';
  } on CameraException catch (e) {
    try {
      if (cameraId >= 0) {
        await CameraPlatform.instance.dispose(cameraId);
      }
    } on CameraException catch (e) {
      debugPrint('Failed to dispose camera: ${e.code}: ${e.description}');
    }

    // Reset state.
    initializedPublic = false;
    cameraIdPublic = -1;
    cameraIndexPublic = 0;
    // _previewSize = null;
    recordingPublic = false;
    recordingTimedPublic = false;
    cameraInfoPublic =
    'Failed to initialize camera: ${e.code}: ${e.description}';
  }
}
Widget buildPreview() {
  return CameraPlatform.instance.buildPreview(cameraIdPublic);
}