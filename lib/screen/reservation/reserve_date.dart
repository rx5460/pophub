import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pophub/screen/reservation/reserve_count.dart';
import 'package:pophub/utils/api.dart';

class ReserveDate extends StatefulWidget {
  final String popup;
  const ReserveDate({super.key, required this.popup});

  @override
  State<ReserveDate> createState() => _ReserveDateState();
}

class _ReserveDateState extends State<ReserveDate> {
  DateTime selectedDate = DateTime.now();
  int selectedHour = TimeOfDay.now().hour;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> getReserveStatus() async {
    try {
      dynamic data = await Api.getReserveStatus(widget.popup);
      print(widget.popup);
      print(data);
    } catch (error) {
      // 오류 처리
      print('Error fetching popup data: $error');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReserveStatus();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    List<DropdownMenuItem<int>> hourItems = List.generate(24, (index) {
      return DropdownMenuItem(
        value: index,
        child: Text(index.toString().padLeft(2, '0')),
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('예약하기'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                top: screenHeight * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '예약 날짜 및 시간을  ',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  '설정해 주세요.',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                GestureDetector(
                  onTap: () async {
                    _selectDate(context);
                  },
                  child: Container(
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.05,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DateFormat("yyyy.MM.dd").format(selectedDate)),
                          const Icon(
                            Icons.keyboard_arrow_down_outlined,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<int>(
                    value: selectedHour,
                    items: hourItems,
                    onChanged: (value) {
                      setState(() {
                        selectedHour = value!;
                      });
                    },
                    underline: Container(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: screenWidth * 0.8,
            height: screenHeight * 0.08,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReserveCount(
                            date: DateFormat("yyyy.MM.dd").format(selectedDate),
                            popup: widget.popup,
                            time:
                                "${selectedHour.toString().padLeft(2, '0')}:00",
                          )),
                );
              },
              child: const Text('다음'),
            ),
          ),
        ],
      ),
    );
  }
}
