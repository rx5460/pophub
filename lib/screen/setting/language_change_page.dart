import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/nav/bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageChangePage extends StatefulWidget {
  const LanguageChangePage({super.key});

  @override
  _LanguageChangePageState createState() => _LanguageChangePageState();
}

class _LanguageChangePageState extends State<LanguageChangePage> {
  Locale _selectedLocale = const Locale('en'); // 기본 언어를 영어로 설정

  final Map<String, Locale> _languageOptions = {
    'English': const Locale('en'),
    '한국어': const Locale('ko'),
    '日本語': const Locale('ja'),
    '中文 (简体)': const Locale('zh', 'Hans'), // 중국어 간체
  };

  @override
  void initState() {
    super.initState();
    _loadSelectedLocale(); // 언어 로드
  }

  Future<void> _loadSelectedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString('selected_language');
    if (languageCode != null) {
      setState(() {
        _selectedLocale = _languageOptions.values.firstWhere(
          (locale) => locale.languageCode == languageCode,
          orElse: () => const Locale('en'), // Default to English if not found
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTitleBar(
        titleName: ('change_lang').tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ('change_lang').tr(),
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<Locale>(
              value: _selectedLocale,
              items: _languageOptions.entries.map((entry) {
                return DropdownMenuItem<Locale>(
                  value: entry.value,
                  child: Text(entry.key),
                );
              }).toList(),
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  setState(() {
                    _selectedLocale = newLocale;
                  });
                  context.setLocale(_selectedLocale);
                  _saveSelectedLocale(newLocale.languageCode);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BottomNavigationPage()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveSelectedLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', languageCode);
  }
}
