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
    'https://videos.pexels.com/video-files/4065222/4065222-hd_1080_2048_25fps.mp4':
        {
      'question':
          'Selamat Datang di kantor MSA, saya Hanny, virtual assiisten bapak Lesley, ada yang bisa saya bantu?:',
      'answers': {
        'Saya sudah punya jadwal janjian':
            'https://videos.pexels.com/video-files/4040918/4040918-hd_1080_2048_25fps.mp4',
        'Saya pertama kali datang di sini':
            'https://videos.pexels.com/video-files/5512609/5512609-hd_1080_1920_25fps.mp4',
      },
      'isFinal': false,
    },
    'https://videos.pexels.com/video-files/4040918/4040918-hd_1080_2048_25fps.mp4':
        {
      'question': 'Ingin bertemu dengan siapa',
      'answers': {
        'Janjian dengan Bu Siti':
            'https://videos.pexels.com/video-files/5512609/5512609-hd_1080_1920_25fps.mp4',
        'Janjian dengan Pak Samuel':
            'https://videos.pexels.com/video-files/5512609/5512609-hd_1080_1920_25fps.mp4',
        'Janjian dengan Pak Doddy':
            'https://videos.pexels.com/video-files/5512609/5512609-hd_1080_1920_25fps.mp4',
      },
      'isFinal': false,
    },
    'https://videos.pexels.com/video-files/5512609/5512609-hd_1080_1920_25fps.mp4':
        {
      'question': 'Persoalan apa yang bisa kami bantu',
      'answers': {
        'Persoalan Hukum Perdata':
            'https://videos.pexels.com/video-files/11856385/11856385-hd_1080_1920_25fps.mp4',
        'Persoalan Hukum Pidana':
            'https://videos.pexels.com/video-files/11856385/11856385-hd_1080_1920_25fps.mp4',
        'Persoalan Administratif Hukum':
            'https://videos.pexels.com/video-files/11856385/11856385-hd_1080_1920_25fps.mp4',
        'Konsultasi Hukum':
            'https://videos.pexels.com/video-files/11856385/11856385-hd_1080_1920_25fps.mp4',
      },
      'isFinal': false,
    },
    'https://videos.pexels.com/video-files/11856385/11856385-hd_1080_1920_25fps.mp4':
        {
      'question': 'Silahkan naik ke Lantai 3:',
      'answers': {
        'Submit':
            'https://videos.pexels.com/video-files/20770858/20770858-hd_1080_1920_30fps.mp4',
      },
      'isFinal': false,
    },
    'https://videos.pexels.com/video-files/20770858/20770858-hd_1080_1920_30fps.mp4':
        {
      'question': 'Silahkan naik ke Lantai 3:',
      'answers': {
        'Baik terimakasih':
            'https://videos.pexels.com/video-files/4065222/4065222-hd_1080_2048_25fps.mp4',
      },
      'isFinal': true,
    },
  };

  VideoPlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Virtual Assistant Video Playlist'),
      // ),
      body: VideoPlaylistWidget(videoMap: videoMap),
    );
  }
}
