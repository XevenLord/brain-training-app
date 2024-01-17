import 'package:brain_training_app/common/ui/widget/empty_box.dart';
import 'package:brain_training_app/patient/appointment/ui/page/appointment_main_page.dart';
import 'package:brain_training_app/patient/appointment/ui/view_model/appointment_vmodel.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/service/auth_repo.dart';
import 'package:brain_training_app/patient/chat/ui/pages/chat_list.dart';
import 'package:brain_training_app/patient/healthCheck/ui/widgets/question_card.dart';
import 'package:brain_training_app/patient/home/ui/view_model/feedback_vmodel.dart';
import 'package:brain_training_app/patient/home/ui/view_model/home_vmodel.dart';
import 'package:brain_training_app/patient/home/ui/widget/game_card.dart';
import 'package:brain_training_app/common/ui/widget/screen.dart';
import 'package:brain_training_app/patient/profile/ui/page/profile_main_page.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  int? pageIndex;
  HomePage({super.key, this.pageIndex});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeViewModel homeVModel = Get.find<HomeViewModel>();
  AppointmentViewModel appointmentVModel = Get.find<AppointmentViewModel>();
  late FeedbackViewModel feedbackVModel;
  DateTime? lastOnline;
  DateTime? lastMentalTest;
  DateTime? lastInspired;
  bool dialogShown = false;
  bool mentalTestShown = false;

  final TextEditingController feedbackController = TextEditingController();

  // ChatViewModel chatVModel = Get.find<ChatViewModel>();

  int _selectedIndex = 0;
  int popupIndex = 0;

  List<String> categories = [
    "All",
    "Mathematics",
    "Cognition",
    "Attention",
    "Memory",
  ];

  List<Map> games = [
    {
      "name": "Tic Tac Toe",
      "description":
          "Tic-tac-toe is a 3x3 grid game to get three in a row and win.",
      "img": "assets/images/tic_tac_toe_game.png",
      "onTap": () {
        Get.toNamed(RouteHelper.getTTTHome());
      },
    },
    {
      "name": "Memory Flip Card",
      "description":
          "A memory flip card game tests your recall by matching pairs of hidden cards.",
      "img": "assets/images/flipcard_game.jpg",
      "onTap": () {
        Get.toNamed(RouteHelper.getFlipCardHome());
      }
    },
    {
      "name": "Arithmetic Game",
      "description":
          "Arithmetic game enhances math skills through fun challenges and problem-solving.",
      "img": "assets/images/mathematics_game.png",
      "onTap": () {
        Get.toNamed(RouteHelper.getMathHome());
      }
    },
    {
      "name": "2048",
      "description":
          "2048 is a number puzzle game where you merge tiles to reach 2048.",
      "img": "assets/images/2048_game.png",
      "onTap": () {
        Get.toNamed(RouteHelper.getTZFEHome());
      }
    },
  ];

  @override
  void initState() {
    super.initState();
    initHomePage();
  }

  Future<void> initHomePage() async {
    await retrieveSavedState();
    feedbackVModel = Get.find<FeedbackViewModel>();
    // chatVModel.initUsersListener();
    onTapNav(widget.pageIndex ?? 0);
    fetchInspirationalMessages();
    appointmentVModel.getAppointmentList();
    appointmentVModel.getPhysiotherapistList();

    if (Get.find<AppUser>().uid != null) {
      print("got user");
      lastOnline = Get.find<AppUser>().lastOnline;
      lastMentalTest = Get.find<AppUser>().mentalQuiz;
      lastInspired = Get.find<AppUser>().lastInspired;
      updateLastOnline();
      updateLastInspired();

      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!mentalTestShown) {
          showMentalStatusQuiz();
        }
        if (!dialogShown && lastInspired != null) {
          showActiveGameDialog();
        }
      });
    }
  }

  Future<void> retrieveSavedState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("before retrieve");
    print(prefs.getBool('dialogShown'));
    setState(() {
      dialogShown = prefs.getBool('dialogShown') ?? false;
      mentalTestShown = prefs.getBool('mentalTestShown') ?? false;
    });
    print("after retrieve");
    print(dialogShown);
    print(mentalTestShown);
  }

  Future<void> saveStateToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("before save");
    print("dialogShown: $dialogShown");
    print("mentalTestShown: $mentalTestShown");
    await prefs.setBool('dialogShown', dialogShown);
    await prefs.setBool('mentalTestShown', mentalTestShown);
  }

  void fetchInspirationalMessages() async {
    await homeVModel.fetchGeneralInspirationalMessages();
    await homeVModel.fetchInspirationalMessages();
    setState(() {});
    homeVModel.showPopUpInspirationalMessageDialog(lastInspired);
  }

  void updateLastOnline() async {
    await FirebaseAuthRepository.updateLastOnline(Get.find<AppUser>().uid!);
    setState(() {});
  }

  void updateLastInspired() async {
    await homeVModel.updateLastInspired();
    setState(() {});
  }

  void showActiveGameDialog() async {
    if (lastOnline == null) return;
    if (lastOnline != null &&
        DateTime.now().difference(lastOnline!).inHours <= 0) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Image.asset(AppConstant.NEUROFIT_LOGO_ONLY, height: 100.h),
              content: Text(
                  "Dear ${Get.find<AppUser>().name},\n\n" +
                      "You have been away for ${DateTime.now().difference(lastOnline!).inHours} hours. Please play our games to keep your brain active!",
                  style: AppTextStyle.h4),
              actions: [
                TextButton(
                  onPressed: () {
                    dialogShown = true;
                    saveStateToSharedPreferences();
                    Get.back();
                  },
                  child: Text("I understand", style: AppTextStyle.h3),
                ),
              ],
            );
          });
    }
  }

  void showMentalStatusQuiz() async {
    if ((lastMentalTest != null &&
            DateTime.now().difference(lastMentalTest!).inDays >= 7) ||
        lastMentalTest == null) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Image.asset(AppConstant.NEUROFIT_LOGO_ONLY, height: 100.h),
              content: Text(
                  "Dear ${Get.find<AppUser>().name},\n\n" +
                      "We would like to survey your current mental status.",
                  style: AppTextStyle.h4),
              actions: [
                TextButton(
                  onPressed: () {
                    mentalTestShown = true;
                    saveStateToSharedPreferences();
                    Get.back();
                    showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return QuestionCard();
                          });
                        });
                  },
                  child: Text("Proceed", style: AppTextStyle.h3),
                ),
              ],
            );
          });
    }
  }

  void onTapNav(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void updatePopupIndex(int newIndex) {
    setState(() {
      popupIndex = newIndex;
    });
  }

  Widget currentScreen() {
    switch (_selectedIndex) {
      case 0:
        return SingleChildScrollView(
          key: const PageStorageKey("home"),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              // TextButton(
              //     child: Text("Update your mental status?"),
              //     onPressed: () {
              //       showDialog(
              //           context: context,
              //           builder: (context) {
              //             return StatefulBuilder(builder: (context, setState) {
              //               return QuestionCard();
              //             });
              //           });
              //     }),
              // SingleChildScrollView(
              //   padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: List.generate(
              //       categories.length,
              //       (index) => PillButton(
              //         text: categories[index],
              //         margin: const EdgeInsets.only(right: 10),
              //         onTap: () {
              //           print("Category tapped");
              //         },
              //       ),
              //     ),
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: Text("Pick A Game Below To Play!",
                    style:
                        AppTextStyle.h2.merge(AppTextStyle.brandBlueTextStyle)),
              ),
              SizedBox(height: 10.h),
              ...List.generate(games.length, (index) {
                return GameCard(
                  img: games[index]["img"],
                  title: games[index]["name"],
                  description: games[index]["description"],
                  onTap: games[index]["onTap"],
                );
              }),
            ],
          ),
        );
      case 1:
        return ChatList();
      case 2:
        return AppointmentMainPage();
      case 3:
        return ProfileMainPage();
      default:
        return EmptyBox(child: Text("This is the profile page"));
    }
  }

  String appBarTitle() {
    return _selectedIndex == 0
        ? "NeuroFit"
        : _selectedIndex == 1
            ? "Chats"
            : _selectedIndex == 2
                ? "Appointments"
                : "Your Profile";
  }

  void submitFeedback() async {
    if (feedbackController.text.trim().isEmpty) return;
    await feedbackVModel.submitFeedback(feedbackController.text);
    feedbackController.clear();
    setState(() {});
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      useSingleChildScrollView: false,
      hasHorizontalPadding: _selectedIndex != 0 ? true : false,
      appBar: AppBar(
        title: Text(
          appBarTitle(),
          style: AppTextStyle.h1.merge(_selectedIndex == 0
              ? AppTextStyle.brandBlueTextStyle
              : AppTextStyle.blackTextStyle),
        ),
        titleSpacing: 16,
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: _selectedIndex == 0
            ? [
                IconButton(
                  padding: EdgeInsets.only(right: 16.w),
                  onPressed: () {
                    homeVModel.signOutUser(context);
                  },
                  icon: const Icon(Icons.logout, color: AppColors.grey),
                )
              ]
            : null,
        automaticallyImplyLeading: false,
      ),
      noBackBtn: true,
      body: currentScreen(),
      floatingActionButton: _selectedIndex == 2
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.brandBlue,
              onPressed: () => Get.toNamed(RouteHelper.getMyAppointmentPage()),
              label: Text("My Appointment", style: AppTextStyle.h4),
            )
          : _selectedIndex == 3
              ? FloatingActionButton.extended(
                  backgroundColor: AppColors.brandBlue,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Feedback',
                            style: AppTextStyle.h2
                                .merge(AppTextStyle.brandBlueTextStyle)),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(
                                child: Image.asset(
                                  AppConstant.FEEDBACK_IMG,
                                  height: 200.h,
                                  width: 200.w,
                                ),
                              ),
                              SizedBox(height: 10.w),
                              Text(
                                  'Your feedback to our application is highly appreciated!:',
                                  style: AppTextStyle.c1),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: feedbackController,
                                style: AppTextStyle.h4,
                                maxLines: 5,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter your feedback here...',
                                    hintStyle: AppTextStyle.h4),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.brandBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            onPressed: () {
                              submitFeedback();
                            },
                            child:
                                Text('Submit Feedback', style: AppTextStyle.h3),
                          ),
                        ],
                      ),
                    );
                  },
                  label: Text("Feedback", style: AppTextStyle.h4),
                )
              : null,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        unselectedItemColor: AppColors.fadedBlue,
        selectedItemColor: AppColors.brandBlue,
        type: BottomNavigationBarType.fixed,
        onTap: onTapNav,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.messenger),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_sharp),
            label: "Appointment",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
