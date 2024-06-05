import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VideoPlaylistWidget extends StatefulWidget {
  final Map<String, Map<String, dynamic>> videoMap;

  const VideoPlaylistWidget({super.key, required this.videoMap});

  @override
  State<VideoPlaylistWidget> createState() => _VideoPlaylistWidgetState();
}

class _VideoPlaylistWidgetState extends State<VideoPlaylistWidget> {
  late VideoPlayerController _videoPlayerController;
  String? _currentVideoUrl;
  bool _isLoading = true;
  final List<String> _choices = [];
  final String _googleSheetUrl =
      'https://script.google.com/macros/s/AKfycbxqBrSvyWCjHpAnThfwOd0tsE4hdCm1Bm9-HJO2Gahd52RedsilUTczeqzS6TXGGzv0/exec'; // Replace with your Google Apps Script URL

  @override
  void initState() {
    super.initState();
    _currentVideoUrl = widget.videoMap.keys.first;
    _initializePlayer(_currentVideoUrl!, autoPlay: false);
  }

  void _initializePlayer(String url, {bool autoPlay = false}) {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
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
  }

  Future<void> _submitChoices() async {
    try {
      log('Submitting choices');
      log('$_choices');
      log(jsonEncode(<String, dynamic>{
        'choices': _choices,
      }));

      // final response3 =
      //     // await http.get(Uri.parse("https://api.chucknorris.io/jokes/random"));
      //     await http.get(Uri.parse(
      //         "https://script.google.com/macros/s/AKfycbxqBrSvyWCjHpAnThfwOd0tsE4hdCm1Bm9-HJO2Gahd52RedsilUTczeqzS6TXGGzv0/exec"));

      // log(response3.body);

      // if (response3.statusCode == 200) {
      //   return jsonDecode(response3.body);
      // } else {
      //   log('Failed to fetch joke');
      // }

      // var uri = Uri.https('https://script.google.com',
      //     '/macros/s/AKfycbxqBrSvyWCjHpAnThfwOd0tsE4hdCm1Bm9-HJO2Gahd52RedsilUTczeqzS6TXGGzv0/exec');

      // final response2 = await http.get(
      //   uri,
      //   headers: {
      //     "Access-Control-Allow-Origin":
      //         "*", // Required for CORS support to work
      //     "Access-Control-Allow-Credentials":
      //         'true', // Required for cookies, authorization headers with HTTPS
      //     "Access-Control-Allow-Headers":
      //         "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      //     "Access-Control-Allow-Methods": "POST, OPTIONS"
      //   },
      //   // body: jsonEncode(<String, dynamic>{
      //   //   'choices': ["Pak Lesley", "Hukum Perdata", "Gono Gini"],
      //   // }),
      // );

      // log('Response status: ${response2.statusCode}');
      // log('Response body: ${response2.body}');

      // final response1 = await http.post(
      //   Uri.parse(
      //       'https://script.google.com/macros/s/AKfycbxqBrSvyWCjHpAnThfwOd0tsE4hdCm1Bm9-HJO2Gahd52RedsilUTczeqzS6TXGGzv0/exec'),
      //   headers: <String, String>{
      //     'Content-Type': 'application/json; charset=UTF-8',
      //   },
      //   body: jsonEncode(<String, dynamic>{
      //     'choices': ["Pak Lesley", "Hukum Perdata", "Gono Gini"],
      //   }),
      // );

      // debugPrint('terpanggil');
      // log('Response status: ${response1.statusCode}');
      // log('Response body: ${response1.body}');

      final response = await http.post(
        Uri.parse(_googleSheetUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods":
              "POST, GET, OPTIONS, PUT, DELETE, HEAD",
        },
        body: jsonEncode(<String, dynamic>{
          'choices': _choices,
        }),
      );

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Successfully sent data to Google Sheets
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Choices submitted successfully!')));
      } else {
        log('failed');
        // Failed to send data to Google Sheets
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to submit choices.')));
      }
    } catch (e) {
      // Error occurred while sending data to Google Sheets
      log('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting choices: $e')));
    }
  }

  void _loadNextVideo(String url, String choice) {
    setState(() {
      _isLoading = true;
      _disposePlayer();
      _choices.add(choice);
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
                  child: VideoPlayer(_videoPlayerController),
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
                  text: widget.videoMap[_currentVideoUrl]!['question'],
                ),
                ...widget.videoMap[_currentVideoUrl]!['answers'].keys
                    .map((option) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ElevatedButton(
                      onPressed: () {
                        String nextUrl = widget
                            .videoMap[_currentVideoUrl]!['answers'][option]!;
                        bool isFinal = widget.videoMap[nextUrl]!['isFinal'];
                        if (isFinal) {
                          _choices.add(option);
                          _submitChoices();
                        } else {
                          _loadNextVideo(nextUrl, option);
                        }
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

  const ChatBubble({super.key, required this.text});

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
