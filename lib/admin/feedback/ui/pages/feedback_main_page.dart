import 'package:brain_training_app/admin/feedback/domain/entity/feedback.dart';
import 'package:brain_training_app/admin/feedback/domain/services/feedback_service.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FeedbackMainPage extends StatefulWidget {
  const FeedbackMainPage({Key? key}) : super(key: key);

  @override
  State<FeedbackMainPage> createState() => _FeedbackMainPageState();
}

class _FeedbackMainPageState extends State<FeedbackMainPage> {
  List<FeedbackData> feedbackList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFeedbackData();
  }

  Future<void> _loadFeedbackData() async {
    try {
      final feedbackData = await FeedbackService.fetchFeedbackData();
      setState(() {
        feedbackList = feedbackData;
      });
      isLoading = false;
    } catch (e) {
      print(e);
    }
  }

  Future<void> _deleteFeedback(String feedbackId) async {
    try {
      // Delete the feedback document from Firestore
      await FeedbackService.deleteFeedback(feedbackId);

      // Remove the deleted feedback from the list
      setState(() {
        feedbackList.removeWhere((feedback) => feedbackId == feedback.id);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Feedback', style: AppTextStyle.h2),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.brandBlue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: feedbackList.isEmpty
          ? displayEmptyDataLoaded("No feedback received yet.",
              showBackArrow: false)
          : ListView.builder(
              itemCount: feedbackList.length,
              itemBuilder: (context, index) {
                final feedback = feedbackList[index];
                final formattedTimestamp = DateFormat('yyyy-MM-dd HH:mm:ss')
                    .format(feedback.timestamp.toDate());

                return ListTile(
                  title: Text(
                    'Message: ${feedback.message}',
                    style: AppTextStyle.h3,
                  ),
                  subtitle: Text(
                    'Created on : $formattedTimestamp',
                    style: AppTextStyle.h4,
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () =>
                        _deleteFeedback(feedback.id), // Call delete function
                  ),
                );
              },
            ),
    );
  }
}
