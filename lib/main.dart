import 'package:english_vocabulary_book/screens/screen_login.dart';
import 'package:english_vocabulary_book/screens/screen_splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WordsList(),
      routes: {
        '/main': (context) => WordsList(),
        '/login': (context) => LoginScreen(),
        '/splash': (context) => SplashScreen(),
      },
      initialRoute: '/splash',
    );
  }
}

class WordsList extends StatefulWidget {
  const WordsList({Key? key}) : super(key: key);

  @override
  State<WordsList> createState() => _WordsListState();
}

class _WordsListState extends State<WordsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('English Words Book'),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                  child: Text("로그아웃"),
                  onTap: () {
                    //클릭 했을 때 로그아웃 되게
                  })
            ];
          })
        ],
      ),
    );
  }
}
