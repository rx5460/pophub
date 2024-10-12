import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/nav/bottom_navigation.dart';
import 'package:pophub/utils/api/user_api.dart';
import 'package:pophub/utils/http.dart';
import 'package:pophub/utils/utils.dart';

class WithdrawalPage extends StatefulWidget {
  const WithdrawalPage({super.key});

  @override
  _WithdrawalPageState createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {
  Future<void> resetPasswdApi() async {
    final data = await UserApi.postUserDelete();
    if (!data.toString().contains("fail")) {
      await secureStorage.deleteAll();
      User().clear();
      if (mounted) {
        showAlert(context, ('success').tr(),
            ('you_have_successfully_withdrawn_your_membership').tr(), () {
          // 여기서 실제 회원탈퇴 로직을 구현

          Navigator.of(context).pop();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const BottomNavigationPage()));
        });
      }
    } else {
      if (mounted) {
        showAlert(context, ('failure').tr(),
            ('membership_withdrawal_failed').tr(), () {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
      appBar: CustomTitleBar(titleName: ('titleName_11').tr()),
      body: Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              top: screenHeight * 0.05,
              bottom: screenHeight * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                ('privacy_policy').tr(),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                ('when_you_cancel_your_membership_your_personal_information_will_be_processed_as_follows')
                    .tr(),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                ('_retention_period_your_personal_information_is_retained_for_1_month_from_the_date_of_withdrawal_applicationn')
                    .tr(),
              ),
              const SizedBox(height: 8),
              Text(
                  ('_purpose_we_retain_your_personal_information_for_this_period_to_fulfill_our_legal_obligationsn')
                      .tr()),
              const SizedBox(height: 8),
              Text(
                ('_deletion_when_the_retention_period_expires_your_personal_information_is_securely_deleted')
                    .tr(),
              ),
              const SizedBox(height: 16),
              Text(
                ('note').tr(),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(('_if_you_withdraw_your_points_will_be_lostn').tr()),
              const Spacer(),
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    // 회원탈퇴 처리 로직
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(('titleName_11').tr()),
                          content: Text(
                              ('do_you_really_want_to_cancel_your_membership')
                                  .tr()),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(('cancellation').tr()),
                            ),
                            TextButton(
                              onPressed: () {
                                resetPasswdApi();
                              },
                              child: Text(('unsubscribe').tr()),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(('unsubscribe').tr(),
                      style: const TextStyle(
                        fontSize: 18,
                      )),
                ),
              ),
            ],
          )),
    );
  }
}
