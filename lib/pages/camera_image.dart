import 'dart:io';

import 'package:app/constants.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraImageCapturePage extends StatefulWidget {
  final List<CameraDescription>? camera;
  const CameraImageCapturePage({
    super.key,
    required this.camera,
  });

  @override
  State<CameraImageCapturePage> createState() => _CameraImageCapturePageState();
}

class _CameraImageCapturePageState extends State<CameraImageCapturePage> {
  late CameraController _cameraController;
  bool _showPreview = false;
  XFile? _preview;
  bool _isFrontCamera = false;

  Future initCamera(CameraDescription cameraDescription) async {
// create a CameraController
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);
// Next, initialize the controller. This returns a Future.
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  Future takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      XFile picture = await _cameraController.takePicture();
      // Navigator.push(context, MaterialPageRoute(
      //                builder: (context) => PreviewPage(
      //                      picture: picture,
      //                    )));
      setState(() {
        _preview = picture;
        _showPreview = true;
      });
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  @override
  initState() {
    initCamera(widget.camera![0]);
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _showPreview
              ? [
                  MaterialButton(
                    color: accentColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    height: 50,
                    minWidth: 120,
                    elevation: 8.0,
                    onPressed: () {
                      setState(() {
                        _preview = null;
                        _showPreview = false;
                      });
                    },
                    child: const Text(
                      "Discard",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  MaterialButton(
                    color: accentColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    height: 50,
                    minWidth: 120,
                    elevation: 8.0,
                    onPressed: () {
                      Navigator.of(context).pop(_preview);
                    },
                    child: const Text(
                      "Accept",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ]
              : [
                  FloatingActionButton(
                    onPressed: () {
                      setState(() => _isFrontCamera = !_isFrontCamera);
                      initCamera(widget.camera![_isFrontCamera ? 1 : 0]);
                    },
                    child: const Icon(Icons.switch_camera),
                  ),
                  FloatingActionButton(
                    onPressed: takePicture,
                    child: const Icon(Icons.camera),
                  ),
                ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Take a Picture"),
        centerTitle: true,
        backgroundColor: tartiaryColor,
        surfaceTintColor: tartiaryColor,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(null),
          icon: Icon(
            Icons.arrow_back_ios,
            color: primaryColor,
            size: 30,
          ),
        ),
      ),
      body: Stack(
        children: [
          _showPreview && _preview != null
              ? CapturedImagePreview(image: XFile(_preview!.path))
              : Center(
                  child: _cameraController.value.isInitialized
                      ? CameraPreview(_cameraController)
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
        ],
      ),
    );
  }
}

class CapturedImagePreview extends StatelessWidget {
  final XFile image;
  const CapturedImagePreview({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.file(
        File(image.path),
        fit: BoxFit.cover,
      ),
    );
  }
}
