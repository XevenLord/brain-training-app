import 'package:brain_training_app/common/ui/widget/empty_box.dart';
import 'package:brain_training_app/common/ui/widget/pill_button.dart';
import 'package:brain_training_app/patient/appointment/ui/page/appointment_main_page.dart';
import 'package:brain_training_app/patient/chat/ui/page/chat_list_page.dart';
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
  late HomeViewModel homeVModel;
  int _selectedIndex = 0;

  List<String> categories = [
    "All",
    "Mathematics",
    "Cognition",
    "Attention",
    "Memory",
  ];

  List<Map> games = [
    {
      "name": "Sudoku",
      "description": "This is sudoku",
      "img":
          "https://sudoku-puzzles.net/wp-content/puzzles/asterisk-sudoku/easy/1.png",
      "onTap": () {
        Get.toNamed(RouteHelper.getTicTacToe());
      }
    },
    {
      "name": "Tic Tac Toe",
      "description": "This is tic tac toe",
      "img":
          "https://www.rd.com/wp-content/uploads/2019/10/tic-tac-toe-scaled.jpg",
      "onTap": () {
        Get.toNamed(RouteHelper.getTicTacToe());
      },
    },
    {
      "name": "Mathematics",
      "description": "This is mathematics",
      "img":
          "https://image.shutterstock.com/image-illustration/mathematics-horizontal-banner-presentation-website-260nw-1798855321.jpg",
      "onTap": () {}
    },
  ];

  @override
  void initState() {
    super.initState();
    homeVModel = Get.find<HomeViewModel>();
    onTapNav(widget.pageIndex ?? 0);
  }

  void onTapNav(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget currentScreen() {
    switch (_selectedIndex) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
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
        );
      case 1:
        return ChatListPage();
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
                : "Profile";
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
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
