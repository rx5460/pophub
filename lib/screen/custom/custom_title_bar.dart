import 'package:flutter/material.dart';

class CustomTitleBar extends StatefulWidget {
  final String titleName;
  final bool useBack;

  const CustomTitleBar({super.key, this.titleName = "", this.useBack = true});

  @override
  State<CustomTitleBar> createState() => _CustomTitleBarState();
}

class _CustomTitleBarState extends State<CustomTitleBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      child: AppBar(
        title: Text(widget.titleName),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
