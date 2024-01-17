import 'package:brain_training_app/patient/game/2048/tzfe_vmodel.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TZFEDifficultyPage extends StatefulWidget {
  const TZFEDifficultyPage({super.key});

  @override
  State<TZFEDifficultyPage> createState() => _TZFEDifficultyPageState();
}

class _TZFEDifficultyPageState extends State<TZFEDifficultyPage> {
  late TZFEViewModel _tzfeViewModel;

  @override
  void initState() {
    _tzfeViewModel = Get.find<TZFEViewModel>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.brandBlue,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text("Pick The Difficulty Level",
                  style:
                      AppTextStyle.h1.merge(AppTextStyle.brandBlueTextStyle)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: _list[index].goto,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Container(
                            height: 90,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: _list[index].secondarycolor,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: const [
                                  BoxShadow(
                                      blurRadius: 4,
                                      color: Colors.black12,
                                      spreadRadius: 0.3,
                                      offset: Offset(
                                        5,
                                        3,
                                      ))
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                    child: Text(
                                  _list[index].name!,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          blurRadius: 2,
                                          offset: Offset(1, 2),
                                        ),
                                        Shadow(
                                            color: Colors.green,
                                            blurRadius: 2,
                                            offset: Offset(0.5, 2))
                                      ]).merge(AppTextStyle.h1),
                                )),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children:
                                      generatestar(_list[index].noOfstar!),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> generatestar(int no) {
    List<Widget> _icons = [];
    for (int i = 0; i < no; i++) {
      _icons.insert(
          i,
          const Icon(
            Icons.star,
            color: Colors.yellow,
          ));
    }
    return _icons;
  }
}

class Details {
  String? name;
  Color? primarycolor;
  Color? secondarycolor;
  Function()? goto;
  int? noOfstar;

  Details({
    this.name,
    this.primarycolor,
    this.secondarycolor,
    this.noOfstar,
    this.goto,
  });
}

List<Details> _list = [
  // 256
  Details(
    name: "EASY",
    primarycolor: Colors.green,
    secondarycolor: Colors.green[300],
    noOfstar: 1,
    goto: () {
      Get.toNamed(RouteHelper.getTZFEGame(), arguments: Level.Easy);
      Get.find<TZFEViewModel>().setGridSize(Level.Easy);
    },
  ),
  // 512
  Details(
    name: "MEDIUM",
    primarycolor: Colors.orange,
    secondarycolor: Colors.orange[300],
    noOfstar: 2,
    goto: () {
      Get.toNamed(RouteHelper.getTZFEGame(), arguments: Level.Medium);
      Get.find<TZFEViewModel>().setGridSize(Level.Medium);
    },
  ),
  // 1024
  Details(
    name: "HARD",
    primarycolor: Colors.red,
    secondarycolor: Colors.red[300],
    noOfstar: 3,
    goto: () {
      Get.toNamed(RouteHelper.getTZFEGame(), arguments: Level.Hard);
      Get.find<TZFEViewModel>().setGridSize(Level.Hard);
    },
  )
];
