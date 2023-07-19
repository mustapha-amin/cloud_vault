import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:sizer/sizer.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  const VideoPlayerWidget({required this.url, super.key});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController videoPlayerController;
  double _sliderVal = 0;

  void initializeVideoController() {
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
    )..initialize().then((_) => setState(() {}));
    videoPlayerController.play();
    videoPlayerController.addListener(() {
      if (mounted) {
        setState(() {
          _sliderVal =
              videoPlayerController.value.position.inMilliseconds.toDouble();
        });
      }
      videoPlayerController.value.position.inMilliseconds ==
              videoPlayerController.value.duration.inMilliseconds
          ? {
              videoPlayerController.seekTo(const Duration(milliseconds: 0)),
              videoPlayerController.play()
            }
          : null;
    });
  }

  @override
  void initState() {
    initializeVideoController();
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          videoPlayerController.value.isPlaying
              ? videoPlayerController.pause()
              : videoPlayerController.play();
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          VideoPlayer(videoPlayerController),
          videoPlayerController.value.isInitialized
              ? Positioned(
                  child: AnimatedOpacity(
                    opacity: videoPlayerController.value.isPlaying ? 0 : 1,
                    duration: const Duration(seconds: 2),
                    child: Icon(
                      videoPlayerController.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      size: 20.h,
                      color: Colors.white60,
                    ),
                  ),
                )
              : const SizedBox(),
          Positioned(
            width: 100.w,
            bottom: 1,
            child: Slider(
              min: 0,
              max: videoPlayerController.value.duration.inMilliseconds
                  .toDouble(),
              value: _sliderVal,
              onChanged: (newVal) {
                setState(() {
                  _sliderVal = newVal;
                  videoPlayerController
                      .seekTo(Duration(milliseconds: newVal.toInt()));
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
