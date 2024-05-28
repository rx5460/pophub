import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pophub/model/popup_model.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/store/popup_detail.dart';
import 'package:pophub/utils/api.dart';

class StoreListPage extends StatefulWidget {
  @override
  _StoreListPageState createState() => _StoreListPageState();
}

class _StoreListPageState extends State<StoreListPage> {
  List<PopupModel> popups = [];

  @override
  void initState() {
    pendingList();
    super.initState();
  }

  Future<void> pendingList() async {
    final data = await Api.pendingList();

    if (!data.toString().contains("fail")) {
      setState(() {
        popups = data;
      });
    } else {
      // Error handling code
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomTitleBar(titleName: "승인 리스트"),
      body: ListView.builder(
        itemCount: popups.length,
        itemBuilder: (context, index) {
          final popup = popups[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PopupDetail(
                    storeId: popup.id!,
                    mode: "pending",
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  popup.image != null && popup.image!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            '${popup.image![0]}',
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          popup.name ?? 'No name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          (popup?.start != null && popup!.start!.isNotEmpty)
                              ? DateFormat("yyyy.MM.dd")
                                  .format(DateTime.parse(popup!.start!))
                              : '',
                        ),
                        Text('${popup.location ?? 'No ID'}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
