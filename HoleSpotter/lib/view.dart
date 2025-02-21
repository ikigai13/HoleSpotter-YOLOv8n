import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:HoleSpotter/yolo_processor.dart';
import 'dart:math' as math;

class CameraApp extends StatefulWidget {
  const CameraApp({Key? key}) : super(key: key);

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late YoloProcessor _yoloProcessor;
  CameraController? _controller;
  bool _isDetecting = false;
  bool _modelLoaded = false;
  List<Map<String, dynamic>> _detections = [];
  int _cameraFrameCount = 0;
  double _cameraFps = 0.0;
  DateTime _lastCameraTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _yoloProcessor = YoloProcessor();
    loadModel();
    _initializeCamera();
  }

  Future<void> loadModel() async {
    _modelLoaded = await _yoloProcessor.loadModel(
      labelsPath: 'assets/labels.txt',
      modelPath: 'assets/yolov8n.tflite',
      modelVersion: "yolov8",
    );
    setState(() {});
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _controller = CameraController(
          cameras.first,
          ResolutionPreset.high,
          enableAudio: false,
        );

        await _controller!.initialize();
        await _controller!.lockCaptureOrientation(DeviceOrientation.portraitUp);
        setState(() {});
        int frameCounter = 0;
        _controller!.startImageStream((CameraImage image) {
          _cameraFrameCount++;
          DateTime currentTime = DateTime.now();
          int elapsed = currentTime.difference(_lastCameraTime).inMilliseconds;
          if (elapsed >= 1000) {
            setState(() {
              _cameraFps = _cameraFrameCount * 1000 / elapsed;
            });
            _cameraFrameCount = 0;
            _lastCameraTime = currentTime;
          }

          // Optionally, perform detection on selected frames.
          if (!_isDetecting) {
            _isDetecting = true;
            _runObjectDetection(image);
          }
        });
      } else {
        print("No cameras found");
      }
    } on CameraException catch (e) {
      print('Camera error: ${e.description}');
    }
  }

  void _runObjectDetection(CameraImage image) async {
    if (!mounted || !_modelLoaded) return;
    try {
      final bytes = image.planes.map((plane) => plane.bytes).toList();
      final detector =
          await _yoloProcessor.detectObjects(bytes, image.height, image.width);

      if (detector != null && detector.isNotEmpty) {
        // Log the raw outputs for debugging.
        print("Raw detections: $detector");
        setState(() {
          _detections = detector;
        });
      }
    } catch (e) {
      print('Detection error: $e');
    } finally {
      _isDetecting = false;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _yoloProcessor.closeModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Yolov8n Model',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[700],
        centerTitle: true,
      ),
      body: Stack(
        children: [
          CameraPreview(_controller!), // Camera Feed
          CustomPaint(
            size: Size.infinite,
            painter: BoundingBoxPainter(
              detections: _detections,
              previewSize: _controller!.value.previewSize!,
              screenSize: MediaQuery.of(context).size,
            ),
          ),
          // Add your FPS overlay here
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black.withOpacity(0.5),
              child: Text(
                "Camera FPS: ${_cameraFps.toStringAsFixed(1)}",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BoundingBoxPainter extends CustomPainter {
  final List<Map<String, dynamic>> detections;
  final Size previewSize;
  final Size screenSize;

  BoundingBoxPainter({
    required this.detections,
    required this.previewSize,
    required this.screenSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint boxPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final Paint textBackground = Paint()
      ..color = Colors.black.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    // Using the already proven scaling factors
    double scaleX = screenSize.width / previewSize.height;
    double scaleY = screenSize.height / previewSize.width;

    // Define a manual vertical offset (in screen pixels) to shift the box upward.
    const double verticalOffset = 85.0; // adjust this value as needed

    for (var detection in detections) {
      final boxData = detection['box'];
      if (boxData == null || boxData.length < 4) continue;

      // Compute the scaled coordinates
      double x = boxData[0] * scaleX;
      double y = boxData[1] * scaleY -
          verticalOffset; // shift upward by subtracting offset
      double w = (boxData[2] - boxData[0]) * scaleX;
      double h = (boxData[3] - boxData[1]) * scaleY;

      // Draw bounding box with adjusted y
      Rect rect = Rect.fromLTWH(x, y, w, h);
      canvas.drawRect(rect, boxPaint);

      // Ensure text label is always inside screen
      double labelX = math.max(0, x);
      double labelY = math.max(0, y - 20);
      Rect labelRect = Rect.fromLTWH(labelX, labelY, w, 20);
      canvas.drawRect(labelRect, textBackground);

      final textSpan = TextSpan(
        text:
            "${detection['tag']} (${(detection['box'][4] * 100).toStringAsFixed(1)}%)",
        style: const TextStyle(color: Colors.white, fontSize: 14),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(labelX + 5, labelY + 3));
    }
  }

  @override
  bool shouldRepaint(BoundingBoxPainter oldDelegate) {
    return true;
  }
}
