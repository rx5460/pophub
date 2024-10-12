import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pophub/model/pay_model.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({super.key});

  @override
  PaymentHistoryPageState createState() => PaymentHistoryPageState();
}

class PaymentHistoryPageState extends State<PaymentHistoryPage> {
  List<Payment> payments = [];

  @override
  void initState() {
    super.initState();
    fetchPayments();
  }

  Future<void> fetchPayments() async {
    final response =
        await http.get(Uri.parse('http://3.233.20.5:3000/pay/search'));

    if (response.statusCode == 200) {
      List<dynamic> paymentData = jsonDecode(response.body);
      setState(() {
        payments = paymentData.map((data) => Payment.fromJson(data)).toList();
      });
    } else {
      throw Exception(('unable_to_load_payment_details').tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTitleBar(titleName: ('text_9').tr()),
      body: payments.isEmpty
          ? Center(
              child: Text(
                ('there_is_no_payment_history').tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.builder(
              itemCount: payments.length,
              itemBuilder: (context, index) {
                final payment = payments[index];
                return ListTile(
                  title: Text(payment.description),
                  subtitle: Text(payment.date),
                  trailing: Text(payment.amount),
                );
              },
            ),
    );
  }
}
