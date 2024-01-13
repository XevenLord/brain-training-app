import 'package:brain_training_app/admin/mmse/domain/entity/question.dart';
import 'package:brain_training_app/admin/mmse/ui/view_model/mmse_vmodel.dart';
import 'package:brain_training_app/admin/mmse/ui/widgets/question_widget.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MMSEQuestionnaireScreen extends StatefulWidget {
  AppUser patient;

  MMSEQuestionnaireScreen({super.key, required this.patient});
  @override
  _MMSEQuestionnaireScreenState createState() =>
      _MMSEQuestionnaireScreenState();
}

class _MMSEQuestionnaireScreenState extends State<MMSEQuestionnaireScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late MMSEViewModel _mmseViewModel;
  List<Question> questions = [];

  @override
  void initState() {
    _mmseViewModel = Get.find<MMSEViewModel>();
    _loadQuestions();
    super.initState();
  }

  void _loadQuestions() async {
    questions = await _mmseViewModel.loadQuestions();
    if (questions.isNotEmpty) {
      questions.sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));
    }
    setState(() {});
  }

  void _submitAnswers() async {
    await _mmseViewModel.submitAnswers(questions, widget.patient);
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text("MMSE Questionnaire", style: AppTextStyle.h2),
            content:
                Text("Answers submitted successfully!", style: AppTextStyle.h3),
            actions: [
              TextButton(
                onPressed: () =>
                    Get.back(),
                child: Text(
                  "OK",
                  style: AppTextStyle.h3.merge(AppTextStyle.brandBlueTextStyle),
                ),
              )
            ],
          );
        });
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      appBar: AppBar(
        actions: [
          IconButton(
              icon: const Icon(Icons.info, color: AppColors.brandBlue),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          title: Text("MMSE Questionnaire",
                              style: AppTextStyle.h2),
                          content: RichText(
                            text: TextSpan(
                              style: AppTextStyle.c2.merge(
                                const TextStyle(
                                  height: 1.5,
                                ),
                              ),
                              children: <TextSpan>[
                                const TextSpan(
                                  text:
                                      'The Mini-Mental State Examination (MMSE) is the most widely used screening test of mental function in this age group. This manual describes a standardized version of this test and shows how physicians and other health care professionals can use and interpret it. This manual describes some uses that they may not be aware of previously. ',
                                  style: TextStyle(color: Colors.black87),
                                ),
                                TextSpan(
                                  text: 'Click here',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => launchUrlString(
                                        'https://mmse.neurol.ru/mmse_guideline_general.html'),
                                ),
                                const TextSpan(
                                  text: ' to read more about MMSE.',
                                  style: TextStyle(color: Colors.black87),
                                )
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: Text(
                                "I Understand",
                                style: AppTextStyle.h3
                                    .merge(AppTextStyle.brandBlueTextStyle),
                              ),
                            )
                          ],
                        ));
              }),
        ],
        backgroundColor: AppColors.lightBlue,
        foregroundColor: AppColors.brandBlue,
        elevation: 0,
        title: Text('MMSE Questionnaire', style: AppTextStyle.h2),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 12.w, bottom: 8.w),
              child: RichText(
                text: TextSpan(
                  style: AppTextStyle.c2.merge(AppTextStyle.greyTextStyle),
                  children: [
                    TextSpan(
                      text: "Patient: ",
                      style: AppTextStyle.h3
                          .merge(AppTextStyle.brandBlueTextStyle),
                    ),
                    TextSpan(
                      text: widget.patient.name ?? "unknown",
                      style: AppTextStyle.c1,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return QuestionWidget(question: questions[index]);
              },
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: _submitAnswers,
            child: Text('Submit Answers', style: AppTextStyle.h3),
          ),
        ],
      ),
    );
  }
}
