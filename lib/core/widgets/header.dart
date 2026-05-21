import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zad_almuslim/core/constants/icons.dart';

// ignore: must_be_immutable
class Header extends StatelessWidget {
  String content;
  Header({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(ConstIcons.homeHeader),
          Text(
            content,
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(color: Color(0xffFF6200)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
