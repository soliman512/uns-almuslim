import 'package:flutter/material.dart';
import 'package:zad_almuslim/core/constants/colors.dart';
import 'package:zad_almuslim/core/constants/icons.dart';
import 'package:zad_almuslim/core/constants/textes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(top: 40, bottom: 20, left: 93),
      decoration: BoxDecoration(
        gradient: ConstColors.mainGradientColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          bottomLeft: Radius.circular(40),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(ConstIcons.drawerBackgroundBottomShape),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(ConstIcons.splashScreenBackgroundTopShape),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              //logo
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(height: 60),
                    Image.asset(ConstIcons.appLogo, width: 80),
                    Text(
                      ConstTexts.appName,
                      style: TextTheme.of(context).titleMedium!.copyWith(
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black38,
                            offset: Offset(0, 8),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  spacing: 20,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white30,
                        side: BorderSide(color: Colors.white, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            ConstIcons.changeAppearnceMode,
                            width: 26,
                          ),
                          Spacer(),
                          Text(
                            "تبديل الوضع",
                            style: TextTheme.of(
                              context,
                            ).titleMedium!.copyWith(fontSize: 18),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigator.pushReplacementNamed(context, "/settings");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white30,
                        side: BorderSide(color: Colors.white, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                      child: Row(
                        children: [
                          Image.asset(ConstIcons.settings, width: 26),
                          Spacer(),
                          Text(
                            ConstTexts.settings,
                            style: TextTheme.of(
                              context,
                            ).titleMedium!.copyWith(fontSize: 18),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(
                      "الَّذِينَ آمَنُوا وَتَطْمَئِنُّ قُلُوبُهُم بِذِكْرِ اللَّهِ ۗ أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ",
                      style: TextTheme.of(
                        context,
                      ).bodyMedium!.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
