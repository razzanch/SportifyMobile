import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  double _currentPosition = 0.0;
  double _totalDuration = 1.0;  // Set to 1 to avoid divide by zero error initially
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _totalDuration = _controller.value.duration.inSeconds.toDouble();
        });
      });

    _controller.addListener(() {
      setState(() {
        _currentPosition = _controller.value.position.inSeconds.toDouble();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isPlaying = _controller.value.isPlaying;
    });
  }

  void _seekToPosition(double value) {
    final position = Duration(seconds: value.toInt());
    _controller.seekTo(position);
  }

  String _formatDuration(double durationInSeconds) {
    final duration = Duration(seconds: durationInSeconds.toInt());
    return "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
            });
          },
          child: SizedBox(
            width: 300,
            height: 300,
            child: _controller.value.isInitialized
                ? VideoPlayer(_controller)
                : const Center(child: CircularProgressIndicator()),
          ),
        ),
        const SizedBox(height: 8),
        // Progress bar (Slider)
        Slider(
          value: _currentPosition,
          min: 0.0,
          max: _totalDuration,
          onChanged: (double value) {
            _seekToPosition(value);
          },
        ),
        const SizedBox(height: 8),
        // Play/Pause button
        IconButton(
          icon: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
          ),
          onPressed: _togglePlayPause,
        ),
        const SizedBox(height: 8),
        // Progress text
        Text(
          "${_formatDuration(_currentPosition)} / ${_formatDuration(_totalDuration)}",
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
