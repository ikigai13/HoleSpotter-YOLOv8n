import 'package:flutter/material.dart';

class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About HoleSpotter',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[700],
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[500],
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Image.asset(
            'assets/pothole.png',
            height: 250,
            semanticLabel: 'Pothole detection preview',
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('HoleSpotter'),
          _buildSectionText(
              'This app is your on-the-go solution for identifying potholes. Using advanced image recognition technology, it analyzes your phone\'s camera feed to detect potholes in real-time, providing instant visual feedback.'),
          _buildSectionTitle('How it Works'),
          _buildBulletText(
              'See it: The app continuously scans the road ahead using your device\'s camera.'),
          _buildBulletText(
              'Detect it: Our algorithm identifies potholes and marks them with bounding boxes.'),
          _buildBulletText(
              'Know it: Each detection includes a confidence score labeled as "Pothole".'),
          _buildSectionTitle('Simple and Effective'),
          _buildSectionText(
              'Designed for ease of use. No complicated menus or settings. Just open the app and let it do the work.'),
          _buildSectionTitle('Technical Details'),
          _buildBulletText(
              'YOLOv8n: An efficient object detection model for pothole identification.'),
          _buildBulletText(
              'Flutter: A modern framework for a seamless UI experience.'),
          _buildSectionTitle('Focus on Safety'),
          _buildBulletText(
              'Increase awareness: Helps avoid hazards and make informed driving decisions.'),
          _buildBulletText(
              'Prevent damage: Reduces the risk of tire punctures and costly repairs.'),
          _buildBulletText(
              'Promote safer roads: Supports efforts to identify and report potholes for maintenance.'),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSectionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }

  Widget _buildBulletText(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
