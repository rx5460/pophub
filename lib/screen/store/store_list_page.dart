// StatefulWidget으로 변환
import 'package:flutter/material.dart';
import 'package:pophub/model/popup_model.dart';
import 'package:pophub/screen/store/popup_detail.dart';
import 'package:pophub/utils/api.dart';

class StoreListPage extends StatefulWidget {
  @override
  _StoreListPageState createState() => _StoreListPageState();
}

// State 클래스 정의
class _StoreListPageState extends State<StoreListPage> {
  List<PopupModel> popups = [];
  @override
  void initState() {
    getPendingList();
    super.initState();
  }

  Future<void> getPendingList() async {
    final data = await Api.getPendingList();

    if (!data.toString().contains("fail")) {
      popups = data;
      setState(() {});
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popup List'),
      ),
      body: ListView.builder(
        itemCount: popups.length,
        itemBuilder: (context, index) {
          final popup = popups[index];
          return ListTile(
            title: Text(popup.name ?? 'No name'),
            subtitle: Text(popup.location ?? 'No location'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PopupDetail(
                          storeId: popup.id!,
                          mode: "pending",
                        )),
              );
            },
          );
        },
      ),
    );
  }
}
