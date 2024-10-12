import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/notifier/StoreNotifier.dart';

class StoreOperatingHoursModal extends StatefulWidget {
  final StoreModel storeModel;

  const StoreOperatingHoursModal({super.key, required this.storeModel});

  @override
  _StoreOperatingHoursModalState createState() =>
      _StoreOperatingHoursModalState();
}

class _StoreOperatingHoursModalState extends State<StoreOperatingHoursModal> {
  final List<String> daysOfWeek = [
    ('month').tr(),
    ('fury').tr(),
    ('number').tr(),
    ('neck').tr(),
    ('gold').tr(),
    ('saturday_1').tr(),
    ('day').tr()
  ];
  final Map<String, bool> selectedDays = {
    ('month').tr(): false,
    ('fury').tr(): false,
    ('number').tr(): false,
    ('neck').tr(): false,
    ('gold').tr(): false,
    ('saturday_1').tr(): false,
    ('day').tr(): false,
  };
  final Map<String, String> operatingHours = {
    ('month').tr(): '',
    ('fury').tr(): '',
    ('number').tr(): '',
    ('neck').tr(): '',
    ('gold').tr(): '',
    ('saturday_1').tr(): '',
    ('day').tr(): '',
  };
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  @override
  void initState() {
    super.initState();
    final storeModel = widget.storeModel;
    if (storeModel.schedule != null) {
      for (var schedule in storeModel.schedule!) {
        String dayKor = _translateDay(schedule.dayOfWeek);
        if (daysOfWeek.contains(dayKor)) {
          selectedDays[dayKor] = true;
          operatingHours[dayKor] =
              '${schedule.openTime} : ${schedule.closeTime}';
        }
        setState(() {});
      }
    }
  }

  String _translateDay(String day) {
    switch (day) {
      case 'Monday':
      case 'Mon':
        return ('month').tr();
      case 'Tuesday':
      case 'Tue':
        return ('fury').tr();
      case 'Wednesday':
      case 'Wed':
        return ('number').tr();
      case 'Thursday':
      case 'Thu':
        return ('neck').tr();
      case 'Friday':
      case 'Fri':
        return ('gold').tr();
      case 'Saturday':
      case 'Sat':
        return ('saturday_1').tr();
      case 'Sunday':
      case 'Sun':
        return ('day').tr();
      default:
        return '';
    }
  }

  String _reverseTranslateDay(String day) {
    String month = 'month'.tr();
    String fury = 'fury'.tr();
    String number = 'number'.tr();
    String neck = 'neck'.tr();
    String gold = 'gold'.tr();
    String saturday_1 = 'saturday_1'.tr();
    String dayStr = 'day'.tr();

    if (day == month) {
      return 'Monday';
    } else if (day == fury) {
      return 'Tuesday';
    } else if (day == number) {
      return 'Wednesday';
    } else if (day == neck) {
      return 'Thursday';
    } else if (day == gold) {
      return 'Friday';
    } else if (day == saturday_1) {
      return 'Saturday';
    } else if (day == dayStr) {
      return 'Sunday';
    } else {
      return '';
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    await showCupertinoModalPopup(
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
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(('complete').tr()),
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
      final String start = 'start'.tr(args: [
        startTime!.hour.toString().padLeft(2, '0'),
        startTime!.minute.toString().padLeft(2, '0')
      ]);
      final String end = 'start'.tr(args: [
        endTime!.hour.toString().padLeft(2, '0'),
        endTime!.minute.toString().padLeft(2, '0')
      ]);
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
    _updateOperatingHours();
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

  void _selectWeekdays() {
    setState(() {
      bool allSelected = [
        ('month').tr(),
        ('fury').tr(),
        ('number').tr(),
        ('neck').tr(),
        ('gold').tr()
      ].every((day) => selectedDays[day]!);
      selectedDays.forEach((day, selected) {
        if ([
          ('month').tr(),
          ('fury').tr(),
          ('number').tr(),
          ('neck').tr(),
          ('gold').tr()
        ].contains(day)) {
          selectedDays[day] = !allSelected;
        }
      });
    });
  }

  void _selectWeekend() {
    setState(() {
      bool allSelected = [('saturday_1').tr(), ('day').tr()]
          .every((day) => selectedDays[day]!);
      selectedDays.forEach((day, selected) {
        if ([('saturday_1').tr(), ('day').tr()].contains(day)) {
          selectedDays[day] = !allSelected;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ('operating_days').tr(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
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
                        side: const BorderSide(
                          color: Constants.DEFAULT_COLOR,
                          width: 1.0,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedDays[day] = !selectedDays[day]!;
                        });
                      },
                      child: Text(
                        day,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: screenWidth * 0.2,
                  height: screenHeight * 0.05,
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: Constants.DEFAULT_COLOR,
                        width: 1.0,
                      ),
                    ),
                    onPressed: _selectWeekdays,
                    child: Text(
                      ('weekdays').tr(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  width: screenWidth * 0.2,
                  height: screenHeight * 0.05,
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: Constants.DEFAULT_COLOR,
                        width: 1.0,
                      ),
                    ),
                    onPressed: _selectWeekend,
                    child: Text(
                      ('weekend').tr(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              ('operating_hours').tr(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              width: screenWidth,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _selectTime(context, true),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Constants.LIGHT_GREY),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12), // 패딩 설정
                      ),
                      child: Text(startTime == null
                          ? ('start_time').tr()
                          : '${startTime!.hour.toString().padLeft(2, '0')}시 ${startTime!.minute.toString().padLeft(2, '0')}분'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text('~'),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _selectTime(context, false),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Constants.LIGHT_GREY),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      child: Text(endTime == null
                          ? ('end_time').tr()
                          : '${endTime!.hour.toString().padLeft(2, '0')}시 ${endTime!.minute.toString().padLeft(2, '0')}분'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                SizedBox(
                  width: screenWidth * 0.35,
                  child: OutlinedButton(
                    onPressed: _complete,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                    ),
                    child: Text(('complete').tr()),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.01,
                ),
                SizedBox(
                  width: screenWidth * 0.35,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Constants.LIGHT_GREY),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                    ),
                    child: Text(
                      ('close').tr(),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
