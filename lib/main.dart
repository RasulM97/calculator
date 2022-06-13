import 'package:calculator/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:io';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<String> buttons = [
    'AC',
    'CE',
    '%',
    '/',
    '7',
    '8',
    '9',
    '*',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '00',
    '0',
    '.',
    '='
  ];
  String inputUser = '';
  String result = '';

  void buttonPressed(String text) {
    setState(() {
      inputUser += text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Calculate numbers
              Expanded(
                flex: 3,
                child: Container(
                  color: backgroundGreyDark,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // operation numbers
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            inputUser,
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // result operation
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            result,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: textGreen,
                              fontSize: 90,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Number keys
              Expanded(
                flex: 7,
                child: Container(
                  color: backgroundGrey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                        itemCount: buttons.length,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: Platform.isWindows || Platform.isMacOS || Platform.isLinux? 1.3 : 1,
                                mainAxisSpacing: 3,
                                crossAxisSpacing: 3,
                                crossAxisCount: 4),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: isOperator(buttons[index])
                                      ? backgroundGreyDark
                                      : backgroundGrey,
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                        width: 0, color: Colors.transparent),
                                  )),
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                operation(index);
                              },
                              child: Text(
                                buttons[index],
                                style: TextStyle(
                                  color: isOperator(buttons[index])
                                      ? textGreen
                                      : textGrey,
                                  fontSize: 26,
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // for changing colors
  bool isOperator(String text) {
    var list = ['AC', 'CE', '%', '/', '*', '-', '+', '='];
    for (var item in list) {
      if (item == text) {
        return true;
      }
    }
    return false;
  }

  // all condition for result
  void operation(int index) {
    if (buttons[index] == 'CE') {
      setState(() {
        if (inputUser.isNotEmpty) {
          inputUser = inputUser.substring(0, inputUser.length - 1);
        }
      });
    } else if (buttons[index] == '=') {
      Parser parser = Parser();
      Expression expression = parser.parse(inputUser);
      ContextModel contextModel = ContextModel();
      double eval = expression.evaluate(EvaluationType.REAL, contextModel);
      setState(() {
        result = eval.toString();
      });
    } else if (buttons[index] == 'AC') {
      setState(() {
        inputUser = '';
        result = '';
      });
    } else {
      buttonPressed(buttons[index]);
    }
  }
}
