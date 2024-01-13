import 'package:brain_training_app/admin/games/maths/ui/view_model/math_result_vmodel.dart';
import 'package:brain_training_app/common/ui/widget/category_card_interface.dart';
import 'package:brain_training_app/patient/authentification/signUp/domain/entity/user.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GamesResultCategories extends StatefulWidget {
  AppUser? patient;
  GamesResultCategories({super.key, this.patient});

  @override
  State<GamesResultCategories> createState() => _GamesResultCategoriesState();
}

class _GamesResultCategoriesState extends State<GamesResultCategories> {
  List gameCats = [];

  @override
  void initState() {
    gameCats = [
      {
        "category": "Mathematics Game",
        "icon": Icons.gamepad,
        "gradient": const LinearGradient(
          colors: <Color>[
            Color(0xFFFF6C60),
            Color(0xFFFF484C),
          ],
        ),
        "onTap": () async {
          if (widget.patient != null) {
            dynamic mathAns = await Get.find<MathResultViewModel>()
                .getMathAnswersByUserId(widget.patient!.uid!);
            setState(() {});
            Get.toNamed(RouteHelper.getMathScoreOverview(),
                arguments: [widget.patient, mathAns]);
          } else {
            Get.toNamed(RouteHelper.getMathPatientList());
          }
        },
      },
      {
        "category": "Tic Tac Toe",
        "icon": Icons.gamepad,
        "gradient": const LinearGradient(
          colors: <Color>[
            Color(0xFF2753F3),
            Color(0xFF765AFC),
          ],
        ),
        "onTap": () {},
      },
      {
        "category": "2048 Game",
        "icon": Icons.gamepad,
        "gradient": const LinearGradient(
          colors: <Color>[
            Color(0xFF2EA13A),
            Color(0xFF41D73E),
          ],
        ),
        "onTap": () {},
      },
      {
        "category": "Flip Card Memory",
        "icon": Icons.gamepad,
        "gradient": const LinearGradient(
          colors: <Color>[
            Color(0xFFFE7F44),
            Color(0xFFFFCF68),
          ],
        ),
        "onTap": () {},
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: AppColors.brandBlue,
        title: Text("Games Result",
            style: AppTextStyle.h2.merge(AppTextStyle.brandBlueTextStyle)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            SingleChildScrollView(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: gameCats.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CategoryCard().buildCategoryCard(
                        category: gameCats[index]["category"],
                        icon: gameCats[index]["icon"],
                        gradient: gameCats[index]["gradient"],
                        onTap: gameCats[index]["onTap"],
                        textStyle:
                            AppTextStyle.h3.merge(AppTextStyle.whiteTextStyle)),
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
