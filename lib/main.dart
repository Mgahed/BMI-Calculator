import 'package:bmi/pages/home.dart';
import 'package:bmi/pages/result.dart';
import 'package:bmi/theme/my_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Body Mass Index',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: lightTheme,
      ),
      darkTheme: ThemeData(
        colorScheme: darkTheme,
      ),
      initialRoute: '/',
      // home: MyHomePage(),
      routes: {
        '/': (context) => const Home(title: 'Home'),
        '/result': (context) => const Result(title: 'Result'),
      },
    );
  }
}
