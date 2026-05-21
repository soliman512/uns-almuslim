import 'package:flutter/material.dart';
import 'package:zad_almuslim/core/constants/colors.dart';

class MainButton extends StatelessWidget {
  final String title;
  final String image;
  final String pageRouteName;
  final double fontSize;
  const MainButton({
    super.key,
    required this.title,
    required this.image,
    required this.pageRouteName,
    this.fontSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 68,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, pageRouteName);
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(0),
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
          child: Row(
            spacing: 8,
            children: [
              Expanded(
                child: Container(
                  height: double.infinity,
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: ConstColors.mainColor, width: 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Image.asset(image),
                ),
              ),
              Expanded(
                flex: (280 / 71).toInt(),

                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: ConstColors.mainColor, width: 1),
                    gradient: ConstColors.mainGradientColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium!.copyWith(fontSize: fontSize),
                      ),
                      // Image.asset("assets/icons/ic_go.png", width: 26),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
