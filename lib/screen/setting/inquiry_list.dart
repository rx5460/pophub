import 'package:flutter/material.dart';

class InquiryPage extends StatefulWidget {
  const InquiryPage({Key? key}) : super(key: key);

  @override
  InquiryPageState createState() => InquiryPageState();
}

class InquiryPageState extends State<InquiryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '문의 내역',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFE6A3B3),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: '일반 문의'),
            Tab(text: '광고 문의'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                Center(
                    child:
                        Text('문의 내용이 없습니다!', style: TextStyle(fontSize: 16))),
                Center(
                    child: Text('광고 문의 내용이 없습니다!',
                        style: TextStyle(fontSize: 16))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE6A3B3),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text(
                  _tabController.index == 0 ? '문의 하기' : '광고 문의 하기',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
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
