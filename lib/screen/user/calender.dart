import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/visit_model.dart';
import 'package:pophub/screen/user/qr_scan.dart';
import 'package:pophub/utils/api/visit_api.dart';
import 'package:pophub/utils/log.dart';

class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  late DateTime _currentDate;
  late DateTime _selectedDate;
  bool _isExpanded = false;

  List<VisitModel>? visitList;
  List<VisitModel>? visitData = [];

  Future<void> fetchVisitData() async {
    try {
      List<VisitModel>? dataList = await VisitApi.getCalendar();

      if (dataList.isNotEmpty) {
        setState(() {
          visitList = dataList;
          // 방문일정 초기화
          visitData?.clear();
          for (int i = 0; i < visitList!.length; i++) {
            DateTime visitDate =
                DateTime.parse(visitList![i].reservationDate.toString());
            DateTime visitDate2 =
                DateTime(visitDate.year, visitDate.month, visitDate.day);
            if (visitDate2 ==
                DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day)) {
              // 일치하는 방문일정이 있으면 visitData에 추가
              setState(() {
                visitData?.add(visitList![i]);
              });
            }
          }
        });
      }
    } catch (error) {
      visitList = [];
      Logger.debug('Error fetching calendar data: $error');
    }
  }

  void fetchData() {
    _currentDate = DateTime.now();
    _selectedDate = DateTime.now();
    fetchVisitData();
  }

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  // 특정 날짜에 예약된 일정이 있는지 확인하는 함수
  bool _hasScheduleOnDate(DateTime date) {
    if (visitList == null || visitList!.isEmpty) {
      return false;
    }

    // visitList의 각 reservation_date를 확인하여 date와 같은 날짜가 있는지 체크
    return visitList!.any((visit) {
      DateTime reservationDate = DateTime.parse(visit.reservationDate!);
      if (reservationDate.year == date.year &&
          reservationDate.month == date.month &&
          reservationDate.day == date.day) {
        return true;
      } else {
        return false;
      }
    });
  }

  Widget _buildCollapsedFloatingButton() {
    return FloatingActionButton(
      onPressed: () {
        setState(() {
          _isExpanded = true;
        });
      },
      backgroundColor: Constants.DEFAULT_COLOR,
      shape: const CircleBorder(),
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  Widget _buildExpandedFloatingButtons() {
    return Transform.translate(
      offset: Offset(MediaQuery.of(context).size.width * 0.04,
          MediaQuery.of(context).size.height * 0.02),
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = false;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white.withOpacity(0.85),
              child: Padding(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.04,
                    bottom: MediaQuery.of(context).size.height * 0.02),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildFloatingButtonWithText(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const QrScan(
                                    type: "reservation",
                                    // refreshData: fetchData,
                                  )),
                        );
                      },
                      icon: Icons.calendar_month_outlined,
                      text: '사전예약',
                    ),
                    const SizedBox(height: 16),
                    _buildFloatingButtonWithText(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const QrScan(
                                    type: "waiting",
                                    // refreshData: fetchData,
                                  )),
                        );
                      },
                      icon: Icons.door_front_door_outlined,
                      text: '현장대기',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButtonWithText({
    required Function onPressed,
    required IconData icon,
    required String text,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 8),
        FloatingActionButton(
          onPressed: onPressed as void Function()?,
          heroTag: null,
          backgroundColor: Constants.DEFAULT_COLOR,
          shape: const CircleBorder(),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            setState(() {
              _currentDate =
                  DateTime(_currentDate.year, _currentDate.month - 1);
              _selectedDate =
                  DateTime(_currentDate.year, _currentDate.month, 1);
            });
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text('${_currentDate.year}년 ${_currentDate.month}월',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _currentDate =
                    DateTime(_currentDate.year, _currentDate.month + 1);
                _selectedDate =
                    DateTime(_currentDate.year, _currentDate.month, 1);
              });
            },
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
            ),
          ),
        ],
      ),
      floatingActionButton: _isExpanded
          ? _buildExpandedFloatingButtons()
          : _buildCollapsedFloatingButton(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(
                top: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DayOfWeek(str: 'S'),
                  DayOfWeek(str: 'M'),
                  DayOfWeek(str: 'T'),
                  DayOfWeek(str: 'W'),
                  DayOfWeek(str: 'T'),
                  DayOfWeek(str: 'F'),
                  DayOfWeek(str: 'S'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  width: 0.5,
                  color: Colors.grey,
                ))),
              ),
            ),
            SizedBox(
              width: screenWidth * 0.9,
              child: Table(
                children: buildCalendar(_currentDate),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            SizedBox(
              width: screenWidth * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_selectedDate.month}월 ${_selectedDate.day}일 (${getWeekdayString(_selectedDate.weekday)})',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20, left: 8, bottom: 16),
                    child: Text(
                      '방문',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Container(
                      width: screenWidth * 0.82,
                      height: screenHeight * 0.07,
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            width: 3,
                            color: Constants.DEFAULT_COLOR,
                          ),
                        ),
                      ),
                      child: visitData != null && visitData!.isNotEmpty
                          ? ListView.builder(
                              itemCount: visitData!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 1),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4, bottom: 4, right: 4),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              8.0), // 모서리를 둥글게 설정
                                          child: Image.network(
                                            visitData![index].images!,
                                            fit: BoxFit.cover,
                                            width: screenHeight * 0.07 - 8,
                                            height: screenHeight * 0.07 - 8,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: screenHeight * 0.07,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                visitData![index].storeName!,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                DateFormat('yyyy-MM-dd HH:mm')
                                                    .format(DateTime.parse(
                                                        visitData![index]
                                                            .reservationDate!)),
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ]),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : SizedBox(
                              height: screenHeight * 0.07,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('방문한 팝업스토어가 없습니다.'),
                                  ),
                                ],
                              )),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TableRow> buildCalendar(DateTime dateTime) {
    Util util = Util();
    List<TableRow> rows = [];
    int daysInMonth = DateTime(dateTime.year, dateTime.month + 1, 0).day;
    int startingWeekday = DateTime(dateTime.year, dateTime.month, 1).weekday;
    int weeksInMonth = util.calculateWeeksInMonth(dateTime);
    int dayCounter = 1;

    if (startingWeekday == 7) {
      weeksInMonth -= 1;
    }

    for (int i = 0; i < weeksInMonth; i++) {
      List<Widget> cells = [];
      for (int j = 0; j < 7; j++) {
        if ((i == 0 && j < startingWeekday && startingWeekday != 7) ||
            dayCounter > daysInMonth) {
          cells.add(Container(height: 45));
        } else {
          int currentDayCounter = dayCounter;
          DateTime currentDate =
              DateTime(dateTime.year, dateTime.month, currentDayCounter);
          bool hasSchedule = _hasScheduleOnDate(currentDate);

          cells.add(
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                setState(() {
                  visitData?.clear(); // 날짜를 선택할 때마다 visitData 초기화
                  for (int i = 0; i < visitList!.length; i++) {
                    DateTime visitDate = DateTime.parse(
                        visitList![i].reservationDate.toString());
                    DateTime visitDate2 = DateTime(
                        visitDate.year, visitDate.month, visitDate.day);
                    if (visitDate2 == currentDate) {
                      visitData?.add(visitList![i]);
                    }
                  }
                  _selectedDate = DateTime(
                      dateTime.year, dateTime.month, currentDayCounter);
                });
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _selectedDate.day == currentDayCounter
                        ? Column(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Constants.DEFAULT_COLOR,
                                ),
                                child: Center(
                                  child: Text(
                                    '$currentDayCounter',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: hasSchedule
                                        ? Constants.DEFAULT_COLOR
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: Center(
                                  child: Text(
                                    '$currentDayCounter',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: hasSchedule
                                        ? Constants.DEFAULT_COLOR
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          );

          dayCounter++;
        }
      }
      rows.add(TableRow(children: cells));
    }
    return rows;
  }

  String getWeekdayString(int weekday) {
    switch (weekday) {
      case 1:
        return '월';
      case 2:
        return '화';
      case 3:
        return '수';
      case 4:
        return '목';
      case 5:
        return '금';
      case 6:
        return '토';
      case 7:
        return '일';
      default:
        return '';
    }
  }
}

class DayOfWeek extends StatelessWidget {
  final String str;
  const DayOfWeek({super.key, required this.str});

  @override
  Widget build(BuildContext context) {
    return Text(
      str,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class Util {
  int calculateWeeksInMonth(DateTime dateTime) {
    int firstDayOfMonth = DateTime(dateTime.year, dateTime.month, 1).weekday;
    int daysInMonth = DateTime(dateTime.year, dateTime.month + 1, 0).day;
    int remainingDays = daysInMonth - (7 - firstDayOfMonth + 1);
    int weeksInMonth = 1 + (remainingDays / 7).ceil();
    return weeksInMonth;
  }

  String getDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
  }
}
