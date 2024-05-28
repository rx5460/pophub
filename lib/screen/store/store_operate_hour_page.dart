import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/notifier/StoreNotifier.dart';
import 'dart:io';

class StoreOperatingHoursPage extends StatefulWidget {
  final StoreModel storeModel;

  StoreOperatingHoursPage({required this.storeModel});

  @override
  _StoreOperatingHoursPageState createState() =>
      _StoreOperatingHoursPageState();
}

class _StoreOperatingHoursPageState extends State<StoreOperatingHoursPage> {
  final List<String> daysOfWeek = ['월', '화', '수', '목', '금', '토', '일'];
  final Map<String, bool> selectedDays = {
    '월': false,
    '화': false,
    '수': false,
    '목': false,
    '금': false,
    '토': false,
    '일': false,
  };
  final Map<String, String> operatingHours = {
    '월': '',
    '화': '',
    '수': '',
    '목': '',
    '금': '',
    '토': '',
    '일': '',
  };
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  @override
  void initState() {
    super.initState();
    final storeModel = widget.storeModel;
    for (var schedule in storeModel.schedule) {
      String dayKor = _translateDay(schedule.dayOfWeek);
      if (daysOfWeek.contains(dayKor)) {
        selectedDays[dayKor] = true;
        operatingHours[dayKor] = '${schedule.openTime} : ${schedule.closeTime}';
      }
    }
  }

  String _translateDay(String day) {
    switch (day) {
      case 'Monday':
        return '월';
      case 'Tuesday':
        return '화';
      case 'Wednesday':
        return '수';
      case 'Thursday':
        return '목';
      case 'Friday':
        return '금';
      case 'Saturday':
        return '토';
      case 'Sunday':
        return '일';
      default:
        return '';
    }
  }

  String _reverseTranslateDay(String day) {
    switch (day) {
      case '월':
        return 'Monday';
      case '화':
        return 'Tuesday';
      case '수':
        return 'Wednesday';
      case '목':
        return 'Thursday';
      case '금':
        return 'Friday';
      case '토':
        return 'Saturday';
      case '일':
        return 'Sunday';
      default:
        return '';
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 350,
          color: Constants.LIGHT_GREY,
          child: Column(
            children: [
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    isStartTime ? (startTime?.hour ?? 0) : (endTime?.hour ?? 0),
                    isStartTime
                        ? (startTime?.minute ?? 0)
                        : (endTime?.minute ?? 0),
                  ),
                  onDateTimeChanged: (DateTime date) {
                    setState(() {
                      if (isStartTime) {
                        startTime =
                            TimeOfDay(hour: date.hour, minute: date.minute);
                      } else {
                        endTime =
                            TimeOfDay(hour: date.hour, minute: date.minute);
                      }
                    });
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: CupertinoButton.filled(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('완료'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateOperatingHours() {
    if (startTime != null && endTime != null) {
      final String start =
          '${startTime!.hour.toString().padLeft(2, '0')}시 ${startTime!.minute.toString().padLeft(2, '0')}분';
      final String end =
          '${endTime!.hour.toString().padLeft(2, '0')}시 ${endTime!.minute.toString().padLeft(2, '0')}분';
      if (mounted) {
        setState(() {
          selectedDays.forEach((day, selected) {
            if (selected) {
              operatingHours[day] = '$start : $end';
            }
          });
        });
      }
    }
  }

  void _complete() {
    final storeModel = widget.storeModel;
    storeModel.removeSchedule();
    operatingHours.forEach((day, hours) {
      if (hours.isNotEmpty) {
        List<String> times = hours.split(' : ');
        storeModel.updateSchedule(
          _reverseTranslateDay(day),
          times[0],
          times[1],
        );
      }
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('운영 시간'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '운영일',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: daysOfWeek.map((day) {
                  return Container(
                    width: screenWidth * 0.13,
                    height: screenHeight * 0.05,
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                            selectedDays[day]! ? Colors.white : Colors.black,
                        backgroundColor: selectedDays[day]!
                            ? Constants.DEFAULT_COLOR
                            : Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedDays[day] = !selectedDays[day]!;
                        });
                      },
                      child: Text(
                        day,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              '운영 시간',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () => _selectTime(context, true),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Constants.LIGHT_GREY),
                    minimumSize: Size(100, 50), // 최소 크기 설정
                    padding: EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12), // 패딩 설정
                  ),
                  child: Text(startTime == null
                      ? '시작 시간'
                      : '${startTime!.hour.toString().padLeft(2, '0')}시 ${startTime!.minute.toString().padLeft(2, '0')}분'),
                ),
                SizedBox(width: 10),
                Text(':'),
                SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () => _selectTime(context, false),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Constants.LIGHT_GREY),
                    minimumSize: Size(100, 50),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: Text(endTime == null
                      ? '종료 시간'
                      : '${endTime!.hour.toString().padLeft(2, '0')}시 ${endTime!.minute.toString().padLeft(2, '0')}분'),
                ),
                SizedBox(width: 10),
                OutlinedButton(
                  onPressed: _updateOperatingHours,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Constants.LIGHT_GREY),
                    minimumSize: Size(100, 50),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: Text('설정'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: daysOfWeek.map((day) {
                  return ListTile(
                    title: Text('$day요일'),
                    trailing: Text(operatingHours[day]!),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _complete,
                child: Text('완료'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.lightBlue,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
