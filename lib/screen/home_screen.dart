import 'package:calculator/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //**
  String userInput = '';
  String result = '0';

  List<String> buttonList = [
    'AC',
    '(',
    ')',
    '/',
    '7',
    '8',
    '9',
    '*',
    '4',
    '5',
    '6',
    '+',
    '1',
    '2',
    '3',
    '-',
    'C',
    '0',
    '.',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    //** media query ->
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: size.height / 2.8,
              child: resultWidget(),
            ),
            Expanded(
              child: buttonWidget(),
            ),
          ],
        ),
      ),
    );
  }

  //?? result widget ->
  Widget resultWidget() {
    return Container(
      color: bgColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //?? for user input ->
          Container(
            padding: const EdgeInsets.all(20.0),
            alignment: Alignment.centerRight,
            child: Text(
              userInput,
              style: const TextStyle(
                fontFamily: 'poppins_bold',
                fontSize: 32.0,
              ),
            ),
          ),

          //?? for result ->
          Container(
            padding: const EdgeInsets.all(10.0),
            alignment: Alignment.centerRight,
            child: Text(
              result,
              style: const TextStyle(
                fontFamily: 'poppins_bold',
                fontSize: 48.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //?? buttonWidget ->
  Widget buttonWidget() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      color: appBarColor,
      child: GridView.builder(
        itemCount: buttonList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemBuilder: (context, index) {
          return button(buttonList[index]);
        },
      ),
    );
  }

  //?? get color ->
  getColor(String text) {
    if (text == '/' ||
        text == '*' ||
        text == '+' ||
        text == '-' ||
        text == 'C' ||
        text == '(' ||
        text == ')') {
      return Colors.deepOrange;
    }
    if (text == '=' || text == 'AC') {
      return Colors.black87;
    }
    return Colors.white;
  }

  //?? get bgColor ->
  getBgColor(String text) {
    if (text == 'AC') {
      return Colors.purple;
    }
    if (text == '=') {
      return Colors.teal;
    }

    return buttonColor;
  }

  //?? button widget ->
  Widget button(String text) {
    return InkWell(
      onTap: () {
        setState(() {
          handleButtonPress(text);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: getBgColor(text),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 1.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: getColor(text),
              fontSize: 30.0,
              fontFamily: 'poppins_medium',
            ),
          ),
        ),
      ),
    );
  }

  //?? handle button press ->
  handleButtonPress(String text) {
    //** for AC ->
    if (text == 'AC') {
      userInput = '';
      result = '0';
      return;
    }

    //** for C ->
    if (text == 'C') {
      if (userInput.isNotEmpty) {
        userInput = userInput.substring(0, userInput.length - 1);
        return;
      } else {
        return null;
      }
    }

    //** for = ->
    if (text == '=') {
      result = calculate();
      userInput = result;
      if (userInput.endsWith('.0')) {
        userInput = userInput.replaceAll('.0', '');
      }
      if (result.endsWith('.0')) {
        result = result.replaceAll('.0', '');
      }

      return;
    }
    userInput = userInput + text;
  }

  //?? calculate  ->
  String calculate() {
    try {
      var expression = Parser().parse(userInput);
      var evaluation = expression.evaluate(EvaluationType.REAL, ContextModel());
      return evaluation.toString();
    } catch (e) {
      return 'Error';
    }
  }
}
