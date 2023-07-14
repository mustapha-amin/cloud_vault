import 'package:cloud_vault/models/cloudvaultfile.dart';
import 'package:cloud_vault/utils/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FullScreenImage extends StatefulWidget {
  final List<CLoudVaultFile> file;
  int? index;
  FullScreenImage({required this.file, this.index, super.key});

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  int? currentIndex;

  @override
  void initState() {
    currentIndex = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Text(
          widget.file[currentIndex!].file!.name,
          style: kTextStyle(context: context, size: 13, color: Colors.white),
        ),
      ),
      body: PageView.builder(
        onPageChanged: (newIndex) => setState(() => currentIndex = newIndex),
        itemCount: widget.file.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Center(
              child: SizedBox(
                height: 60.h,
                width: 100.w,
                child: Image.network(
                  widget.file[currentIndex!].url!,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
