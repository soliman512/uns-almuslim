import 'package:flutter/material.dart';
import 'package:zad_almuslim/core/constants/colors.dart';
import 'package:zad_almuslim/core/constants/textes.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        height: 60,

        child: OutlinedButton(
          onPressed: () {
            Navigator.pushNamed(context, "/settings");
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: ConstColors.mainColor, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/icons/ic_settings.png", width: 32),
              Spacer(),
              Text(
               ConstTexts.settings,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(color: ConstColors.mainColor),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
