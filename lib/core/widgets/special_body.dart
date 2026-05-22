import 'package:flutter/material.dart';
import 'package:zad_almuslim/core/constants/icons.dart';

// ignore: must_be_immutable
class SpecialBody extends StatelessWidget {
  Widget? body;
  bool? showTopIcon;
  SpecialBody({super.key, required this.body, this.showTopIcon});
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,

      children: [
        Visibility(
          visible: showTopIcon ?? true,
          child: Align(
            alignment: Alignment.topCenter,
            child: RotatedBox(
              quarterTurns: 2,
              child: Opacity(
                opacity: 0.15,
                child: Image.asset(ConstIcons.backgroundShape),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: SizedBox(width: double.infinity, child: body),
        ),
      ],
    );
  }
}
