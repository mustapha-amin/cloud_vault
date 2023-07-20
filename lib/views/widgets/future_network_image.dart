import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class FutureNetWorkImage extends StatelessWidget {
  final String imgUrl;
  final double? width;
  final BoxFit fit;

  FutureNetWorkImage({
    required this.imgUrl,
    this.width,
    required this.fit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imgUrl,
      width: width,
      fit: fit,
      filterQuality: FilterQuality.high,
      cacheManager: CacheManager(Config(
        imgUrl,
        stalePeriod: const Duration(days: 1),
      )),
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 300),
      placeholder: (context, imgUrl) => Container(
        width: width,
        height: 30.h,
        color: Colors.grey,
      ).animate()
        ..shimmer(
          colors: [
            Colors.white,
            Colors.grey,
          ],
        ),
    );
  }
}
