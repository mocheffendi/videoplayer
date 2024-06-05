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
          Stack(
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
              Positioned(
                bottom: 200,
                right: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const ChatBubble(
                      text:
                          'Selamat Datang di kantor MSA, \n saya Hanny, \n virtual assiisten bapak Lesley, \n ada yang bisa saya bantu?',
                      isSent: true, // Change to false for received messages
                    ),
                    ElevatedButton(
                      onPressed: _previousVideo,
                      child: const Text('Previous'),
                    ),
                    Container(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: _nextVideo,
                      child: const Text('Next'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSent;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isSent,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        padding: const EdgeInsets.all(12),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: isSent ? const Color(0xFFE1FFC7) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft:
                isSent ? const Radius.circular(16) : const Radius.circular(0),
            bottomRight:
                isSent ? const Radius.circular(0) : const Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
