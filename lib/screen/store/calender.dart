import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';

class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  late DateTime _currentDate;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _selectedDate = DateTime.now();
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
      body: GestureDetector(
        onTap: () {},
        child: SingleChildScrollView(
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
                        '일정',
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
                        child: const Padding(
                            padding: EdgeInsets.only(left: 16, right: 16),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '팝업스토어',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '2024.05.1512123',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w300),
                                  )
                                ])),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
    bool hasSchedule = false;
    bool hasChecklist = false;

    if (startingWeekday == 7) {
      weeksInMonth -= 1;
    }

    for (int i = 0; i < weeksInMonth; i++) {
      List<Widget> cells = [];
      for (int j = 0; j < 7; j++) {
        if ((i == 0 && j < startingWeekday && startingWeekday != 7) ||
            dayCounter > daysInMonth) {
          cells.add(Container(
            height: 45,
          ));
        } else {
          int currentDayCounter = dayCounter;

          cells.add(
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                setState(() {
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
                    _currentDate.month == DateTime.now().month &&
                            DateTime.now().day == currentDayCounter
                        ? _selectedDate.day == currentDayCounter
                            ? Column(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Constants.DEFAULT_COLOR, // 동그라미 색상
                                    ),
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4.0, bottom: 4),
                                        child: Container(
                                          width: 5,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            color: hasSchedule
                                                ? Colors.green
                                                : null,
                                          ),
                                        ),
                                      ),
                                      hasChecklist
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4.0, bottom: 4),
                                              child: Container(
                                                width: 5,
                                                height: 5,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                  color: Colors.red,
                                                ),
                                              ),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Constants.DEFAULT_COLOR, // 동그라미 색상
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4.0, bottom: 4),
                                        child: Container(
                                          width: 5,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            color: hasSchedule
                                                ? Colors.green
                                                : null,
                                          ),
                                        ),
                                      ),
                                      hasChecklist
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4.0, bottom: 4),
                                              child: Container(
                                                width: 5,
                                                height: 5,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                  color: Colors.red,
                                                ),
                                              ),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                ],
                              )
                        : _selectedDate.day == currentDayCounter
                            ? Column(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Constants.DEFAULT_COLOR, // 동그라미 색상
                                    ),
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4.0, bottom: 4),
                                        child: Container(
                                          width: 5,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            color: hasSchedule
                                                ? Colors.green
                                                : null,
                                          ),
                                        ),
                                      ),
                                      hasChecklist
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4.0, bottom: 4),
                                              child: Container(
                                                width: 5,
                                                height: 5,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                  color: Colors.red,
                                                ),
                                              ),
                                            )
                                          : const SizedBox()
                                    ],
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4.0, bottom: 4),
                                        child: Container(
                                          width: 5,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            color: hasSchedule
                                                ? Colors.green
                                                : null,
                                          ),
                                        ),
                                      ),
                                      hasChecklist
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4.0, bottom: 4),
                                              child: Container(
                                                width: 5,
                                                height: 5,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                  color: Colors.red,
                                                ),
                                              ),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                ],
                              )
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
  const DayOfWeek({
    super.key,
    required this.str,
  });

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
