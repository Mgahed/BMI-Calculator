import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    setData();
  }

  bool isMale = true;
  int age = 22;
  double height = 160;
  double weight = 75;

  setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isMale', isMale);
    prefs.setInt('age', age);
    prefs.setDouble('height', height);
    prefs.setDouble('weight', weight);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildExpanded(context, "male"),
                          const SizedBox(width: 10),
                          buildExpanded(context, "female"),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildExpandedHeight(context),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildExpanded2(context, "weight"),
                          const SizedBox(width: 10),
                          buildExpanded2(context, "age"),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: ElevatedButton(
                      child: const Text("Calculate"),
                      onPressed: () {
                        setData();
                        Navigator.pushNamed(context, '/result');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Expanded buildExpanded(BuildContext context, String gender) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isMale = gender == 'male' ? true : false;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color:
                (isMale && gender == 'male') || (!isMale && gender == 'female')
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.secondaryContainer,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(gender == 'male' ? Icons.male : Icons.female, size: 70),
              const SizedBox(height: 15),
              gender == 'male'
                  ? Text(
                      "Male",
                      style: Theme.of(context).textTheme.headline5,
                    )
                  : Text(
                      "Female",
                      style: Theme.of(context).textTheme.headline5,
                    )
            ],
          ),
        ),
      ),
    );
  }

  Expanded buildExpandedHeight(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            Slider(
                value: height,
                onChanged: (double val) {
                  setState(() {
                    height = val;
                  });
                },
                min: 150,
                max: 200,
                divisions: 100,
                label: "$height"),
            const SizedBox(height: 15),
            Text(
              "$height cm",
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
      ),
    );
  }

  Expanded buildExpanded2(BuildContext context, String text) {
    var myController = TextEditingController();
    myController.text =
        text == 'weight' ? weight.toInt().toString() : age.toString();
    myController.selection = TextSelection.fromPosition(
        TextPosition(offset: myController.text.length));
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            Text(
              text == 'weight' ? "Weight" : "Age",
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: myController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
              onChanged: (value) {
                if (text == 'weight') {
                  setState(() {
                    weight = double.parse(value);
                  });
                } else {
                  setState(() {
                    age = int.parse(value);
                  });
                }
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: text == 'weight' ? "Weight" : "Age",
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton.small(
                    heroTag: "-$text",
                    onPressed: () {
                      if (text == 'weight') {
                        setState(() {
                          weight = weight - 1;
                        });
                      } else {
                        setState(() {
                          age = age - 1;
                        });
                      }
                    },
                    child: const Icon(Icons.remove)),
                FloatingActionButton.small(
                    heroTag: "+$text",
                    onPressed: () {
                      if (text == 'weight') {
                        setState(() {
                          weight = weight + 0.5;
                        });
                      } else {
                        setState(() {
                          age = age + 1;
                        });
                      }
                    },
                    child: const Icon(Icons.add)),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
