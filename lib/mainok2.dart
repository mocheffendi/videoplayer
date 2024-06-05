import 'package:flutter/material.dart';
import 'video_playlist_widgetok2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VideoPlaylistScreen(),
    );
  }
}

class VideoPlaylistScreen extends StatelessWidget {
  final List<String> videoUrls = [
    'https://videos.pexels.com/video-files/4065222/4065222-hd_1080_2048_25fps.mp4',
    'https://videos.pexels.com/video-files/4040918/4040918-hd_1080_2048_25fps.mp4',
    'https://videos.pexels.com/video-files/5512609/5512609-hd_1080_1920_25fps.mp4',
  ];

  VideoPlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: VideoPlaylistWidget(videoUrls: videoUrls),
    );
  }
}
