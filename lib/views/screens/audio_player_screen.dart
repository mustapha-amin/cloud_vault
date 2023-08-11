import 'dart:developer';

import 'package:cloud_vault/utils/spacings.dart';
import 'package:cloud_vault/utils/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_vault/models/cloudvaultfile.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AudioView extends StatefulWidget {
  final List<CLoudVaultFile> files;
  int? index;
  AudioView({required this.files, this.index, super.key});

  @override
  State<AudioView> createState() => _AudioViewState();
}

class _AudioViewState extends State<AudioView>
    with SingleTickerProviderStateMixin {
  int? currentIndex;
  AudioPlayer audioPlayer = AudioPlayer();
  ValueNotifier<bool> isPlaying = ValueNotifier<bool>(false);
  double? _sliderValue = 0.0;
  Duration? _duration = const Duration();

  initPlayer() async {
    await audioPlayer.setSourceUrl(widget.files[widget.index!].url!);
  }

  @override
  void initState() {
    initPlayer();
    currentIndex = widget.index;
    audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
      log(_duration.toString());
    });
    audioPlayer.onPositionChanged.listen((Duration duration) {
      setState(() {
        _sliderValue = duration.inSeconds.toDouble();
      });
    });
    super.initState();
  }

  void playNextAudio() {
    if (currentIndex! < widget.files.length - 1) {
      audioPlayer.stop();
      setState(() {
        currentIndex = currentIndex! + 1;
        // _sliderValue = 0.0;
      });

      playAudio();
    }
  }

  void playPreviousAudio() {
    if (currentIndex! > 0) {
      audioPlayer.stop();
      setState(() {
        currentIndex = currentIndex! - 1;
        //_sliderValue = 0.0;
      });

      playAudio();
    }
  }

  void playAudio() async {
    isPlaying.value = true;
    setState(() {
      _sliderValue = 0.0;
    });

    await audioPlayer.setSourceUrl(widget.files[currentIndex!].url!);
    await audioPlayer.play(UrlSource(widget.files[currentIndex!].url!));
    setState(() {
      _sliderValue = 0.0;
    });
  }

  void pauseAudio() async {
    isPlaying.value = false;
    await audioPlayer.pause();
  }

  @override
  void dispose() {
    audioPlayer.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          addVerticalSpacing(10),
          Center(
            child: Container(
              width: 80.w,
              height: 47.h,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 156, 154, 154),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.music_note,
                size: 100,
              ),
            ).animate(onInit: (controller) {
              controller.repeat();
            }).rotate(
              duration: Duration(seconds: 4),
            ),
          ),
          addVerticalSpacing(20),
          Center(
            child: Text(
              widget.files[currentIndex!].file!.name.split('.').first,
              style: kTextStyle(context: context, size: 16),
            ),
          ),
          Slider(
            value: _sliderValue!,
            onChanged: (double value) {
              setState(() {
                _sliderValue = value;
              });
              audioPlayer.seek(Duration(seconds: _sliderValue!.toInt()));
            },
            min: 0.0,
            max: _duration!.inSeconds.toDouble() ?? 0.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: playPreviousAudio,
                icon: const Icon(Icons.skip_previous),
                iconSize: 40,
              ),
              ValueListenableBuilder(
                  valueListenable: isPlaying,
                  builder: (_, isPlaying, __) {
                    return IconButton(
                      onPressed: () {
                        isPlaying ? pauseAudio() : playAudio();
                      },
                      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                      iconSize: 60,
                    );
                  }),
              IconButton(
                onPressed: playNextAudio,
                icon: const Icon(Icons.skip_next),
                iconSize: 40,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
