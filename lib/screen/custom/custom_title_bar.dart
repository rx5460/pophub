import 'package:flutter/material.dart';

class CustomTitleBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleName;
  final bool useBack;

  const CustomTitleBar({Key? key, this.titleName = "", this.useBack = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: AppBar(
        title: Text(
          titleName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: useBack
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : Container(),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
