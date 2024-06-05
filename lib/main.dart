import 'package:flutter/material.dart';
import 'video_playlist_widget.dart';

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
  final Map<String, Map<String, dynamic>> videoMap = {
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4': {
      'question': 'Please choose an option:',
      'answers': {
        'Option 1':
            'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        'Option 2':
            'https://flutter.github.io/assets-for-api-docs/assets/videos/elephant.mp4',
      },
      'isFinal': false,
    },
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4':
        {
      'question': 'What do you want to see next?',
      'answers': {
        'Option A':
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        'Option B':
            'https://flutter.github.io/assets-for-api-docs/assets/videos/elephant.mp4',
      },
      'isFinal': false,
    },
    'https://flutter.github.io/assets-for-api-docs/assets/videos/elephant.mp4':
        {
      'question': 'Choose your favorite animal:',
      'answers': {
        'Option X':
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        'Option Y':
            'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      },
      'isFinal': true,
    },
  };

  VideoPlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Virtual Assistant Video Playlist'),
      ),
      body: VideoPlaylistWidget(videoMap: videoMap),
    );
  }
}
