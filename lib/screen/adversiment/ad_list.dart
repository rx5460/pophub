import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pophub/model/ad_model.dart';
import 'package:pophub/screen/adversiment/ad_edit.dart';
import 'package:pophub/screen/adversiment/ad_upload.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdListPage extends StatefulWidget {
  const AdListPage({Key? key}) : super(key: key);

  @override
  AdListPageState createState() => AdListPageState();
}

class AdListPageState extends State<AdListPage> {
  List<AdModel> ads = [];
  List<AdModel> addedAds = [];
  final Color pinkColor = const Color(0xFFE6A3B3);
  Set<String> selectedAds = {};

  @override
  void initState() {
    super.initState();
    fetchAds();
    _loadSelectedAds();
  }

  Future<void> fetchAds() async {
    final response =
        await http.get(Uri.parse('http://3.88.120.90:3000/admin/event'));

    if (response.statusCode == 200) {
      setState(() {
        ads = (jsonDecode(response.body) as List)
            .map((data) => AdModel.fromJson(data))
            .toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("광고 목록을 불러오지 못했습니다: ${response.body}")),
      );
    }
  }

  Future<void> _loadSelectedAds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedAds = prefs.getStringList('selected_ads');
    setState(() {
      selectedAds = storedAds?.toSet() ?? {};
    });
  }

  Future<void> _showRegisterAdDialog(AdModel ad) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("광고 등록"),
          content: Text("${ad.title} 광고를 등록하시겠습니까?"),
          actions: <Widget>[
            TextButton(
              child: const Text("취소"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("등록"),
              onPressed: () {
                _toggleAdSelection(ad);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // 등록할 광고 선택/해제
  Future<void> _toggleAdSelection(AdModel ad) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (selectedAds.contains(ad.id)) {
        selectedAds.remove(ad.id);
        addedAds.remove(ad);
      } else {
        selectedAds.add(ad.id);
        addedAds.insert(0, ad);
      }
    });

    await prefs.setStringList('selected_ads', selectedAds.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '광고 목록',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          addedAds.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text(
                        '등록된 광고',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: addedAds.length,
                        itemBuilder: (context, index) {
                          final ad = addedAds[index];
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: pinkColor, width: 1.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              tileColor: Colors.white.withOpacity(0.85),
                              title: Text(ad.title,
                                  style: TextStyle(color: pinkColor)),
                              subtitle: Text(
                                  '${ad.startDate?.year}.${ad.startDate?.month.toString().padLeft(2, '0')}.${ad.startDate?.day.toString().padLeft(2, '0')}'),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  _toggleAdSelection(ad);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: pinkColor,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                                child: const Text(
                                  '등록 해제',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              : Container(),
          const Divider(),
          Expanded(
            child: ads.isEmpty
                ? const Center(
                    child: Text(
                      '광고 목록이 없습니다!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: ads.length,
                    itemBuilder: (context, index) {
                      final ad = ads[index];
                      selectedAds.contains(ad.id);
                      return ListTile(
                        title:
                            Text(ad.title, style: TextStyle(color: pinkColor)),
                        subtitle: Text(
                            '${ad.startDate?.year}.${ad.startDate?.month.toString().padLeft(2, '0')}.${ad.startDate?.day.toString().padLeft(2, '0')}'),
                        trailing: ElevatedButton(
                          onPressed: () {
                            _showRegisterAdDialog(ad);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: pinkColor,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          child: const Text(
                            '등록',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () {
                          print(ad.title);
                          print(ad.img);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdEditPage(ad: ad),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdUpload(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: pinkColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                child: const Text(
                  '광고 추가',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
