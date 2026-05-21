import 'package:flutter/material.dart';
import 'package:zad_almuslim/core/constants/colors.dart';
import 'package:zad_almuslim/core/constants/icons.dart';
import 'package:zad_almuslim/core/constants/json_files.dart';
import 'package:zad_almuslim/core/constants/textes.dart';
import 'package:zad_almuslim/core/utils/date_formate.dart';
import 'package:zad_almuslim/core/widgets/counter_button.dart';
import 'package:zad_almuslim/core/widgets/drawer.dart';
import 'package:zad_almuslim/core/widgets/progress.dart';
import 'package:zad_almuslim/core/widgets/special_body.dart';
import 'package:zad_almuslim/features/morning_evening_azkar/logic/evening_morning_azkar_logic.dart';
import 'package:zad_almuslim/core/widgets/appbar.dart';

class MorningEveningAzkar extends StatefulWidget {
  const MorningEveningAzkar({super.key, this.fontSizeFactor = 1.0});
  final double fontSizeFactor;
  @override
  State<MorningEveningAzkar> createState() => _MorningEveningAzkarState();
}

class _MorningEveningAzkarState extends State<MorningEveningAzkar> {
  final GlobalKey<ScaffoldState> _scaffoldKeyState = GlobalKey<ScaffoldState>();
  List azkar = [];
  int currentZikrNumber = 0;
  int counter = 0;
  bool isLoading = true;
  void loadData() async {
    var data = await AzkarLogic.loadAzkar(
      DateManager.isMorning()
          ? ConstJsonFiles.morningAzkar
          : ConstJsonFiles.eveningAzkar,
    );
    setState(() {
      azkar.addAll(data);
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyState,
      extendBodyBehindAppBar: true,
      appBar: MyAppbar(
        onPressDrawer: () {
          _scaffoldKeyState.currentState!.openDrawer();
        },
        pageName: DateManager.isMorning()
            ? ConstTexts.morningAzkar
            : ConstTexts.eveningAzkar,
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Porgress()
          : SpecialBody(
              body: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(widget.fontSizeFactor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //content
                    SizedBox(height: 100),
                    // number and number box
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        //zikr number box
                        Image.asset(ConstIcons.zikrNumber),

                        //zikr number NUM
                        Text(
                          (currentZikrNumber + 1).toString(),
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall!.copyWith(fontFamily: 'exo'),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    // zikr + reward scroll accessability
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * .4,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 10,
                          children: [
                            //content ZIKR
                            Text(
                              azkar[currentZikrNumber]["content"],

                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(fontSize: 18, height: 1.7),
                            ),
                            //dashed
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 60.0,
                              ),
                              child: LayoutBuilder(
                                builder:
                                    (
                                      BuildContext context,
                                      BoxConstraints constraints,
                                    ) {
                                      final boxWidth = constraints
                                          .constrainWidth();
                                      final dashCount = (boxWidth / (8 + 10))
                                          .floor();

                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: List.generate(dashCount, (_) {
                                          return SizedBox(
                                            width: 10,
                                            height: 1,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                color: ConstColors.mainColor,
                                              ),
                                            ),
                                          );
                                        }),
                                      );
                                    },
                              ),
                            ),
                            //alAjr
                            Text(
                              "الأجـــــــــر",
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(color: ConstColors.mainColor),
                              textAlign: TextAlign.center,
                            ),
                            //reward
                            Text(
                              azkar[currentZikrNumber]["reward"],
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(color: ConstColors.mainColor),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    // times of repeat
                    Text(
                      "التكرار: ${azkar[currentZikrNumber]["repeat"]}",
                      style: Theme.of(context).textTheme.bodySmall!,
                    ),

                    SizedBox(height: 10),
                    // controls
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.sizeOf(context).height * .25,
                      child: Row(
                        spacing: 8,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: double.infinity,
                              child: FilledButton.icon(
                                onPressed: () {
                                  if (currentZikrNumber < azkar.length - 1) {
                                    setState(() {
                                      counter = 0;
                                      currentZikrNumber++;
                                    });
                                  }
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: ConstColors.mainColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      topRight: Radius.circular(80),
                                      bottomRight: Radius.circular(80),
                                    ),
                                  ),
                                ),
                                label: Image.asset(ConstIcons.nextZikr),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: (220 / 60).toInt(),
                            child: SizedBox(
                              height: double.infinity,
                              child: CounterButton(
                                onPressed: () {
                                  if (counter <
                                      azkar[currentZikrNumber]['repeat']) {
                                    setState(() {
                                      counter++;
                                    });
                                  } else if (currentZikrNumber <
                                      azkar.length - 1) {
                                    setState(() {
                                      counter = 0;
                                      currentZikrNumber++;
                                    });
                                  }
                                },
                                label: counter.toString(),
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: double.infinity,

                              child: OutlinedButton.icon(
                                onPressed: () {
                                  if (currentZikrNumber > 0) {
                                    setState(() {
                                      counter = 0;
                                      currentZikrNumber--;
                                    });
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: ConstColors.mainColor,
                                  ),

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                      topLeft: Radius.circular(80),
                                      bottomLeft: Radius.circular(80),
                                    ),
                                  ),
                                ),
                                label: Image.asset(ConstIcons.pastZikr),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
