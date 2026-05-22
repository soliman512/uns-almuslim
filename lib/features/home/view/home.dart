import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zad_almuslim/core/constants/colors.dart';
import 'package:zad_almuslim/core/constants/icons.dart';
import 'package:zad_almuslim/core/constants/routes.dart';
import 'package:zad_almuslim/core/constants/textes.dart';
import 'package:zad_almuslim/core/utils/date_formate.dart';
import 'package:zad_almuslim/core/widgets/header.dart';
import 'package:zad_almuslim/core/widgets/main_button.dart';
import 'package:zad_almuslim/core/widgets/settings_button.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isVisible = false;
  static final ValueNotifier<String> _timeNotifier = ValueNotifier("");
  Timer? _timer;
  void startTimer() {
    _timeNotifier.value = DateManager.getFormattedTime(DateTime.now());
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _timeNotifier.value = DateManager.getFormattedTime(DateTime.now());
    });
  }

  @override
  void dispose() {
    // 3. Stop the heartbeat when leaving the page (saves battery)
    _timer?.cancel();
    _timeNotifier.dispose();
    super.dispose();
  }

  String? headerAyah;

  String getHeaderAyah(List<String> ayat) {
    final randomGenerator = Random();
    int randomAyahNum = randomGenerator.nextInt(ayat.length);
    headerAyah = ayat[randomAyahNum];
    return headerAyah!;
  }

  @override
  void initState() {
    getHeaderAyah(ConstTexts.headerAyats);
    Future.delayed(
      Duration(milliseconds: 10),
      () => setState(() {
        _isVisible = true;
      }),
    );
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          spacing: 8,
          children: [
            Image.asset(ConstIcons.appbarLogo, width: 28),
            Image.asset(ConstIcons.homeLogoName, width: 80),
            // Text(
            //   ConstTexts.appName,
            //   style: Theme.of(
            //     context,
            //   ).textTheme.titleLarge!.copyWith(fontSize: 24),
            // ),
          ],
        ),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            decoration: BoxDecoration(
              color: ConstColors.mainColor,
              borderRadius: BorderRadius.circular(80),
            ),
            child: ValueListenableBuilder(
              valueListenable: _timeNotifier,

              builder: (context, timeValue, child) => Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    DateManager.getCurrentNafha(),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Image.asset(
                    DateManager.isMorning() ? ConstIcons.sun : ConstIcons.moon,
                    width: 26,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: Duration(milliseconds: 2000),
                  curve: Curves.easeOut,
                  bottom: _isVisible ? -40 : -300,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: 0.4,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(ConstIcons.backgroundShape),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    spacing: 20,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //header with ayah
                      Header(content: headerAyah ?? ''),
                      SizedBox(height: 20),
                      //buttons
                      ValueListenableBuilder(
                        valueListenable: _timeNotifier,

                        builder: (context, _, _) => MainButton(
                          title: DateManager.isMorning()
                              ? ConstTexts.morningAzkar
                              : ConstTexts.eveningAzkar,
                          image: ConstIcons.azkar,
                          pageRouteName: ConstRoutes.azkar,
                        ),
                      ),
                      MainButton(
                        title: ConstTexts.mesbha,
                        image: ConstIcons.sebha,
                        pageRouteName: ConstRoutes.sebha,
                      ),
                      MainButton(
                        title: ConstTexts.allahNames,
                        fontSize: 20,
                        image: ConstIcons.allahNames,
                        pageRouteName: ConstRoutes.allahNames,
                      ),
                      MainButton(
                        title: ConstTexts.meraj,
                        image: ConstIcons.meraj,
                        pageRouteName: ConstRoutes.meraj,
                      ),
                      SettingsButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
