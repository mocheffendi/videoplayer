import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlaylistWidget extends StatefulWidget {
  final Map<String, Map<String, String>> videoMap;

  const VideoPlaylistWidget({super.key, required this.videoMap});

  @override
  State<VideoPlaylistWidget> createState() => _VideoPlaylistWidgetState();
}

class _VideoPlaylistWidgetState extends State<VideoPlaylistWidget> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  String? _currentVideoUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentVideoUrl = widget.videoMap.keys.first;
    _initializePlayer(_currentVideoUrl!, autoPlay: false);
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
        _isLoading = false;
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

  void _loadNextVideo(String url) {
    setState(() {
      _isLoading = true;
      _disposePlayer();
      _initializePlayer(url, autoPlay: true);
      _currentVideoUrl = url;
    });
  }

  @override
  void dispose() {
    _disposePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : AspectRatio(
                  key: ValueKey<String>(_currentVideoUrl!),
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: Chewie(
                    controller: _chewieController,
                  ),
                ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ChatBubble(
                  text:
                      'Selamat Datang di kantor MSA, saya Hanny, virtual assiisten bapak Lesley, ada yang bisa saya bantu?',
                ),
                ...widget.videoMap[_currentVideoUrl]!.keys.map((option) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _loadNextVideo(
                            widget.videoMap[_currentVideoUrl]![option]!);
                      },
                      child: Text(option),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;

  ChatBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
