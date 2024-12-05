import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class VideoPlayers extends StatefulWidget {
  final String path;
  const VideoPlayers({super.key, required this.path});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoPlayers> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.path))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : Container(),
        ),
      );

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}