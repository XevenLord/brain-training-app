import 'package:brain_training_app/admin/home/ui/view_model/home_vmodel.dart';
import 'package:brain_training_app/admin/mmse/ui/view_model/mmse_vmodel.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:brain_training_app/admin/mmse/domain/entity/patient_response.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MMSESpecificPage extends StatefulWidget {
  AppUser patient;
  MMSESpecificPage({Key? key, required this.patient}) : super(key: key);

  @override
  State<MMSESpecificPage> createState() => _MMSESpecificPageState();
}

class _MMSESpecificPageState extends State<MMSESpecificPage> {
  late MMSEViewModel mmseViewModel;
  late AdminHomeViewModel adminHomeViewModel;
  List<AppUser> patients = [];
  bool isLoading = true;

  @override
  void initState() {
    adminHomeViewModel = Get.find<AdminHomeViewModel>();
    mmseViewModel = Get.find<MMSEViewModel>();
    setState(() {
      patients = adminHomeViewModel.patientList;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        child: FutureBuilder<List<PatientResponse>>(
          future: mmseViewModel.loadPatientResponses(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error.toString()}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return displayEmptyDataLoaded("No MMSE response.",
                  showBackArrow: false);
            } else {
              // Filter patient-specific responses
              List<PatientResponse> specificPatientResponses = snapshot.data!
                  .where(
                    (element) => element.patientId == widget.patient.uid,
                  )
                  .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      'Patient: ${widget.patient.name}',
                      style: AppTextStyle.h2,
                    ),
                  ),
                  Expanded(
                    child: specificPatientResponses.isEmpty
                        ? displayEmptyDataLoaded("No MMSE response.",
                            showBackArrow: false)
                        : ListView.builder(
                            itemCount: specificPatientResponses.length,
                            itemBuilder: (context, index) {
                              final response = specificPatientResponses[index];
                              return ListTile(
                                title: Text(
                                    'Score: ${response.score.toString()}/30'),
                                subtitle: Text(
                                    'Completed at: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(response.timestamp)}'),
                                // Add more information from the response as needed
                              );
                            },
                          ),
                  ),
                ],
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.brandBlue,
        onPressed: () {
          Get.toNamed(RouteHelper.getMmseQuestionnaire(),
              arguments: widget.patient);
        },
        child: const Icon(Icons.file_open_rounded),
      ),
    );
  }
}
