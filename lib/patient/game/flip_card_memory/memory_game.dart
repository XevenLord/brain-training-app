import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';

import 'flipcardgame.dart';
import 'data.dart';

class MemoryGameHomePage extends StatefulWidget {
  @override
  _MemoryGameHomePageState createState() => _MemoryGameHomePageState();
}

class _MemoryGameHomePageState extends State<MemoryGameHomePage> {
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
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                _list[index].goto!,
                          ));
                    },
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
                                  style: TextStyle(
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
                                  children: generatestar(_list[index].noOfstar!),
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
          Icon(
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
  Widget? goto;
  int? noOfstar;

  Details(
      {this.name,
      this.primarycolor,
      this.secondarycolor,
      this.noOfstar,
      this.goto});
}

List<Details> _list = [
  Details(
      name: "EASY",
      primarycolor: Colors.green,
      secondarycolor: Colors.green[300],
      noOfstar: 1,
      goto: FlipCardGame(Level.Easy)),
  Details(
      name: "MEDIUM",
      primarycolor: Colors.orange,
      secondarycolor: Colors.orange[300],
      noOfstar: 2,
      goto: FlipCardGame(Level.Medium)),
  Details(
      name: "HARD",
      primarycolor: Colors.red,
      secondarycolor: Colors.red[300],
      noOfstar: 3,
      goto: FlipCardGame(Level.Hard))
];
