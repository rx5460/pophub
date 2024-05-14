import 'package:flutter/material.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/screen/user/acount_info.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          const Icon(Icons.settings_outlined),
          SizedBox(
            width: screenWidth * 0.05,
          )
        ],
        backgroundColor: const Color(0xFFADD8E6),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: screenWidth,
                height: screenHeight * 0.2,
                decoration: const BoxDecoration(
                  color: Color(0xFFADD8E6),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Transform.translate(
            offset: Offset(0, screenHeight * 0.025),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  width: screenWidth,
                  height: screenHeight * 1,
                  child: Center(
                      child: Container(
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.65,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.5,
                        color: Colors.grey,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AcountInfo()),
                              );
                            },
                            child: SizedBox(
                              width: screenWidth * 0.3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 20),
                                  Text(
                                    // 닉네임으로 수정
                                    User().userId,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.03),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: (screenWidth * 0.3) - 2,
                                  child: const Column(
                                    children: [
                                      Text(
                                        '3000',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '포인트',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: screenWidth * 0.15,
                                  width: 1,
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  width: (screenWidth * 0.3) - 2,
                                  child: const Column(
                                    children: [
                                      Text(
                                        '10',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '방문',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: screenWidth * 0.15,
                                  width: 1,
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  width: (screenWidth * 0.3) - 2,
                                  child: const Column(
                                    children: [
                                      Text(
                                        '10',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '리뷰',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          MenuList(
                            icon: Icons.message_outlined,
                            text: '공지사항',
                            onClick: () {},
                          ),
                          MenuList(
                            icon: Icons.message_outlined,
                            text: '문의내역',
                            onClick: () {},
                          ),
                          MenuList(
                            icon: Icons.message_outlined,
                            text: '업적',
                            onClick: () {},
                          ),
                          MenuList(
                            icon: Icons.message_outlined,
                            text: '결제 내역',
                            onClick: () {},
                          ),
                          MenuList(
                            icon: Icons.message_outlined,
                            text: '장바구니',
                            onClick: () {},
                          ),
                        ],
                      ),
                    ),
                  )),
                )
              ],
            ),
          ),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              SizedBox(
                width: screenWidth,
                child: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/Untitled.png'),
                  radius: 50,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class MenuList extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function() onClick;
  const MenuList({
    super.key,
    required this.icon,
    required this.text,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Padding(
      padding: EdgeInsets.only(
          left: screenWidth * 0.05,
          right: screenWidth * 0.05,
          top: screenHeight * 0.022,
          bottom: screenHeight * 0.022),
      child: GestureDetector(
        onTap: onClick,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
