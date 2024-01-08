import 'package:brain_training_app/admin/patients/domain/entity/inspirational_mssg.dart';
import 'package:brain_training_app/admin/patients/ui/view_model/patient_vmodel.dart';
import 'package:brain_training_app/admin/patients/ui/widget/inspirational_mssg_card.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class PatientInspirationalMessagePage extends StatefulWidget {
  AppUser patient;
  PatientInspirationalMessagePage({super.key, required this.patient});

  @override
  State<PatientInspirationalMessagePage> createState() =>
      _PatientInspirationalMessagePageState();
}

class _PatientInspirationalMessagePageState
    extends State<PatientInspirationalMessagePage> {
  late ManagePatientViewModel managePatientViewModel;
  List<InspirationalMessage> mssgList = [];

  @override
  void initState() {
    managePatientViewModel = Get.find<ManagePatientViewModel>();
    callDataInit();
    super.initState();
  }

  void callDataInit() async {
    mssgList = await managePatientViewModel
        .getInspirationalMessagesByUser(widget.patient.uid!);
    print(mssgList.length);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFE0B2), // Light warm yellow
                    Color(0xFFFFCC80), // Slightly deeper warm yellow
                  ],
                ),
              ),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back_ios, color: Colors.black),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return InspirationalMessageCard(
                            message: mssgList[index]);
                      },
                      childCount: mssgList.length,
                    ),
                  ),
                ],
              ))),
    );
  }
}
