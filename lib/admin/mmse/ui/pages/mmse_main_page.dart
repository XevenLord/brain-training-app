import 'package:brain_training_app/admin/home/ui/view_model/home_vmodel.dart';
import 'package:brain_training_app/admin/mmse/domain/entity/patient_response.dart';
import 'package:brain_training_app/admin/mmse/ui/view_model/mmse_vmodel.dart';
import 'package:brain_training_app/common/domain/service/user_repo.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MMSEMainPage extends StatefulWidget {
  const MMSEMainPage({Key? key}) : super(key: key);

  @override
  State<MMSEMainPage> createState() => _MMSEMainPageState();
}

class _MMSEMainPageState extends State<MMSEMainPage> {
  late MMSEViewModel mmseViewModel;
  late AdminHomeViewModel adminHomeViewModel;
  List<AppUser> patients = [];
  List<PatientResponse> patientResponses = [];
  bool isLoading = true;

  @override
  void initState() {
    adminHomeViewModel = Get.find<AdminHomeViewModel>();
    mmseViewModel = Get.find<MMSEViewModel>();
    setState(() {
      patients = UserRepository.patients;
    });
    _loadPatientResponses();
    super.initState();
  }

  void _loadPatientResponses() async {
    patientResponses = await mmseViewModel.loadPatientResponses();
    setState(() {});
    setPatientNames();
    isLoading = false;
  }

  void setPatientNames() {
    if (patients.isNotEmpty) {
      patientResponses = patientResponses.map((e) {
        e.patientName =
            patients.firstWhere((element) => element.uid == e.patientId).name!;
        return e; // Return the updated response.
      }).toList(); // Convert the result into a list.

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupedResponses = <String, List<PatientResponse>>{};

    for (final response in patientResponses) {
      if (!groupedResponses.containsKey(response.patientId)) {
        groupedResponses[response.patientId] = [];
      }
      groupedResponses[response.patientId]!.add(response);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.brandBlue,
        title: Text('MMSE', style: AppTextStyle.h2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : patientResponses.isEmpty
                ? displayEmptyDataLoaded("No MMSE response.",
                    showBackArrow: false)
                : ListView.builder(
                    itemCount: groupedResponses.length,
                    itemBuilder: (context, index) {
                      final patientId = groupedResponses.keys.elementAt(index);
                      final patientResponsesGroup =
                          groupedResponses[patientId]!;
                      final formattedTimestamp =
                          DateFormat('yyyy-MM-dd HH:mm:ss')
                              .format(patientResponsesGroup[0].timestamp);

                      return ExpansionTile(
                        title: Text(patientResponsesGroup[0].patientName,
                            style: AppTextStyle.h2
                                .merge(const TextStyle(fontSize: 16))),
                        children: patientResponsesGroup.map((e) {
                          return ListTile(
                            title: Text('Score: ${e.score.toString()}/30',
                                style: AppTextStyle.h3),
                            subtitle: Text('Completed at: $formattedTimestamp',
                                style: AppTextStyle
                                    .c2), // Display formatted timestamp.
                            // Add more information as needed.
                          );
                        }).toList(),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.brandBlue,
        onPressed: () async {
          // Show a dialog or use another method to allow the user to select a patient.
          final selectedPatient = await showDialog<AppUser?>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Select a Patient', style: AppTextStyle.h3),
                content: DropdownButton<AppUser>(
                  items: patients.map((patient) {
                    return DropdownMenuItem<AppUser>(
                      value: patient,
                      child: Text(patient.name!, style: AppTextStyle.h3),
                    );
                  }).toList(),
                  onChanged: (value) {
                    Navigator.of(context).pop(
                        value); // Close the dialog and return the selected patient
                  },
                ),
              );
            },
          );

          // If a patient was selected, navigate to the questionnaire page with the selected patient.
          if (selectedPatient != null) {
            Get.toNamed(RouteHelper.getMmseQuestionnaire(),
                arguments: selectedPatient);
          }
        },
        child: const Icon(Icons.file_open_rounded),
      ),
    );
  }
}
