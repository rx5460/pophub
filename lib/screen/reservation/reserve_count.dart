import 'package:flutter/material.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/utils/api.dart';

class ReserveCount extends StatefulWidget {
  final String date;
  final String popup;
  final String time;
  const ReserveCount(
      {super.key, required this.date, required this.popup, required this.time});

  @override
  State<ReserveCount> createState() => _ReserveCountState();
}

class _ReserveCountState extends State<ReserveCount> {
  int count = 1;

  Future<void> reservationApi() async {
    Map<String, dynamic> data = await Api.popupReservation(
        User().userName, widget.popup, widget.date, widget.time, count);

    if (mounted) {
      if (!data.toString().contains("fail")) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const ReserveDate()),
        // );

        Navigator.pop(context);
      } else {
        Navigator.of(context).pop();
      }
    }
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
                  '방문할 인원을 ',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  '선택해주세요.',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "인원",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      width: screenWidth * 0.35,
                      height: screenWidth * 0.12,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                count += 1;
                              });
                            },
                            child: const Icon(
                              Icons.add,
                              size: 34,
                            ),
                          ),
                          Text(
                            count.toString(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (count != 0) count -= 1;
                              });
                            },
                            child: const Icon(
                              Icons.remove,
                              size: 34,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: screenWidth * 0.8,
            height: screenHeight * 0.08,
            child: OutlinedButton(
                onPressed: () {
                  reservationApi();
                },
                child: const Text('다음')),
          ),
        ],
      ),
    );
  }
}
