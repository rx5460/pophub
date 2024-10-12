import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AlarmAdd extends StatefulWidget {
  const AlarmAdd({Key? key}) : super(key: key);

  @override
  AlarmAddState createState() => AlarmAddState();
}

class AlarmAddState extends State<AlarmAdd> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _selectedCategory = ('_selectedCategory').tr();
  String value = ('value').tr();
  String value_1 = ('value_1').tr();

  Future<void> alarmNotification() async {
    String collection;
    if (_selectedCategory == value) {
      collection = 'orderAlarms';
    } else if (_selectedCategory == value_1) {
      collection = 'waitAlarms';
    } else {
      collection = 'alarms';
    }

    try {
      String formattedTime =
          DateFormat(('mm_month_dd_day_hh_hours_mm_minutes').tr())
              .format(DateTime.now());

      // Firestore에 알림 저장
      await FirebaseFirestore.instance.collection(collection).add({
        'active': true,
        'label': _contentController.text,
        'time': formattedTime,
        'title': _titleController.text,
      });

      _showSuccessDialog(('notification_registration_has_been_completed').tr());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(('failed_to_send_notification_please_try_again').tr())),
      );
    }
  }

  Future<void> _showSuccessDialog(String message) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: const BorderSide(color: Color(0xFFE6A3B3), width: 2),
          ),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(16.0),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ('success').tr(),
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFFE6A3B3),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFFE6A3B3), width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    ('close').tr(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ('alarm').tr(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ('notification_title').tr(),
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: ('hintText_6').tr(),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              ('notification_category').tr(),
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: [
                DropdownMenuItem<String>(
                  value: ('_selectedCategory').tr(),
                  child: Text(('_selectedCategory').tr()),
                ),
                DropdownMenuItem<String>(
                  value: ('value').tr(),
                  child: Text(('value').tr()),
                ),
                DropdownMenuItem<String>(
                  value: ('value_1').tr(),
                  child: Text(('value_1').tr()),
                ),
              ],
              onChanged: (String? value) {
                setState(() {
                  _selectedCategory = value ?? ('_selectedCategory').tr();
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              ('notification_content').tr(),
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: ('hintText_7').tr(),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: alarmNotification,
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFE6A3B3),
                  minimumSize: const Size(double.infinity, 50),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                child: Text(
                  ('complete').tr(),
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
