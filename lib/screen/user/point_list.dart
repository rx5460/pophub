import 'package:flutter/material.dart';
import 'package:pophub/model/point_model.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/utils/api/user_api.dart';
import 'package:pophub/utils/log.dart';

class PointListPage extends StatefulWidget {
  const PointListPage({super.key});

  @override
  _PointListPageState createState() => _PointListPageState();
}

class _PointListPageState extends State<PointListPage> {
  // 예제 데이터 리스트
  List<PointModel> points = [];
  bool isLoading = true; // 로딩 상태를 나타내는 변수

  Future<void> getPointList() async {
    try {
      List<PointModel>? dataList = await UserApi.getPointList();
      if (dataList.isNotEmpty) {
        setState(() {
          points = dataList;
          isLoading = false; // 데이터 로딩 완료
        });
      } else {
        setState(() {
          isLoading = false; // 데이터가 없을 경우에도 로딩 완료
        });
      }
    } catch (error) {
      Logger.debug('Error getPointList data: $error');
      setState(() {
        isLoading = false; // 에러 발생 시에도 로딩 완료
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPointList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTitleBar(
        titleName: ('포인트'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // 로딩 중일 때 인디케이터 표시
          : ListView.builder(
              itemCount: points.length,
              itemBuilder: (context, index) {
                final point = points[index];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    point.description,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              point.calcul,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${point.pointScore}원',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(), // 리스트 아이템 사이에 구분선 추가
                  ],
                );
              },
            ),
    );
  }
}
