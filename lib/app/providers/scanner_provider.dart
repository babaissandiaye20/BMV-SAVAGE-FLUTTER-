import 'dart:async';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

class ScannerProvider extends ChangeNotifier {
  CameraController? _controller;
  bool isCameraInitialized = false;
  bool isScanning = false;
  String? lastScannedImagePath;
  String? errorMessage;

  late final ObjectDetector _objectDetector;

  final _frameRect = Rect.fromCenter(
    center: Offset(0.5, 0.5), // Normalisé (0 à 1)
    width: 0.4, // 40% largeur
    height: 0.25, // 25% hauteur
  );

  ScannerProvider() {
    _objectDetector = ObjectDetector(
      options: ObjectDetectorOptions(
        mode: DetectionMode.single,
        classifyObjects: false,
        multipleObjects: false,
      ),
    );
  }

  CameraController? get controller => _controller;

  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      _controller = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _controller!.initialize();
      isCameraInitialized = true;
      notifyListeners();
      _startAutoDetection();
    } catch (e) {
      errorMessage = "Erreur caméra : $e";
      notifyListeners();
    }
  }

  void _startAutoDetection() {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (!isCameraInitialized || isScanning || _controller == null) return;
      isScanning = true;
      notifyListeners();

      try {
        final picture = await _controller!.takePicture();
        final inputImage = InputImage.fromFilePath(picture.path);
        final objects = await _objectDetector.processImage(inputImage);

        if (objects.isNotEmpty) {
          final object = objects.first;
          final boundingBox = object.boundingBox;

          // Normaliser la position par rapport à l'image
          final imgWidth = inputImage.metadata?.size?.width ?? 1;
          final imgHeight = inputImage.metadata?.size?.height ?? 1;

          final normalizedBox = Rect.fromLTRB(
            boundingBox.left / imgWidth,
            boundingBox.top / imgHeight,
            boundingBox.right / imgWidth,
            boundingBox.bottom / imgHeight,
          );

          if (_frameRect.overlaps(normalizedBox)) {
            timer.cancel();
            lastScannedImagePath = picture.path;
            notifyListeners();
            return;
          }
        }
      } catch (e) {
        errorMessage = "Erreur détection : $e";
      }

      isScanning = false;
      notifyListeners();
    });
  }

  void resetResults() {
    lastScannedImagePath = null;
    errorMessage = null;
    notifyListeners();
  }

  void disposeCamera() {
    _controller?.dispose();
    _objectDetector.close();
    isCameraInitialized = false;
  }
}
