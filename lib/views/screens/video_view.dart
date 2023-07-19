import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../widgets/video_player_widget.dart';

class VideoView extends StatefulWidget {
  List<String>? urls;
  int? index;
  VideoView({this.urls, this.index, super.key});

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late PageController pageController;
  int? currentIndex;

  @override
  void initState() {
    currentIndex = widget.index;
    pageController = PageController(initialPage: currentIndex!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: (newIndex) {
          setState(() {
            currentIndex = newIndex;
          });
        },
        controller: pageController,
        children: [
          ...widget.urls!.map((url) => VideoPlayerWidget(url: url)),
        ],
      ),
    );
  }
}
