import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
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

  String get suggestionPhrase {
    String text = '';
    var suggestionWeight = (pow(height / 100, 2));
    if (bmi >= 30) {
      text =
          'Try to exercise more to get your weight back between ${(suggestionWeight * 25).toStringAsFixed(1)} and ${(suggestionWeight * 30).toStringAsFixed(1)} kg';
    } else if (bmi >= 25 && bmi < 30) {
      text =
          'Try to exercise more to get your weight back between ${(suggestionWeight * 18).toStringAsFixed(1)} and ${(suggestionWeight * 25).toStringAsFixed(1)} kg';
    } else if (bmi >= 18.5 && bmi < 25) {
      text = 'You have a normal body weight. Good job!';
    } else {
      text =
          'You have a lower than normal body weight. You can eat a bit more to get your weight back between ${(suggestionWeight * 18).toStringAsFixed(1)} and ${(suggestionWeight * 24).toStringAsFixed(1)} kg';
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
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      card(
                        context,
                        "Gender ${isMale ? 'Male' : 'Female'}",
                      ),
                      card(
                        context,
                        "Age $age",
                      ),
                      card(
                        context,
                        "Bmi result ${bmi.toStringAsFixed(2)}",
                      ),
                      buildCircularPercentIndicator(context),
                      card(context, suggestionPhrase, myColor: true),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  CircularPercentIndicator buildCircularPercentIndicator(BuildContext context) {
    return CircularPercentIndicator(
      radius: 70.0,
      lineWidth: 13.0,
      animation: true,
      animationDuration: 1200,
      percent: 0.5,
      center: Transform.rotate(
        angle: bmi < 18.5 || bmi >= 25 ? (90 * pi / 180) * -1 : (90 * pi / 180),
        child: Icon(
          Icons.arrow_upward_sharp,
          size: 50.0,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      footer: Text(
        "Healthiness $resultPhrase",
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
      ),
      circularStrokeCap: CircularStrokeCap.butt,
      progressColor: Colors.green[800],
      backgroundColor: Colors.red.shade600,
    );
  }

  Card card(BuildContext context, String text, {bool myColor = false}) {
    return Card(
      color: myColor
          ? (bmi < 18.5 || bmi >= 25 ? Colors.red.shade600 : Colors.green[800])
          : null,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
          width: double.infinity,
          child: Text(
            text,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.headline6?.fontSize,
              color: myColor
                  ? Colors.white
                  : Theme.of(context).textTheme.headline6?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
