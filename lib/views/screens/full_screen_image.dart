import 'package:cloud_vault/models/cloudvaultfile.dart';
import 'package:cloud_vault/providers/files_provider.dart';
import 'package:cloud_vault/utils/spacings.dart';
import 'package:cloud_vault/utils/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class FullScreenImage extends StatefulWidget {
  final List<CLoudVaultFile> file;
  int? index;
  FullScreenImage({required this.file, this.index, super.key});

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  late int currentIndex;
  PageController? pageController;

  @override
  void initState() {
    currentIndex = widget.index!;
    pageController = PageController(initialPage: currentIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var fileProvider = Provider.of<FileProvider>(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Text(
          widget.file[currentIndex].file!.name,
          style: kTextStyle(context: context, size: 13, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                  child: PageView(
                onPageChanged: (newIndex) {
                  setState(() {
                    currentIndex = newIndex;
                  });
                },
                controller: pageController,
                scrollDirection: Axis.horizontal,
                physics: fileProvider.isLoading
                    ? const NeverScrollableScrollPhysics()
                    : const ClampingScrollPhysics(),
                children: [
                  ...widget.file.map(
                    (e) => Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                      child: Center(
                        child: Image.network(
                          e.url!,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.medium,
                        ),
                      ),
                    ),
                  )
                ],
              )),
              Container(
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                    ),
                    addHorizontalSpacing(20),
                    IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Delete'),
                                content: const Text(
                                  "Do you wan to delete this image",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      fileProvider.deleteFile(
                                        'images',
                                        widget.file[currentIndex].file!.name,
                                        widget.file,
                                      );
                                      Navigator.pop(context);
                                      if (widget.file.isEmpty) {
                                        Navigator.pop(context);
                                        return;
                                      }
                                      if (currentIndex > 0) {
                                        currentIndex--;
                                      }
                                    },
                                    child: const Text("Yes"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("No"),
                                  )
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            child: Center(
              child: !fileProvider.isLoading
                  ? const SizedBox()
                  : const CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
