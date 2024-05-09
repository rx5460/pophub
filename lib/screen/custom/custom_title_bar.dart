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
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 시작과 끝에 정렬
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: widget.useBack,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black87,
                size: 30,
              ),
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
