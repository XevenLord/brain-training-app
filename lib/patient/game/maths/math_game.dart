import 'dart:math';

import 'package:brain_training_app/patient/game/maths/util/my_button.dart';
import 'package:brain_training_app/patient/game/maths/util/result_message.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MathGame extends StatefulWidget {
  Level level;
  MathGame({Key? key, required this.level}) : super(key: key);

  @override
  State<MathGame> createState() => _MathGameState();
}

class _MathGameState extends State<MathGame> {
  // number pad list
  List<String> numberPad = [
    '7',
    '8',
    '9',
    'C',
    '4',
    '5',
    '6',
    'DEL',
    '1',
    '2',
    '3',
    '=',
    '0',
  ];

  // number A, number B
  int numberA = 1;
  int numberB = 1;
  int level = 10;
  String operator = "+";

  String questionText = '';

  // user answer
  String userAnswer = '';

  @override
  void initState() {
    super.initState();
    setLevel();
    // Create a new question with a random operator
    operator = getRandomOperator();
    numberA = randomNumber.nextInt(level);
    numberB = randomNumber.nextInt(level);

    // Modify the questionText based on the random operator
    if (operator == '-') {
      // Ensure numberA is greater than numberB for subtraction
      if (numberA < numberB) {
        final temp = numberA;
        numberA = numberB;
        numberB = temp;
      }
    } else if (operator == '*') {
      // Limit the multiplication result to a reasonable range
      numberA = randomNumber.nextInt(level);
      numberB = randomNumber.nextInt(10);
    } else if (operator == '/') {
      // Ensure numberA is divisible by numberB for division
      numberB = randomNumber.nextInt(9) + 1;
      numberA = numberB * (randomNumber.nextInt(level) + 1);
    }

    final operatorStr = operator == '*'
        ? 'x'
        : operator == '/'
            ? '÷'
            : operator;

    // Set the initial questionText
    questionText = '$numberA $operatorStr $numberB =';
    setState(() {});
  }

  void setLevel() {
    print("in set Level");
    if (widget.level == Level.Easy) {
      print(widget.level.toString());
      level = 10;
    } else if (widget.level == Level.Medium) {
      print(widget.level.toString());
      level = 50;
    } else if (widget.level == Level.Hard) {
      print(widget.level.toString());
      level = 100;
    }
    setState(() {});
  }

  // user tapped a button
  void buttonTapped(String button) {
    setState(() {
      if (button == '=') {
        // calculate if user is correct or incorrect
        checkResult();
      } else if (button == 'C') {
        // clear the input
        userAnswer = '';
      } else if (button == 'DEL') {
        // delete the last number
        if (userAnswer.isNotEmpty) {
          userAnswer = userAnswer.substring(0, userAnswer.length - 1);
        }
      } else if (userAnswer.length < 3) {
        // maximum of 3 numbers can be inputted
        userAnswer += button;
      }
    });
  }

  // check if user is correct or not
  void checkResult() {
    int? result;
    // Extract the operator from questionText
    final operatorIndex = questionText.indexOf(RegExp('[+\\-x÷]'));
    if (operatorIndex != -1) {
      final operator = questionText[operatorIndex];

      // Calculate the correct result based on the extracted operator
      switch (operator) {
        case '+':
          result = numberA + numberB;
          break;
        case '-':
          result = numberA - numberB;
          break;
        case 'x':
          result = numberA * numberB;
          break;
        case '÷':
          if (numberB != 0) {
            result = numberA ~/ numberB;
          }
          break;
      }
    }

    if (result != null && int.tryParse(userAnswer) == result) {
      showDialog(
        context: context,
        builder: (context) {
          return ResultMessage(
            message: 'Correct!',
            onTap: goToNextQuestion,
            icon: Icons.arrow_forward,
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return ResultMessage(
            message: 'Sorry, try again',
            onTap: goBackToQuestion,
            icon: Icons.rotate_left,
          );
        },
      );
    }
  }

  // create random numbers
  var randomNumber = Random();

  // create random operator
  String getRandomOperator() {
    final operators = ['+', '-', '*', '/'];
    final random = Random();
    return operators[random.nextInt(operators.length)];
  }

  // GO TO NEXT QUESTION
  void goToNextQuestion() {
    // dismiss alert dialog
    Navigator.of(context).pop();

    // reset values
    setState(() {
      userAnswer = '';
    });

    // create a new question
    operator = getRandomOperator();
    numberA = randomNumber.nextInt(level);
    numberB = randomNumber.nextInt(level);

    if (operator == '-') {
      // Ensure numberA is greater than numberB for subtraction
      if (numberA < numberB) {
        final temp = numberA;
        numberA = numberB;
        numberB = temp;
      }
    } else if (operator == '*') {
      // Limit the multiplication result to a reasonable range
      numberA = randomNumber.nextInt(level);
      numberB = randomNumber.nextInt(10);
    } else if (operator == '/') {
      // Ensure numberA is divisible by numberB for division
      numberB = randomNumber.nextInt(9) + 1;
      numberA = numberB * (randomNumber.nextInt(level) + 1);
    }

    final operatorStr = operator == '*'
        ? 'x'
        : operator == '/'
            ? '÷'
            : operator;

    questionText = '$numberA $operatorStr $numberB =';
    setState(() {});
  }

  // GO BACK TO QUESTION
  void goBackToQuestion() {
    // dismiss alert dialog
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[300],
      body: SafeArea(
        child: Column(
          children: [
            // level progress, player needs 5 correct answers in a row to proceed to next level
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20.w),
            Text("Type The Correct Answer",
                style:
                    AppTextStyle.h1.merge(AppTextStyle.lightPurpleTextStyle)),
            // question
            Expanded(
              child: Container(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // question
                      Text(
                        questionText,
                        style:
                            AppTextStyle.whiteTextStyle.merge(AppTextStyle.h1),
                      ),

                      // answer box
                      Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[400],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            userAnswer,
                            style: AppTextStyle.whiteTextStyle
                                .merge(AppTextStyle.h1),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            // number pad
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: GridView.builder(
                  itemCount: numberPad.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemBuilder: (context, index) {
                    return MyButton(
                      child: numberPad[index],
                      onTap: () => buttonTapped(numberPad[index]),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
