import 'package:flutter/material.dart';

class FileContents extends StatelessWidget {
  final String title;
  const FileContents({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
    );
  }
}
