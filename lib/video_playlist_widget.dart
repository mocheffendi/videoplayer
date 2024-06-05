import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlaylistWidget extends StatefulWidget {
  final List<String> videoUrls;

  const VideoPlaylistWidget({super.key, required this.videoUrls});

  @override
  State<VideoPlaylistWidget> createState() => _VideoPlaylistWidgetState();
}

class _VideoPlaylistWidgetState extends State<VideoPlaylistWidget> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer(widget.videoUrls[_currentIndex], autoPlay: false);
  }

  void _initializePlayer(String url, {bool autoPlay = false}) {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: autoPlay,
      looping: false,
    );

    _videoPlayerController.initialize().then((_) {
      setState(() {
        _isLoading = false; // Set loading to false once video is initialized
      });
      if (autoPlay) {
        _videoPlayerController.play();
      }
    });
  }

  void _disposePlayer() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }

  void _nextVideo() {
    if (_currentIndex < widget.videoUrls.length - 1) {
      setState(() {
        _isLoading = true; // Set loading to true before switching video
        _currentIndex++;
        _disposePlayer();
        _initializePlayer(widget.videoUrls[_currentIndex], autoPlay: true);
      });
    }
  }

  void _previousVideo() {
    if (_currentIndex > 0) {
      setState(() {
        _isLoading = true; // Set loading to true before switching video
        _currentIndex--;
        _disposePlayer();
        _initializePlayer(widget.videoUrls[_currentIndex], autoPlay: true);
      });
    }
  }

  @override
  void dispose() {
    _disposePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : AspectRatio(
                    key: ValueKey<int>(_currentIndex),
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: Chewie(
                      controller: _chewieController,
                    ),
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _previousVideo,
                child: const Text('Previous'),
              ),
              ElevatedButton(
                onPressed: _nextVideo,
                child: const Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
