import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const FlutterApp());
}

class FlutterApp extends StatelessWidget {
  const FlutterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.requestFocus(FocusNode());
        }
      },
      child: const MaterialApp(
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int randomNumber = Random().nextInt(100) + 1;
  final TextEditingController controller = TextEditingController();
  String value = '';
  String cardText = 'Try a number!';
  double fontSize = 0;
  bool enabled = true;
  String hintText = 'Please enter a number';
  String buttonText = 'Guess';
  bool okState = false;

  //action function
  void action(BuildContext context) {
    //print(randomNumber);
    final int? input = int.tryParse(controller.text);
    controller.clear();

    setState(() {
      if (input == null) {
        fontSize = 30;
        value = 'Please enter a number';
      } else {
        fontSize = 30;
        if (input > 100) {
          value = 'Please enter a number between 1 and 100';
        } else if (input < 1) {
          value = 'Please enter a number between 1 and 100';
        } else if (input < randomNumber) {
          value = 'You tried {$input}. Try higher';
        } else if (input > randomNumber) {
          value = 'You tried {$input}. Try lower';
        } else if (input == randomNumber) {
          value = 'You tried $input. You guessed right';

          showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('You guessed right'),
                  content: Text('It was $input'),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.pop(
                            context,
                          );
                          setState(() {
                            randomNumber = Random().nextInt(100) + 1;
                            value = '';
                            fontSize = 0;
                          });
                        },
                        child: const Text('Try again!')),
                    TextButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.pop(
                            context,
                          );

                          setState(() {
                            cardText = 'Game Over';
                            enabled = false;
                            value = '';
                            fontSize = 0;
                            hintText = '';
                            buttonText = 'Reset';
                            okState = true;
                          });
                        },
                        child: const Text('OK')),
                  ],
                );
              });
        } else if (input > 100) {
          value = 'Please enter a number between 1 and 100';
        }
      }
    });
  } //end of action function

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Guess my number'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(20.0),
            child: const Text(
              "I'm thinking of a number between 1 and 100",
              style: TextStyle(
                fontSize: 23,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
            child: const Text(
              "It's your turn to guess my number!",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
              margin: const EdgeInsets.all(16.0),
              child: Text(
                value,
                style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              )),
          Card(
            margin: const EdgeInsets.only(left: 16.0, right: 16.0),
            elevation: 4.0,
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    cardText,
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(17.0),
                  child: TextField(
                    enabled: enabled,
                    keyboardType: TextInputType.number,
                    controller: controller,
                    decoration: InputDecoration(hintText: hintText),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: ElevatedButton(
                        onPressed: () {
                          if (!okState) {
                            action(context);
                          } else {
                            setState(() {
                              okState = false;
                              randomNumber = Random().nextInt(100) + 1;
                              value = '';
                              fontSize = 0;
                              enabled = true;
                              buttonText = 'Guess';
                              cardText = 'Try a number!';
                            });
                          }
                        },
                        child: Text(buttonText))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
