import 'dart:developer';

import 'package:cloud_vault/services/database.dart';
import 'package:cloud_vault/utils/textstyle.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_vault/models/cloudvaultfile.dart';
import 'package:sizer/sizer.dart';

class FileContents extends StatefulWidget {
  final String title;
  final IconData iconData;
  const FileContents({required this.title, required this.iconData, super.key});

  @override
  State<FileContents> createState() => _FileContentsState();
}

class _FileContentsState extends State<FileContents> {
  late Future<ListResult> files;
  bool isGrid = true;

  @override
  void initState() {
    files = DatabaseService().getFiles(widget.title);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isGrid = !isGrid;
                });
              },
              child: Icon(
                isGrid ? Icons.list : Icons.grid_view,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<ListResult>(
        future: files,
        builder: (context, snapshot) {
          List<Reference> items = snapshot.data!.items;
          if (snapshot.hasData) {
            return isGrid
                ? GridView.builder(
                    itemCount: items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return GridFile(item: item);
                    },
                  )
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: SizedBox(
                          width: 12.w,
                          child: NetworkImageLoader(
                            imgHeight: 8.h,
                            imageUrlFuture: items[index].getDownloadURL(),
                          ),
                        ),
                        title: Text(
                          items[index].name,
                          style: kTextStyle(context: context, size: 12),
                        ),
                      );
                    },
                  );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class GridFile extends StatelessWidget {
  final Reference item;

  const GridFile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300]!,
              blurRadius: 0.3,
            ),
            BoxShadow(
              color: Colors.grey[300]!,
              blurRadius: 0.3,
            )
          ]),
      child: Column(
        children: [
          Expanded(
            child: NetworkImageLoader(
              imageUrlFuture: item.getDownloadURL(),
            ),
          ),
          Text(
            item.name,
            style: kTextStyle(context: context, size: 10),
          ),
        ],
      ),
    );
  }
}

class NetworkImageLoader extends StatelessWidget {
  double? imgHeight;
  final Future<String> imageUrlFuture;

  NetworkImageLoader({required this.imageUrlFuture, this.imgHeight});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: imageUrlFuture,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          final imageUrl = snapshot.data!;
          return Image.network(
            imageUrl,
            height: imgHeight ?? 20.h,
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error loading image"));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
