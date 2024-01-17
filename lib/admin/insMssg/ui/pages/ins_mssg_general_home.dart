import 'package:brain_training_app/admin/insMssg/ui/view_model/ins_mssg_vmodel.dart';
import 'package:brain_training_app/admin/patients/domain/entity/inspirational_mssg.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class InspirationalMssgGeneralHome extends StatefulWidget {
  const InspirationalMssgGeneralHome({super.key});

  @override
  State<InspirationalMssgGeneralHome> createState() =>
      _InspirationalMssgGeneralHomeState();
}

class _InspirationalMssgGeneralHomeState
    extends State<InspirationalMssgGeneralHome> {
  List<InspirationalMessage> messages = [];
  late InspirationalMssgViewModel inspirationalMssgViewModel;
  TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    inspirationalMssgViewModel = Get.find<InspirationalMssgViewModel>();
    callDataInit();
    super.initState();
  }

  void callDataInit() async {
    await inspirationalMssgViewModel.getGeneralInspirationalMessages();
    messages = inspirationalMssgViewModel.insMssgs;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.brandBlue,
        elevation: 0,
        title: Text(
          "Inspirational Messages",
          style: AppTextStyle.h2,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.only(bottom: 4.w),
              title: Text(messages[index].getMessage ?? '',
                  style: AppTextStyle.h4),
              trailing: IconButton(
                icon: Icon(Icons.delete, size: 25.w),
                onPressed: () {
                  deleteMessage(index);
                  setState(() {});
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.brandBlue,
        onPressed: () {
          _addMessage();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void addMssg() async {
    if (_textFieldController.text.trim().isEmpty) return;
    InspirationalMessage inspirationalMessage = InspirationalMessage(
        message: _textFieldController.text, createdAt: DateTime.now());
    _textFieldController.clear();
    // messages.add(inspirationalMessage);
    await inspirationalMssgViewModel
        .addInspirationalMessage(inspirationalMessage);
    Get.back();
    setState(() {});
  }

  _addMessage() {
    // Push a new message to the messages list.
    setState(() {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Add Message', style: AppTextStyle.h2),
                content: TextField(
                  controller: _textFieldController,
                  onChanged: (value) {},
                ),
                actions: [TextButton(onPressed: addMssg, child: Text('Add'))],
              ));
    });
  }

  void deleteMessage(int index) async {
    // Remove the me  ssage when the delete button is pressed.
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Delete Message', style: AppTextStyle.h2),
              content: Text(
                  'Are you sure you want to delete this "${messages[index].getMessage}" message?',
                  style: AppTextStyle.h3),
              actions: [
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('Cancel', style: AppTextStyle.h3)),
                TextButton(
                    onPressed: () async {
                      await inspirationalMssgViewModel
                          .deleteInspirationalMessage(messages[index]);
                      messages.removeAt(index);
                      setState(() {});
                      Get.back();
                    },
                    child: Text('Delete', style: AppTextStyle.h3))
              ],
            ));
  }
}
