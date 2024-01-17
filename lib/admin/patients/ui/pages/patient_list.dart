import 'package:brain_training_app/admin/appointments/domain/entity/appointment.dart';
import 'package:brain_training_app/admin/appointments/ui/view_model/appointment_vmodel.dart';
import 'package:brain_training_app/admin/patients/ui/view_model/patient_vmodel.dart';
import 'package:brain_training_app/common/domain/service/user_repo.dart';
import 'package:brain_training_app/common/ui/widget/info_card.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PatientList extends StatefulWidget {
  const PatientList({super.key});

  @override
  State<PatientList> createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  late UserRepository userRepo;
  late List<AppUser> allPatients;
  late List<AppUser> patients;
  late List<AppUser> admins;
  late AdminAppointmentViewModel adminAppointmentViewModel;
  late ManagePatientViewModel managePatientViewModel;
  List<AdminAppointment> appointments = [];

  bool isLoading = true;

  List<String> selectedGenders = [];
  List<String> selectedAgeRanges = [];
  List<String> selectedAssignations = [];

  @override
  void initState() {
    userRepo = Get.find<UserRepository>();
    adminAppointmentViewModel = Get.find<AdminAppointmentViewModel>();
    managePatientViewModel = Get.find<ManagePatientViewModel>();
    appointments = adminAppointmentViewModel.appointments;
    patients = allPatients = UserRepository.patients;
    admins = UserRepository.admins;
    isLoading = false;
    super.initState();
  }

  void fetchPatients() async {
    isLoading = true;
    try {
      allPatients = await UserRepository.fetchAllPatients();
      patients = allPatients;
      setState(() {
        isLoading = false; // Set loading to false after data is fetched
      });
    } catch (e) {
      // Handle any potential errors during data fetching
      setState(() {
        isLoading = false; // Set loading to false even on error
      });
    }
  }

  String calculateAge(DateTime? dateOfBirth) {
    if (dateOfBirth == null) {
      return 'N/A';
    }

    final currentDate = DateTime.now();
    final age = currentDate.year - dateOfBirth.year;

    if (currentDate.month < dateOfBirth.month ||
        (currentDate.month == dateOfBirth.month &&
            currentDate.day < dateOfBirth.day)) {
      return (age - 1)
          .toString(); // Subtract 1 if birthday hasn't occurred this year yet
    }

    return age.toString();
  }

  int calculateAgeInInt(DateTime? dateOfBirth) {
    if (dateOfBirth == null) {
      return 0;
    }

    final currentDate = DateTime.now();
    final age = currentDate.year - dateOfBirth.year;

    if (currentDate.month < dateOfBirth.month ||
        (currentDate.month == dateOfBirth.month &&
            currentDate.day < dateOfBirth.day)) {
      return age - 1;
    }

    return age;
  }

  void applyFilters() {
    // Filter patients based on selectedGender and selectedAge
    List<AppUser> filteredPatients = allPatients;

    if (selectedAssignations.isNotEmpty) {
      filteredPatients = filteredPatients.where((patient) {
        bool isAssigned = false;
        if (selectedAssignations.contains('Yours') &&
            selectedAssignations.contains('Others')) {
          isAssigned = true;
        } else if (selectedAssignations.contains('Yours')) {
          isAssigned = patient.assignedTo == Get.find<AppUser>().uid;
        } else if (selectedAssignations.contains('Others')) {
          isAssigned = patient.assignedTo != Get.find<AppUser>().uid;
        }
        return isAssigned;
      }).toList();
    }

    if (selectedGenders.isNotEmpty) {
      filteredPatients = filteredPatients.where((patient) {
        return selectedGenders.contains(patient.gender);
      }).toList();
    }

    if (selectedAgeRanges.isNotEmpty) {
      filteredPatients = filteredPatients.where((patient) {
        final age = calculateAgeInInt(patient.dateOfBirth);
        return selectedAgeRanges.any((range) {
          final parts = range.split('-');
          final minAge = int.parse(parts[0]);
          final maxAge = int.parse(parts[1]);
          return minAge <= age && age <= maxAge;
        });
      }).toList();
    }

    setState(() {
      patients = filteredPatients;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text("Patient List",
                style: AppTextStyle.brandBlueTextStyle.merge(AppTextStyle.h2)),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.brandBlue),
            onPressed: () => Get.back(), // Or Get.back() if using GetX
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list, color: AppColors.brandBlue),
              onPressed: () => _showFilterModal(context),
            ),
          ]),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : patients.isEmpty
                ? displayEmptyDataLoaded("No patient.", showBackArrow: false)
                : SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Star Meaning',
                                      style: AppTextStyle.h2),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Icon(Icons.star,
                                              color: AppColors.brandYellow),
                                          SizedBox(width: 10.w),
                                          Text(": Yours",
                                              style: AppTextStyle.h3.merge(
                                                  AppTextStyle
                                                      .brandBlueTextStyle)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.star,
                                              color: AppColors.brandBlue),
                                          SizedBox(width: 10.w),
                                          Text(": Other Physicians",
                                              style: AppTextStyle.h3.merge(
                                                  AppTextStyle
                                                      .brandBlueTextStyle)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.star_outline,
                                              color: AppColors.brandBlue),
                                          SizedBox(width: 10.w),
                                          Text(": Not Assigned",
                                              style: AppTextStyle.h3.merge(
                                                  AppTextStyle
                                                      .brandBlueTextStyle)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.brandBlue,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Close',
                                          style: AppTextStyle.h3.merge(
                                              AppTextStyle.lightBlueTextStyle)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Text("View Star's Meaning",
                                style: const TextStyle(
                                        decoration: TextDecoration.underline)
                                    .merge(AppTextStyle.h3.merge(
                                        AppTextStyle.brandBlueTextStyle))),
                          ),
                          SizedBox(height: 10.w),
                          ...patients.map((e) {
                            AdminAppointment appt;
                            String? assignedTo = e.assignedTo;

                            bool isAssigned =
                                assignedTo != null && assignedTo.isNotEmpty;

                            String assignedToName = assignedTo != null
                                ? admins
                                        .where((element) =>
                                            element.uid == assignedTo)
                                        .first
                                        .name ??
                                    ''
                                : '';

                            try {
                              appt = appointments
                                  .where((element) =>
                                      element.patientID == e.uid &&
                                      element.remark != null &&
                                      element.remark!.isNotEmpty)
                                  .reduce((current, next) =>
                                      DateTime.parse(current.date!).isAfter(
                                              DateTime.parse(next.date!))
                                          ? current
                                          : next);
                            } catch (e) {
                              appt = AdminAppointment();
                            }
                            return InfoCardTile().buildInfoCard(
                              hasAssignStarIcon: true,
                              shout: true,
                              name: e.name!,
                              age: calculateAge(e.dateOfBirth),
                              gender: e.gender!,
                              assignedTo: assignedToName,
                              onShout: () {
                                Get.toNamed(RouteHelper.getPatientShoutPage(),
                                    arguments: e);
                              },
                              onEdit: () {
                                Get.toNamed(
                                    RouteHelper.getPatientOverviewPage(),
                                    arguments: [e, appt]);
                              },
                              backgroundColor: isAssigned &&
                                      assignedTo == Get.find<AppUser>().uid
                                  ? AppColors.lightYellow
                                  : isAssigned
                                      ? AppColors.lightBlue.withOpacity(0.8)
                                      : Colors.white,
                              topRightTrailing: Container(
                                height: 50.w,
                                width: 50.w,
                                child: IconButton(
                                  icon: Icon(
                                      isAssigned
                                          ? Icons.star
                                          : Icons.star_outline,
                                      color: isAssigned &&
                                              assignedTo ==
                                                  Get.find<AppUser>().uid
                                          ? AppColors.brandYellow
                                          : AppColors.brandBlue),
                                  onPressed: e.assignedTo != null &&
                                          e.assignedTo !=
                                              Get.find<AppUser>().uid
                                      ? null
                                      : () async {
                                          if (isAssigned) {
                                            bool isUnassigned =
                                                await managePatientViewModel
                                                    .unassignPatient(e);
                                            if (isUnassigned) {
                                              setState(() {
                                                e.assignedTo = null;
                                              });
                                            }
                                          } else {
                                            bool isAssigned =
                                                await managePatientViewModel
                                                    .assignPatient(e);
                                            if (isAssigned) {
                                              setState(() {
                                                e.assignedTo =
                                                    Get.find<AppUser>().uid;
                                              });
                                            }
                                          }
                                        },
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                ListTile(
                  title: Text('Assignation', style: AppTextStyle.h2),
                  onTap: () {
                    // Close the modal
                    showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                            title: Text('Select Assignation'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CheckboxListTile(
                                  title: Text('Your Patients'),
                                  value: selectedAssignations.contains('Yours'),
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      if (newValue != null) {
                                        if (newValue) {
                                          selectedAssignations.add('Yours');
                                        } else {
                                          selectedAssignations.remove('Yours');
                                        }
                                      }
                                    });
                                  },
                                ),
                                CheckboxListTile(
                                  title: Text('Other patients'),
                                  value:
                                      selectedAssignations.contains('Others'),
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      if (newValue != null) {
                                        if (newValue) {
                                          selectedAssignations.add('Others');
                                        } else {
                                          selectedAssignations.remove('Others');
                                        }
                                      }
                                    });
                                  },
                                ),
                                // Add more gender options as needed
                              ],
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  // Apply gender filters and update the list
                                  applyFilters();
                                  Navigator.of(context).pop();
                                },
                                child: Text('Apply'),
                              ),
                            ],
                          );
                        });
                      },
                    );
                  },
                ),
                ListTile(
                  title: Text('Gender', style: AppTextStyle.h2),
                  onTap: () {
                    // Close the modal
                    showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                            title: Text('Select Gender'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CheckboxListTile(
                                  title: Text('Male'),
                                  value: selectedGenders.contains('Male'),
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      if (newValue != null) {
                                        if (newValue) {
                                          selectedGenders.add('Male');
                                        } else {
                                          selectedGenders.remove('Male');
                                        }
                                      }
                                    });
                                  },
                                ),
                                CheckboxListTile(
                                  title: Text('Female'),
                                  value: selectedGenders.contains('Female'),
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      if (newValue != null) {
                                        if (newValue) {
                                          selectedGenders.add('Female');
                                        } else {
                                          selectedGenders.remove('Female');
                                        }
                                      }
                                    });
                                  },
                                ),
                                // Add more gender options as needed
                              ],
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  // Apply gender filters and update the list
                                  applyFilters();
                                  Navigator.of(context).pop();
                                },
                                child: Text('Apply'),
                              ),
                            ],
                          );
                        });
                      },
                    );
                  },
                ),
                ListTile(
                  title: Text('Age', style: AppTextStyle.h2),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                            title: Text('Select Age Range'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CheckboxListTile(
                                  title: Text('18-34'),
                                  value: selectedAgeRanges.contains('18-34'),
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      if (newValue != null) {
                                        if (newValue) {
                                          selectedAgeRanges.add('18-34');
                                        } else {
                                          selectedAgeRanges.remove('18-34');
                                        }
                                      }
                                    });
                                  },
                                ),
                                CheckboxListTile(
                                  title: Text('35-60'),
                                  value: selectedAgeRanges.contains('35-60'),
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      if (newValue != null) {
                                        if (newValue) {
                                          selectedAgeRanges.add('35-60');
                                        } else {
                                          selectedAgeRanges.remove('35-60');
                                        }
                                      }
                                    });
                                  },
                                ),
                                CheckboxListTile(
                                  title: Text('61-90'),
                                  value: selectedAgeRanges.contains('61-90'),
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      if (newValue != null) {
                                        if (newValue) {
                                          selectedAgeRanges.add('61-90');
                                        } else {
                                          selectedAgeRanges.remove('61-90');
                                        }
                                      }
                                    });
                                  },
                                ),
                                // Add more age range options as needed
                              ],
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  // Apply age range filters and update the list
                                  applyFilters();
                                  Navigator.of(context).pop();
                                },
                                child: Text('Apply'),
                              ),
                            ],
                          );
                        });
                      },
                    );
                  },
                ),
                Divider(),
                ListTile(
                  title: Text('Clear Filters',
                      style: AppTextStyle.h2
                          .merge(AppTextStyle.brandBlueTextStyle)),
                  onTap: () {
                    setState(() {
                      selectedGenders.clear();
                      selectedAgeRanges.clear();
                      selectedAssignations.clear();
                      applyFilters();
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
