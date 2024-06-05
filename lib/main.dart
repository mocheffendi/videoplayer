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

// 'https://videos.pexels.com/video-files/4065222/4065222-hd_1080_2048_25fps.mp4',
//     'https://videos.pexels.com/video-files/4040918/4040918-hd_1080_2048_25fps.mp4',
//     'https://videos.pexels.com/video-files/5512609/5512609-hd_1080_1920_25fps.mp4',

class VideoPlaylistScreen extends StatelessWidget {
  final Map<String, Map<String, String>> videoMap = {
    'https://videos.pexels.com/video-files/4065222/4065222-hd_1080_2048_25fps.mp4':
        {
      'Saya sudah punya jadwal janjian':
          'https://videos.pexels.com/video-files/4040918/4040918-hd_1080_2048_25fps.mp4',
      'Saya pertama kali datang di sini, ingin bertanya awal tentang kasus saya':
          'https://videos.pexels.com/video-files/5512609/5512609-hd_1080_1920_25fps.mp4',
    },
    'https://videos.pexels.com/video-files/4040918/4040918-hd_1080_2048_25fps.mp4':
        {
      'Janjian dengan Bu Siti':
          'https://videos.pexels.com/video-files/5512609/5512609-hd_1080_1920_25fps.mp4',
      'Janjian dengan Pak Samuel':
          'https://videos.pexels.com/video-files/5512609/5512609-hd_1080_1920_25fps.mp4',
    },
    'https://videos.pexels.com/video-files/5512609/5512609-hd_1080_1920_25fps.mp4':
        {
      'Persoalan Hukum Perdata':
          'https://videos.pexels.com/video-files/4040918/4040918-hd_1080_2048_25fps.mp4',
      'Persoalan Hukum Pidana':
          'https://videos.pexels.com/video-files/4065222/4065222-hd_1080_2048_25fps.mp4',
      'Persoalan Administratif Hukum':
          'https://videos.pexels.com/video-files/4065222/4065222-hd_1080_2048_25fps.mp4',
      'Konsultasi Hukum':
          'https://videos.pexels.com/video-files/4065222/4065222-hd_1080_2048_25fps.mp4',
    },
  };

  VideoPlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome Sir/Madam'),
      ),
      body: VideoPlaylistWidget(videoMap: videoMap),
    );
  }
}
