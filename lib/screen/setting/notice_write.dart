import 'package:flutter/material.dart';

class NoticeWrite extends StatefulWidget {
  const NoticeWrite({super.key});

  @override
  State<NoticeWrite> createState() => _NoticeWriteState();
}

class _NoticeWriteState extends State<NoticeWrite> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    // double screenHeight = screenSize.height;
    double bottomNavBarHeight = kBottomNavigationBarHeight;
    return Scaffold(
      appBar: AppBar(
        title: const Text("dsa"),
      ),
    );
  }
}
