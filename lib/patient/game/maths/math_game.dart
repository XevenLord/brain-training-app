import 'dart:math';

import 'package:brain_training_app/patient/game/maths/math_vmodel.dart';
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
  late MathGameViewModel mathModel = Get.find<MathGameViewModel>();
  int questionsAnswered = 1;
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
    numberA = randomNumber.nextInt(level) + increment();
    numberB = randomNumber.nextInt(level) + increment();

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
      numberA = randomNumber.nextInt(level) + increment();
      numberB = randomNumber.nextInt(10) + 1;
    } else if (operator == '/') {
      // Ensure numberA is divisible by numberB for division
      numberB = randomNumber.nextInt(10) + 1;
      numberA = numberB * (randomNumber.nextInt(level) + increment());
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
    if (widget.level == Level.Easy) {
      level = 11;
    } else if (widget.level == Level.Medium) {
      level = 50;
    } else if (widget.level == Level.Hard) {
      level = 151;
    }
    setState(() {});
  }

  int increment() {
    if (widget.level == Level.Easy) {
      return 0;
    } else if (widget.level == Level.Medium) {
      return 11;
    } else if (widget.level == Level.Hard) {
      return 50;
    } else {
      return 0;
    }
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
      } else if (userAnswer.length < 5) {
        // maximum of 5 numbers can be inputted
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
          submitCorrectAnswer(questionText, result.toString(), userAnswer);
          return ResultMessage(
            message: 'It Is Correct!',
            onTap: goToNextQuestion,
            icon: questionsAnswered >= 10 ? Icons.home : Icons.arrow_forward,
          );
        },
      );
    } else {
      if (userAnswer.isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            submitWrongAnswer(questionText, result.toString(), userAnswer);
            return ResultMessage(
              message: 'Sorry, It Is Wrong! Correct Answer Is $result',
              onTap: goToNextQuestion,
              icon: Icons.arrow_forward,
            );
          },
        );
      }
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
    questionsAnswered++;

    if (questionsAnswered >= 10) {
      Get.back();
      return;
    }

    // create a new question
    operator = getRandomOperator();
    numberA = randomNumber.nextInt(level) + increment();
    numberB = randomNumber.nextInt(level) + increment();

    if (operator == '-') {
      // Ensure numberA is greater than numberB for subtraction
      if (numberA < numberB) {
        final temp = numberA;
        numberA = numberB;
        numberB = temp;
      }
    } else if (operator == '*') {
      // Limit the multiplication result to a reasonable range
      numberA = randomNumber.nextInt(level) + increment();
      numberB = randomNumber.nextInt(10) + 1;
    } else if (operator == '/') {
      // Ensure numberA is divisible by numberB for division
      numberB = randomNumber.nextInt(10) + 1;
      numberA = numberB * (randomNumber.nextInt(level) + increment());
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

  void submitCorrectAnswer(
      String questionText, String correctAns, String userAnswer) async {
    Map<String, dynamic> ansMap = {
      "question": questionText,
      "correctAns": correctAns,
      "userAnswer": userAnswer,
      "isUserCorrect": true,
      "level": widget.level.toString().split('.').last,
    };

    mathModel.setMathResult(ansMap);
    await mathModel.submitMathQuestAnswer();
  }

  void submitWrongAnswer(
      String questionText, String correctAns, String userAnswer) async {
    Map<String, dynamic> ansMap = {
      "question": questionText,
      "correctAns": correctAns,
      "userAnswer": userAnswer,
      "isUserCorrect": false,
      "level": widget.level.toString().split('.').last,
    };

    mathModel.setMathResult(ansMap);
    await mathModel.submitMathQuestAnswer();
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

            SizedBox(height: 20.w),
            // level progress
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 10; i++)
                  Icon(
                    questionsAnswered > i
                        ? Icons.circle
                        : Icons.circle_outlined,
                    color: Colors.white,
                  ),
              ],
            ),
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
                      SizedBox(width: 10.w),
                      // answer box
                      Container(
                        height: 50,
                        width: 120,
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
