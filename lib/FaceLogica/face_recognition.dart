import 'dart:io';
import 'package:google_ml_kit/google_ml_kit.dart';

class FaceRecognitionService {
  late FaceDetector _faceDetector;

  FaceRecognitionService() {
    _faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        enableContours: true,
        enableClassification: true,
        enableTracking: false,
      ),
    );
  }

  Future<bool> detectFace(File image) async {
    final inputImage = InputImage.fromFile(image);
    final faces = await _faceDetector.processImage(inputImage);

    return faces.isNotEmpty; // Retorna true si se detecta al menos un rostro
  }

  void dispose() {
    _faceDetector.close();
  }
}
