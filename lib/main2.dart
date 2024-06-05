import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// Model class for video data
class VideoItem {
  final String title;
  final String url;
  final String? thumbnailUrl; // Optional

  const VideoItem({
    required this.title,
    required this.url,
    this.thumbnailUrl,
  });
}

// Reusable VideoPlayerWidget
class VideoPlayerWidget extends StatefulWidget {
  final VideoItem videoItem;

  const VideoPlayerWidget({
    super.key,
    required this.videoItem,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoItem.url);
    _initializeController();
  }

  Future<void> _initializeController() async {
    await _controller.initialize();
    _controller.setLooping(true); // Optional: Loop playback
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
        // Optional controls (play/pause, seek bar)
        Positioned(
          bottom: 10.0,
          right: 10.0,
          child: FloatingActionButton(
            onPressed: () {
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
              setState(() {});
            },
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
        ),
      ],
    );
  }
}

// VideoListWidget displaying videos with thumbnails (optional)
class VideoListWidget extends StatelessWidget {
  final List<VideoItem> videos;

  const VideoListWidget({
    super.key,
    required this.videos,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return Column(
          children: [
            if (video.thumbnailUrl != null)
              Image.network(video.thumbnailUrl!), // Optional thumbnail
            VideoPlayerWidget(videoItem: video),
          ],
        );
      },
    );
  }
}

// Main app with sample video data
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final videos = [
    const VideoItem(
      title: 'Video 1',
      url:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
      thumbnailUrl: 'https://www.example.com/video1_thumbnail.jpg', // Optional
    ),
    const VideoItem(
        title: 'Video 2',
        url:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4'),
  ];

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Video Player List'),
        ),
        body: VideoListWidget(videos: videos),
      ),
    );
  }
}
