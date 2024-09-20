import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
        await http.get(Uri.parse('https://3.88.120.90:3000/pay/search'));

    if (response.statusCode == 200) {
      List<dynamic> paymentData = jsonDecode(response.body);
      setState(() {
        payments = paymentData.map((data) => Payment.fromJson(data)).toList();
      });
    } else {
      throw Exception('결재 내역을 불러오지 못함');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomTitleBar(titleName: "결제 내역"),
      body: payments.isEmpty
          ? const Center(
              child: Text(
                '결제 내역이 없습니다',
                style: TextStyle(
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
