import 'package:brain_training_app/patient/healthCheck/ui/view_model/mental_quiz_vmodel.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class QuestionCard extends StatefulWidget {
  QuestionCard({
    Key? key,
  }) : super(key: key);

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  Map<String, String> emojis = {
    "😡": "Angry",
    "😞": "Bad",
    "😐": "Normal",
    "😊": "Good",
    "😆": "Excited"
  };

  List<String> ansOptions = [
    "Not at all",
    "Several days",
    "More than half the days",
    "Nearly every day"
  ];

  List<String> quests = [
    "How do you feel today",
    "Feeling down, depressed, or hopeless",
    "Little interest or pleasure in doing things",
    "Trouble falling or staying asleep, or sleeping too much",
    "Becoming easily annoyed or irritable",
  ];

  int currentIndex = 0;

  final List<int> _selectedQuests = [
    -1,
    -1,
    -1,
    -1,
    -1,
  ];

  Widget _buildIndicator(int index) {
    return Container(
      height: 3.w,
      width: 50.w,
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        color: currentIndex >= index
            ? Color(0xFF1F2429)
            : Color(0xFF1F2429).withOpacity(0.2),
        borderRadius: BorderRadius.circular(5.r),
      ),
    );
  }

  Widget _questionBuilder() {
    if (currentIndex < 0 || currentIndex > 4) return Container();
    if (currentIndex == 0) {
      return _questionOne();
    } else {
      return _question(currentIndex);
    }
  }

  void submitMentalHealthAnswer(Map<String, String> data) async {
    bool res =
        await Get.find<MentalQuizViewModel>().submitMentalHealthAnswer(data);

    print("upload res: $res");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8),
          child: SingleChildScrollView(
            child: Container(
              width: 400.w,
              padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 20.w),
              decoration: BoxDecoration(
                gradient: AppColors.linearBlue,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children:
                            List.generate(5, (index) => _buildIndicator(index)),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close))
                    ],
                  ),
                  _questionBuilder(),
                  SizedBox(height: 18.w),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    TextButton(
                        onPressed: () {
                          if (currentIndex != 0) {
                            setState(() {
                              currentIndex--;
                            });
                          }
                        },
                        child: Text("Previous",
                            style: AppTextStyle.h3
                                .merge(TextStyle(color: Color(0xFF1F2429))))),
                    ElevatedButton(
                      onPressed: () async {
                        if (currentIndex != 4) {
                          if (_selectedQuests[currentIndex] == -1) {
                            return;
                          }
                          setState(() {
                            currentIndex++;
                          });
                        }

                        if (currentIndex == 4) {
                          dynamic answer = {
                            quests[0]:
                                emojis.values.elementAt(_selectedQuests[0]),
                            quests[1]: ansOptions[_selectedQuests[1]],
                            quests[2]: ansOptions[_selectedQuests[2]],
                            quests[3]: ansOptions[_selectedQuests[3]],
                            quests[4]: ansOptions[_selectedQuests[4]],
                          };
                          submitMentalHealthAnswer(answer);
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Mental Health Check Up",
                                      style: AppTextStyle.h2),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(AppConstant.DONE_CHECK,
                                          width: 100.w),
                                      SizedBox(height: 10.h),
                                      Text(
                                          "Your answer has been submitted successfully, wish you have a good day!",
                                          textAlign: TextAlign.center,
                                          style: AppTextStyle.h4),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("OK"))
                                  ],
                                );
                              });
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFF1F2429)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                      child: Text("Next", style: AppTextStyle.h3),
                    ),
                  ])
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _questionOne() {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(quests[0], style: AppTextStyle.h3),
        SizedBox(height: 10.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            emojis.length,
            (index) => Padding(
              padding: EdgeInsets.only(right: 4.w),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedQuests[currentIndex] = index;
                  });
                },
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: index == _selectedQuests[currentIndex]
                            ? Color(0xFF1F2429)
                            : Color(0xFF2D353C).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(emojis.keys.elementAt(index),
                          style: AppTextStyle.h2.merge(TextStyle(
                              color: index == _selectedQuests[currentIndex]
                                  ? Colors.white
                                  : Color(0xFF1F2429)))),
                    ),
                    Text(emojis.values.elementAt(index),
                        style: AppTextStyle.h3
                            .merge(TextStyle(color: Color(0xFF1F2429)))),
                  ],
                ),
              ),
            ),
          ),
        )
      ]);
    });
  }

  Widget _question(int idx) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(quests[idx], style: AppTextStyle.h3),
            SizedBox(height: 10.w),
            // Use a ConstrainedBox to define height constraints
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: (MediaQuery.of(context).size.height * 0.21),
              ),
              child: ListView.builder(
                itemCount: ansOptions.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedQuests[currentIndex] = index;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.w),
                      margin: EdgeInsets.only(bottom: 3.w),
                      decoration: BoxDecoration(
                        color: index == _selectedQuests[currentIndex]
                            ? Color(0xFF1F2429)
                            : Color(0xFF2D353C).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: index == _selectedQuests[currentIndex]
                              ? Color(0xFF1F2429)
                              : Color(0xFF2D353C).withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        ansOptions[index],
                        style: AppTextStyle.h3.merge(TextStyle(
                          color: index == _selectedQuests[currentIndex]
                              ? Colors.white
                              : Color(0xFF1F2429),
                        )),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
