import 'package:flutter/material.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/user/login.dart';

class WithdrawalPage extends StatelessWidget {
  const WithdrawalPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
      appBar: const CustomTitleBar(titleName: "회원 탈퇴"),
      body: Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              top: screenHeight * 0.05,
              bottom: screenHeight * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                '개인정보 처리 방침',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '회원 탈퇴 시 개인정보는 다음과 같이 처리됩니다.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                '• 보유 기간: 탈퇴 신청일로부터 1개월 동안 회원님의 개인정보를 보유합니다.\n'
                '• 목적: 이 기간 동안 법적 의무 이행을 위해 개인정보를 보유합니다.\n'
                '• 삭제: 보유 기간이 만료되면 회원님의 개인정보는 안전하게 삭제됩니다.',
              ),
              const SizedBox(height: 16),
              const Text(
                '유의 사항',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('• 탈퇴하면 보유 포인트는 사라지게 됩니다.\n'),
              const Spacer(),
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    // 회원 탈퇴 처리 로직
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('회원 탈퇴'),
                          content: const Text('정말로 회원 탈퇴를 하시겠습니까?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('취소'),
                            ),
                            TextButton(
                              onPressed: () {
                                // 여기서 실제 회원 탈퇴 로직을 구현
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('회원 탈퇴가 완료되었습니다.'),
                                  ),
                                );
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login()));
                              },
                              child: const Text('탈퇴하기'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('탈퇴 하기',
                      style: TextStyle(
                        fontSize: 18,
                      )),
                ),
              ),
            ],
          )),
    );
  }
}
