import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  @override
  void initState() {
    super.initState();
    fetchAds();
    _loadSelectedAds();
  }

  Future<void> fetchAds() async {
    final response =
        await http.get(Uri.parse('http://3.233.20.5:3000/admin/event'));

    if (response.statusCode == 200) {
      setState(() {
        ads = (jsonDecode(response.body) as List)
            .map((data) => AdModel.fromJson(data))
            .toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: const Text("failed_to_load_ad_list_")
                .tr(args: [response.body.toString()])),
      );
    }
  }

  Future<void> _loadSelectedAds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedAds = prefs.getStringList('selected_ads');
    if (storedAds != null && storedAds.isNotEmpty) {
      setState(() {
        addedAds = storedAds
            .map((adJson) {
              try {
                return AdModel.fromJson(jsonDecode(adJson));
              } catch (e) {
                print("Invalid JSON data: $adJson, Error: $e");
                return null;
              }
            })
            .where((ad) => ad != null)
            .cast<AdModel>()
            .toList();
      });
    }
  }

  Future<void> _deleteAd(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedAds = prefs.getStringList('selected_ads');

    if (storedAds != null && storedAds.isNotEmpty) {
      // 해당 광고 삭제
      storedAds.removeAt(index);
      await prefs.setStringList('selected_ads', storedAds);

      // UI 업데이트
      setState(() {
        addedAds.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(('the_ad_has_been_removed').tr())),
      );
    }
  }

  Future<void> _navigateToAdEdit(BuildContext context, AdModel ad) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdEditPage(ad: ad),
      ),
    );
    if (result == true) {
      await _loadSelectedAds(); // 광고 등록 후 리스트 갱신
    }
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
        title: Text(
          ('advertisement_list').tr(),
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
                      Text(
                        ('registered_advertisement').tr(),
                        style: const TextStyle(
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
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: pinkColor),
                                onPressed: () {
                                  _deleteAd(index);
                                },
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
                ? Center(
                    child: Text(
                      ('no_advertising_listings').tr(),
                      style: const TextStyle(
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
                      return ListTile(
                        title:
                            Text(ad.title, style: TextStyle(color: pinkColor)),
                        subtitle: Text(
                            '${ad.startDate?.year}.${ad.startDate?.month.toString().padLeft(2, '0')}.${ad.startDate?.day.toString().padLeft(2, '0')}'),
                        onTap: () {
                          _navigateToAdEdit(context, ad);
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
                      builder: (context) => const AdUpload(mode: "add"),
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
                child: Text(
                  ('add_ad').tr(),
                  style: const TextStyle(
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
