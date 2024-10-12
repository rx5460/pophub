import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';

class WaitingInfo extends StatefulWidget {
  const WaitingInfo({super.key});

  @override
  State<WaitingInfo> createState() => _WaitingInfoState();
}

class _WaitingInfoState extends State<WaitingInfo> {
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
        title: Text(
          ('make_a_reservation').tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
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
            padding: EdgeInsets.only(top: screenHeight * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.05,
                    right: screenWidth * 0.05,
                  ),
                  child: Row(
                    children: [
                      Text(
                        ('seoul_life_popup_store').tr(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 24,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.05,
                    right: screenWidth * 0.05,
                  ),
                  child: Text(
                    ('display').tr(),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Constants.DARK_GREY),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.04),
                  child: Container(
                    height: 2,
                    width: screenWidth,
                    color: Constants.DEFAULT_COLOR,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.03,
                      // bottom: screenHeight * 0.03,
                      left: screenWidth * 0.05,
                      right: screenWidth * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ('my_order').tr(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "18",
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.w900),
                            ),
                            Text(
                              ('th').tr(),
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            ('waiting_number').tr(),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            ('number_18').tr(),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        ('var_20240730_1721_registered').tr(),
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Constants.DARK_GREY),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.03),
                  child: Container(
                    height: 2,
                    width: screenWidth,
                    color: Constants.DEFAULT_COLOR,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.03,
                      left: screenWidth * 0.05,
                      right: screenWidth * 0.05),
                  child: Text(
                    ('properties').tr(),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.03,
                      bottom: screenHeight * 0.03,
                      left: screenWidth * 0.05,
                      right: screenWidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ('total_number_of_attendees').tr(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        ('var_2_people').tr(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                bottom: screenHeight * 0.04),
            child: SizedBox(
              width: screenWidth * 0.9,
              height: screenHeight * 0.07,
              child: OutlinedButton(
                  onPressed: () {},
                  child: Text(
                    ('close').tr(),
                    style: const TextStyle(fontSize: 18),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
