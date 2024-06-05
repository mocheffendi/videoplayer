import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  final int playingVideoIndex;

  const VideoPlayerWidget({
    super.key,
    required this.videoItem,
    required this.playingVideoIndex,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoItem.url));
    _initializeController();
  }

  Future<void> _initializeController() async {
    await _controller.initialize();
    _controller.setLooping(true); // Optional: Loop playback
    setState(() {});
  }

  @override
  void dispose() {
    if (widget.playingVideoIndex != widget.videoItem.hashCode) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: widget.playingVideoIndex == widget.videoItem.hashCode
              ? VideoPlayer(_controller)
              : const SizedBox(), // Hide inactive video
        ),
        // ... (Optional controls)
      ],
    );
  }
}

// VideoListWidget displaying videos with thumbnails (optional)
class VideoListWidget extends StatelessWidget {
  final List<VideoItem> videos;
  final Function(int) onVideoTap;

  const VideoListWidget({
    super.key,
    required this.videos,
    required this.onVideoTap,
  });

  @override
  Widget build(BuildContext context) {
    final _playingVideoIndex = context.watch<_MyAppState>()._playingVideoIndex;

    return ListView.builder(
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return GestureDetector(
          onTap: () => onVideoTap(index),
          child: Column(
            children: [
              if (video.thumbnailUrl != null)
                Image.network(video.thumbnailUrl!), // Optional thumbnail
              VideoPlayerWidget(
                videoItem: video,
                playingVideoIndex: _playingVideoIndex,
              ),
            ],
          ),
        );
      },
    );
  }
}

// Main app with sample video data and state management
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // ...

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with ChangeNotifier {
  int _playingVideoIndex = -1; // Initially, no video is playing

  void updatePlayingVideoIndex(int index) {
    _playingVideoIndex = index;
    notifyListeners(); // Notify listeners about the change
  }

  final videos = [
    const VideoItem(
      title: 'Video 1',
      url:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1716538878686-38567b89b5a0?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // Optional
    ),
    const VideoItem(
      title: 'Video 2',
      url:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1715509758911-e00b33e0459a?q=80&w=1930&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    )
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Video Player List'),
        ),
        body: ChangeNotifierProvider(
          create: (_) => _MyAppState(),
          child: VideoListWidget(
            videos: videos, // Replace with your videos
            onVideoTap: updatePlayingVideoIndex,
          ),
        ),
      ),
    );
  }
}
