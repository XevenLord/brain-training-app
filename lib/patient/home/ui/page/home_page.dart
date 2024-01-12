import 'package:brain_training_app/common/domain/service/notification_api.dart';
import 'package:brain_training_app/common/ui/widget/empty_box.dart';
import 'package:brain_training_app/common/ui/widget/pill_button.dart';
import 'package:brain_training_app/patient/appointment/ui/page/appointment_main_page.dart';
import 'package:brain_training_app/patient/appointment/ui/view_model/appointment_vmodel.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/patient/chat/ui/pages/chat_list.dart';
import 'package:brain_training_app/patient/healthCheck/ui/widgets/question_card.dart';
import 'package:brain_training_app/patient/home/ui/view_model/home_vmodel.dart';
import 'package:brain_training_app/patient/home/ui/widget/game_card.dart';
import 'package:brain_training_app/common/ui/widget/screen.dart';
import 'package:brain_training_app/patient/profile/ui/page/profile_main_page.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  int? pageIndex;
  HomePage({super.key, this.pageIndex});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeViewModel homeVModel = Get.find<HomeViewModel>();
  AppointmentViewModel appointmentVModel = Get.find<AppointmentViewModel>();
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
      "name": "Mathematics",
      "description":
          "A math game enhances math skills through fun challenges and problem-solving.",
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
    final appUser = Get.find<AppUser>();
    // chatVModel.initUsersListener();
    onTapNav(widget.pageIndex ?? 0);
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
              TextButton(
                  child: Text("Update your mental status?"),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return QuestionCard();
                          });
                        });
                  }),
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    categories.length,
                    (index) => PillButton(
                      text: categories[index],
                      margin: const EdgeInsets.only(right: 10),
                      onTap: () {
                        print("Category tapped");
                      },
                    ),
                  ),
                ),
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
      ),
      noBackBtn: true,
      body: currentScreen(),
      floatingActionButton: _selectedIndex == 2
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.brandBlue,
              onPressed: () => Get.toNamed(RouteHelper.getMyAppointmentPage()),
              label: Text("My Appointment", style: AppTextStyle.h4),
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
