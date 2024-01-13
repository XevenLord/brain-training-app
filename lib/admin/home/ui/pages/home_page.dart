import 'package:brain_training_app/admin/chat/ui/pages/chat_list.dart';
import 'package:brain_training_app/admin/home/ui/view_model/home_vmodel.dart';
import 'package:brain_training_app/admin/home/ui/widgets/home_content.dart';
import 'package:brain_training_app/admin/profile/ui/pages/admin_profile.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminHomePage extends StatefulWidget {
  int? pageIndex;
  AdminHomePage({Key? key, this.pageIndex}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _currentIndex = 1;

  AdminHomeViewModel homeViewModel = Get.find<AdminHomeViewModel>();

  @override
  void initState() {
    fetchAllPatients();
    if (widget.pageIndex != null) {
      _currentIndex = widget.pageIndex!;
    }
    super.initState();
  }

  void fetchAllPatients() async {
    await homeViewModel.fetchAllPatients();
    setState(() {});
  }

  final List<Widget> pages = [
    AdminChatList(), // Route name for Chat
    HomeContent(), // Route name for Home
    AdminProfile(), // Route name for Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: pages,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomNavigationBar(
              selectedItemColor: AppColors.brandBlue,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat),
                  label: 'Chat',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
