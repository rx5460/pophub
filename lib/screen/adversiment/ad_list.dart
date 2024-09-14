import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdDetailsPage extends StatelessWidget {
  final Map<String, dynamic> ad;

  const AdDetailsPage({required this.ad, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color pinkColor = Color(0xFFE6A3B3);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '광고 상세 정보',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: pinkColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ad['title'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              ad['startDate'] ?? '날짜 정보 없음',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            if (ad['imageUrl'] != null)
              Image.network(ad['imageUrl'], height: 200, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(
              ad['content'],
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class AdListPage extends StatefulWidget {
  const AdListPage({super.key});

  @override
  AdListPageState createState() => AdListPageState();
}

class AdListPageState extends State<AdListPage> {
  List ads = [];
  final Color pinkColor = const Color(0xFFE6A3B3);

  @override
  void initState() {
    super.initState();
    fetchAds();
  }

  Future<void> fetchAds() async {
    final response =
        await http.get(Uri.parse('http://3.88.120.90:3000/admin/event'));

    if (response.statusCode == 200) {
      setState(() {
        ads = jsonDecode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("광고 목록을 불러오지 못했습니다: ${response.body}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '광고 목록',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: pinkColor,
      ),
      body: ads.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '광고 리스트',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: pinkColor,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: ads.length,
                    itemBuilder: (context, index) {
                      final ad = ads[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: pinkColor),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          title: Text(ad['title'],
                              style: TextStyle(color: pinkColor)),
                          subtitle: Text(ad['content']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdDetailsPage(ad: ad),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
