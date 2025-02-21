import 'package:flutter_vision/flutter_vision.dart';
import 'dart:typed_data';

class YoloProcessor {
  late FlutterVision _vision;
  bool _isModelLoaded = false;

  YoloProcessor() {
    _vision = FlutterVision();
  }

  Future<bool> loadModel({
    required String labelsPath,
    required String modelPath,
    required String modelVersion,
  }) async {
    try {
      await _vision.loadYoloModel(
        labels: labelsPath,
        modelPath: modelPath,
        modelVersion: modelVersion,
        quantization: true,
        numThreads: 8,
        useGpu: true,
      );
      _isModelLoaded = true;
      print('YOLO model loaded successfully.');
      return true;
    } catch (e) {
      print('Error loading YOLO model: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>?> detectObjects(
      List<Uint8List> bytesList, int imageHeight, int imageWidth) async {
    if (!_isModelLoaded) {
      print('YOLO model is not loaded.');
      return null;
    }

    try {
      final results = await _vision.yoloOnFrame(
        bytesList: bytesList,
        imageHeight: imageHeight,
        imageWidth: imageWidth,
        iouThreshold: 0.4,
        confThreshold: 0.4,
        classThreshold: 0.5,
      );
      return results;
    } catch (e) {
      print('Error during object detection: $e');
      return null;
    }
  }

  void closeModel() {
    if (_isModelLoaded) {
      _vision.closeYoloModel();
      _isModelLoaded = false;
    }
  }
}
