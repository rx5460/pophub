import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/screen/funding/funding_list_detail.dart';

class FundingList extends StatefulWidget {
  const FundingList({
    super.key,
  });

  @override
  State<FundingList> createState() => _FundingListState();
}

class _FundingListState extends State<FundingList>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  var countFomat = NumberFormat('###,###,###,###');
  List<Map<String, dynamic>> fundingItem = [];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            '펀딩 리스트',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: User().role == "President"
              ? TabBar(
                  controller: _tabController,
                  dividerColor: Constants.DEFAULT_COLOR,
                  indicatorColor: Constants.DEFAULT_COLOR,
                  indicatorWeight: 3.5,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: Colors.black,
                  labelStyle: const TextStyle(fontSize: 20),
                  tabs: [
                    Tab(
                        child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.33,
                      child: const Center(child: Text('사용자')),
                    )),
                    Tab(
                        child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.33,
                      child: const Center(child: Text('제품')),
                    )),
                  ],
                )
              : null),
      body: User().role == 'General Member'
          ? Column(
              children: [
                Container(
                  height: 1,
                  decoration:
                      const BoxDecoration(color: Constants.DEFAULT_COLOR),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FundingListDetail()),
                    );
                  },
                  child: Container(
                      width: screenWidth,
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1, color: Constants.DEFAULT_COLOR))),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '2024.09.03',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            const Text('수키도키 팝업스토어',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w900)),
                            const SizedBox(
                              height: 3,
                            ),
                            const Text('파일폴더 및 액자 세트',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500)),
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              children: [
                                const Text(
                                  '수량 : 1개',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      color: Constants.DARK_GREY),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  '${countFomat.format(8900)}원',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      color: Constants.DARK_GREY),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                )
              ],
            )
          : TabBarView(
              controller: _tabController,
              children: [
                Column(
                  children: [
                    Container(
                      height: 1,
                      decoration:
                          const BoxDecoration(color: Constants.DEFAULT_COLOR),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FundingListDetail(
                                    mode: 'President',
                                  )),
                        );
                      },
                      child: Container(
                          width: screenWidth,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1,
                                      color: Constants.DEFAULT_COLOR))),
                          child: const Padding(
                            padding: EdgeInsets.only(
                                top: 10, bottom: 10, left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '황지민님',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  '2024.08.16 10:10',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      color: Constants.DARK_GREY),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text('파일폴더 및 액자 세트',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                                SizedBox(
                                  height: 3,
                                ),
                              ],
                            ),
                          )),
                    )
                  ],
                ),
                Column(
                  children: [
                    for (int index = 0;
                        index < (fundingItem.length ?? 0);
                        index++)
                      if (fundingItem != [])
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      width: 1, color: Constants.DEFAULT_COLOR),
                                  bottom: BorderSide(
                                      width: 1,
                                      color: Constants.DEFAULT_COLOR))),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 40, bottom: 40, left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/images/goods.png',
                                    // width: screenHeight * 0.07 - 5,
                                    width: screenWidth * 0.32,
                                    height: screenWidth * 0.32,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${countFomat.format(fundingItem[index]["price"])}원",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      fundingItem[index]["title"].toString(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "제한수량 ${fundingItem[index]["limit"].toString()}개",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.4,
                                      child: Text(
                                        fundingItem[index]["description"]
                                            .toString(),
                                        style: const TextStyle(fontSize: 11),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        fundingItem.removeAt(index);
                                      });
                                    },
                                    child: const Icon(Icons.close)),
                              ],
                            ),
                          ),
                        ),
                  ],
                )
              ],
            ),
    );
  }
}
