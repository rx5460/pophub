import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pophub/model/popup_model.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/reservation/waiting_list.dart';
import 'package:pophub/utils/api/store_api.dart';

class WaitingListStorePage extends StatefulWidget {
  final bool useBack;

  const WaitingListStorePage({super.key, this.useBack = true});

  @override
  State<WaitingListStorePage> createState() => _WaitingListStorePageState();
}

class _WaitingListStorePageState extends State<WaitingListStorePage> {
  List<dynamic> storeList = [];

  Future<void> checkStoreApi() async {
    List<dynamic> data = await StoreApi.getMyPopup(User().userName);

    if (!data.toString().contains("fail") &&
        !data.toString().contains("없습니다")) {
      setState(() {
        storeList = data.map((data) => PopupModel.fromJson(data)).toList();
      });
    } else {
      if (mounted) {
        setState(() {
          storeList = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Size screenSize = MediaQuery.of(context).size;
    // double screenWidth = screenSize.width;
    // double screenHeight = screenSize.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomTitleBar(
        titleName: '현장대기',
        useBack: widget.useBack,
      ),
      body: storeList.isEmpty || storeList[0].category == null
          ? Center(
              child: Text(
                ('there_is_no_popup_store_list').tr(),
                style: const TextStyle(fontSize: 18.0),
              ),
            )
          : ListView.builder(
              itemCount: storeList.length,
              itemBuilder: (context, index) {
                final popup = storeList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WaitingList(
                          popup: popup.id!,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        popup.image != null && popup.image!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  '${popup.image![0]}',
                                  width: 100,
                                  height: 100,
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
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                popup.name ?? 'No name',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                (popup.start != null && popup.start!.isNotEmpty)
                                    ? DateFormat("yyyy.MM.dd")
                                        .format(DateTime.parse(popup.start!))
                                    : '',
                              ),
                              Text(popup.location?.replaceAll("/", " ") ??
                                  'No ID'),
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
