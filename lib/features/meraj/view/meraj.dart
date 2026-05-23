import 'package:flutter/material.dart';
import 'package:zad_almuslim/core/constants/colors.dart';
import 'package:zad_almuslim/core/constants/icons.dart';
import 'package:zad_almuslim/core/constants/textes.dart';
import 'package:zad_almuslim/core/widgets/appbar.dart';
import 'package:zad_almuslim/core/widgets/drawer.dart';
import 'package:zad_almuslim/core/widgets/progress.dart';
import 'package:zad_almuslim/core/widgets/special_body.dart';
import 'package:zad_almuslim/features/meraj/logic/meraj_logic.dart';
import 'package:zad_almuslim/features/meraj/logic/meraj_user_completed_azkar.dart';
import 'package:zad_almuslim/features/meraj/view/meraj_zikr_counter.dart';

class Meraj extends StatefulWidget {
  const Meraj({super.key, this.fontSizeFactor = 1.0});
  final double fontSizeFactor;
  @override
  State<Meraj> createState() => _MerajState();
}

class _MerajState extends State<Meraj> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  List azkar = [];
  bool isLoading = true;
  int counter = 0;

  final MerajUserCompletedAzkar _userCompletedAzkar = MerajUserCompletedAzkar();

  void loadAzkar() async {
    var data = await MerajLogic.loadData();
    if (!mounted) return;
    setState(() {
      azkar.addAll(data);
      isLoading = false;
    });
  }

  @override
  void initState() {
    loadAzkar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      key: scaffoldState,
      appBar: MyAppbar(
        pageName: ConstTexts.meraj,
        onPressDrawer: () => scaffoldState.currentState!.openDrawer(),
      ),
      drawer: AppDrawer(),
      body: SpecialBody(
        body: isLoading
            ? Porgress()
            : ListView.builder(
                itemCount: azkar.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final id = azkar[index]['id'];
                  final title = azkar[index]['title'];
                  final repeat = azkar[index]['repeat'];
                  final source = azkar[index]['source'];
                  final grade = azkar[index]['grade'];
                  final zikr = azkar[index]['zikr'];
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        // isScrollControlled: true,
                        // backgroundColor: Colors.transparent,
                        builder: (context) {
                          return Dialog(
                            backgroundColor: Colors.transparent,
                            insetPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 40,
                            ),
                            child: Container(
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.symmetric(
                                vertical: 40,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.black
                                    : Color(0xffECECEC),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 40,
                                  children: [
                                    // data
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      spacing: 20,
                                      children: [
                                        ...[
                                          _sectionTitle(
                                            "الذكر المراد قوله",
                                            context,
                                          ),
                                          _zikrContentText(context, zikr),
                                        ],

                                        ...[
                                          _sectionTitle("التكرار", context),
                                          _zikrContentText(
                                            context,
                                            "$repeat مرة",
                                          ),
                                        ],

                                        ...[
                                          _sectionTitle("الفضل", context),

                                          _zikrContentText(context, source),
                                        ],
                                        ...[
                                          _sectionTitle("الإسناد", context),

                                          _zikrContentText(context, grade),
                                        ],
                                      ],
                                    ),

                                    // start button
                                    Row(
                                      spacing: 4,
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: GestureDetector(
                                            onTap: () async {
                                              Navigator.pop(context);

                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MerajZikrCounter(
                                                        id: id,
                                                        zikr: zikr,
                                                        repeat: repeat,
                                                        title: title,
                                                        fontSizeFactor: widget
                                                            .fontSizeFactor,
                                                      ),
                                                ),
                                              );

                                              setState(() {});
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                gradient: ConstColors
                                                    .mainGradientColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                "قول الذكر",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      color: Colors.white,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: FilledButton.icon(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            style: FilledButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 14,
                                              ),
                                              backgroundColor:
                                                  ConstColors.input,
                                              side: BorderSide.none,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            label: Icon(
                                              Icons.close,
                                              color: ConstColors.mainColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Stack(
                      alignment: Alignment.topRight,

                      children: [
                        //zikr
                        Container(
                          padding: EdgeInsets.all(24),
                          margin: EdgeInsets.symmetric(vertical: 14),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: ConstColors.mainGradientColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text(
                                title,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(top: 16),
                                padding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: MediaQuery(
                                  data: MediaQuery.of(context).copyWith(
                                    textScaler: TextScaler.linear(
                                      widget.fontSizeFactor,
                                    ),
                                  ),
                                  child: Text(
                                    zikr,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //repeating
                        Container(
                          width: MediaQuery.sizeOf(context).width * 0.2,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: ConstColors.secondMainColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(-4, 4),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Text(
                            "$repeat مرة",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(color: Colors.black),
                          ),
                        ),
                        //confirm zikr
                        FutureBuilder<bool>(
                          future: _userCompletedAzkar.checkIsZikrCompleted(id),

                          builder: (context, snapshot) {
                            final isCompleted = snapshot.data ?? false;

                            if (!isCompleted) {
                              return SizedBox();
                            }

                            return Positioned(
                              left: 10,
                              top: 20,

                              child: Transform.rotate(
                                angle: 0.5,

                                child: Column(
                                  children: [
                                    Image.asset(
                                      ConstIcons.confirmUserZikr,
                                      width: 32,
                                    ),

                                    Text(
                                      "تم",

                                      style: TextStyle(
                                        color: ConstColors.secondMainColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}

Widget _sectionTitle(String title, BuildContext context) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 1),
    decoration: BoxDecoration(
      color: ConstColors.secondMainColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      title,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.black,
      ),
    ),
  );
}

Widget _zikrContentText(BuildContext context, String content) {
  return Text(
    content,
    textAlign: TextAlign.center,
    style: Theme.of(context).textTheme.bodyMedium,
  );
}
