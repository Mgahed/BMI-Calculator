import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Result extends StatefulWidget {
  const Result({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Result> createState() => _ResultState();
}

bool isMale = true;
int age = 202;
double height = 1060;
double weight = 705;
var bmi = 0.0;

class _ResultState extends State<Result> {
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isMale = prefs.getBool('isMale') ?? true;
      age = prefs.getInt('age') ?? 22;
      height = prefs.getDouble('height') ?? 160;
      weight = prefs.getDouble('weight') ?? 75;
    });
    bmi = weight / pow(height / 100, 2);
    print("bmi: $bmi, weight: $weight , age: $age, height: $height");
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  String get resultPhrase {
    String text = '';
    if (bmi >= 30) {
      text = 'obese (Fat)';
    } else if (bmi >= 25 && bmi < 30) {
      text = 'overweight';
    } else if (bmi >= 18.5 && bmi < 25) {
      text = 'normal';
    } else {
      text = 'underweight';
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Gender ${isMale ? 'Male' : 'Female'}",
                  style: Theme.of(context).textTheme.headline5),
              Text("Age $age", style: Theme.of(context).textTheme.headline5),
              Text("Result ${bmi.toStringAsFixed(2)}",
                  style: Theme.of(context).textTheme.headline5),
              Text("Healthiness $resultPhrase",
                  style: Theme.of(context).textTheme.headline5),
            ],
          ),
        ),
      ),
    );
  }
}
