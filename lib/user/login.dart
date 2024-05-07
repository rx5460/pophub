import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(decoration: InputDecoration(hintText: "아이디")),
        TextField(decoration: InputDecoration(hintText: "비밀번호")),
        ElevatedButton(
          onPressed: () => {print("로그인뽈롱")},
          child: Container(
            color: Colors.blue,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () => {print("아이디 찾기로 이동 ! ")},
                child: Text("아이디 찾기")),
            TextButton(
                onPressed: () => {print("비밀번호 찾기로 이동 ! ")},
                child: Text("비밀번호 찾기")),
          ],
        )
      ],
    ));
  }
}
