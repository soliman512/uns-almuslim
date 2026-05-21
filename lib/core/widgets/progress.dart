import 'package:flutter/material.dart';
import 'package:zad_almuslim/core/constants/colors.dart';

class Porgress extends StatelessWidget {
  const Porgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: ConstColors.secondMainColor,
        color: ConstColors.mainColor,
        strokeWidth: 8,
      ),
    );
  }
}
