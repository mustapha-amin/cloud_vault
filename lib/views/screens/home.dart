import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cloud vault"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      ),
    );
  }
}
