import 'package:brain_training_app/admin/insMssg/ui/view_model/ins_mssg_vmodel.dart';
import 'package:brain_training_app/admin/patients/domain/entity/inspirational_mssg.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    // TODO: implement initState
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
          title: Text("Inspirational Messages")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(messages[index].getMessage ?? ''),
              subtitle: Text('Sender: ${messages[index].getSender ?? ''}'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Remove the message when the delete button is pressed.
                  setState(() {
                    messages.removeAt(index);
                  });
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add a new message when the add button is pressed.
          _addMessage();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  _addMessage() {
    // Push a new message to the messages list.
    setState(() {
      messages.add(InspirationalMessage(
          message: 'Hello World',
          sender: 'Flutter',
          createdAt: DateTime.now()));
    });
  }
}
