import 'package:flutter/material.dart';

class CustomTitleBar extends StatefulWidget {
  final String titleName;
  const CustomTitleBar({super.key, this.titleName = ""});

  @override
  State<CustomTitleBar> createState() => _CustomTitleBarState();
}

class _CustomTitleBarState extends State<CustomTitleBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 70),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 시작과 끝에 정렬
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black87,
              size: 30,
            ),
          ),
          Text(
            widget.titleName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 40), // 가운데 공간 확보
        ],
      ),
    );
  }
}
