import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:zad_almuslim/core/constants/colors.dart';
import 'package:zad_almuslim/core/constants/icons.dart';
import 'package:zad_almuslim/core/constants/textes.dart';
import 'package:zad_almuslim/core/widgets/appbar.dart';
import 'package:zad_almuslim/core/widgets/special_body.dart';

class Settings extends StatefulWidget {
  final ThemeMode currentMode;
  final Function(ThemeMode) onThemeChanged;
  final String currentFontSize;
  final Function(String) onFontSizeChanged;
  const Settings({
    super.key,
    required this.currentMode,
    required this.onThemeChanged,
    required this.onFontSizeChanged,
    required this.currentFontSize,
  });

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<String> fontSizes = ["صغير", "متوسط", "كبير"];
  String selectedSize = "متوسط";
  final TextEditingController noteController = TextEditingController();

  //send email function:
  Future<void> sendEmail() async {
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Origin': 'http://localhost',
        },
        body: jsonEncode({
          'service_id': 'service_p6uvup9',
          'template_id': 'template_qtfr8c4',
          'user_id': 'W0ctHE3uYiqHe98Rl',
          'accessToken': 'fX2do_IcXEuk9kIMc512o',
          'template_params': {'message': noteController.text.trim()},
        }),
      );

      if (response.statusCode == 200) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "تم إرسال الملاحظة بنجاح",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Color.fromARGB(255, 7, 240, 151),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(4),
          ),
        );
        noteController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("هناك مشكلة في الاتصال"),
            backgroundColor: Colors.redAccent,
          ),
        );
        print("EmailJS Server Error: ${response.body}");
        throw Exception('فشل السيرفر في المعالجة');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("there is problem : $e"),
        ),
      );
    }
  }

  //send rate function:
  Future<void> sendRating(int rate) async {
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'service_id': 'service_p6uvup9',
          'template_id': 'template_z1b9iw6',
          'user_id': 'W0ctHE3uYiqHe98Rl',
          'accessToken': 'fX2do_IcXEuk9kIMc512o',
          'template_params': {'stars': rate},
        }),
      );
      if (response.statusCode == 200) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "شكرا لتقييمك لنا",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Color.fromARGB(255, 240, 139, 7),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(4),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("هناك مشكلة في الاتصال"),
            backgroundColor: Colors.redAccent,
          ),
        );
        print("EmailJS Server Error: ${response.body}");
        throw Exception('فشل السيرفر في المعالجة');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("there is problem : $e"),
        ),
      );
    }
  }

  // rateUs function:
  void showRatingDialog(BuildContext context) {
    double selectedRating = 3.0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "قم بتقييمنا لمساعدتنا في تطوير ${ConstTexts.appName}",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 20),

              RatingBar.builder(
                initialRating: selectedRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star_rounded,
                  color: Color.fromARGB(255, 240, 139, 7),
                ),
                onRatingUpdate: (rating) {
                  selectedRating = rating;
                },
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ConstColors.mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                int finalStarsCount = selectedRating.toInt();
                Navigator.pop(context);
                sendRating(finalStarsCount);
              },
              child: const Text(
                "إرسال التقييم",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إلغاء", style: TextStyle(color: Colors.grey)),
            ),
          ],
        );
      },
    );
  }

  //share app function:
  void shareApp() async {
    // نص الرسالة اللي هيتبعت للمستخدمين على الواتساب أو غيره
    String message =
        "تطبيق ${ConstTexts.appName}  | صدقة جارية، أذكار، وأدعية وميزات بدون إعلانات.\n"
        "حمل التطبيق الآن وساهم في نشره:\n"
        "https://play.google.com/store/apps/details?id=com.yourcompany.zad_almuslim"; // استبدل ده بلينك تطبيقك الحقيقي

    // سطر واحد سحري بيفتح قائمة المشاركة بتاعة الموبايل
    await SharePlus.instance.share(ShareParams(text: message));
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = widget.currentMode == ThemeMode.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const MyAppbar(pageName: "الإعدادات", showDrawer: false),
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            // لا تنسونا من صالح دعائكم
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: ConstColors.mainGradientColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, -4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: const Text(
                  "لا تنسونا من صالح دعائكم",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            //bottom shape
            Positioned(
              bottom: 0,
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(ConstIcons.backgroundShape),
              ),
            ),
            SpecialBody(
              body: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 72),
                    //dark mode
                    _buildSettingTile(
                      isDark: isDark,
                      iconPath: ConstIcons.darkMode,
                      title: "الوضع المظلم",
                      subtitle: isDark ? "مفعّل" : "ملغى",
                      trailing: Switch.adaptive(
                        activeThumbColor: ConstColors.mainColor,
                        value: isDark,
                        onChanged: (bool value) {
                          widget.onThemeChanged(
                            value ? ThemeMode.dark : ThemeMode.light,
                          );
                        },
                      ),
                    ),
                    //font size
                    _buildSettingTile(
                      isDark: isDark,
                      iconPath: ConstIcons.textSize,
                      title: "حجم خط الذكر",
                      trailing: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: widget.currentFontSize,
                          dropdownColor: isDark ? Colors.black : Colors.white,
                          style: Theme.of(context).textTheme.bodySmall,
                          items: fontSizes
                              .map(
                                (size) => DropdownMenuItem(
                                  value: size,
                                  child: Text(size),
                                ),
                              )
                              .toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              widget.onFontSizeChanged(newValue!);
                            });
                          },
                        ),
                      ),
                    ),
                    //notes
                    _buildSettingTile(
                      isDark: isDark,
                      iconPath: ConstIcons.sendNotes,
                      title: "إرسال ملاحظة",
                      trailing: FilledButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                child: AlertDialog(
                                  backgroundColor: isDark
                                      ? Colors.black
                                      : Colors.white,

                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: 20,
                                    children: [
                                      TextField(
                                        controller: noteController,
                                        textInputAction:
                                            TextInputAction.newline,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        minLines: 3,
                                        autocorrect: true,
                                        autofocus: true,
                                        cursorColor: ConstColors.mainColor,

                                        decoration: InputDecoration(
                                          hintText: "ما الملاحظة ؟ ...",
                                          hintStyle: TextStyle(
                                            color: Colors.black26,
                                          ),
                                          filled: true,
                                          fillColor: ConstColors.input,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 16,
                                          ),

                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),

                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),

                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (!mounted) return;
                                          if (noteController.text
                                              .trim()
                                              .isEmpty) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text("الحقل فارغ !"),
                                                backgroundColor:
                                                    Colors.deepOrange,
                                              ),
                                            );
                                          } else {
                                            sendEmail();
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 4,
                                            ),
                                            shape: BoxShape.circle,
                                            gradient:
                                                ConstColors.mainGradientColor,
                                          ),
                                          child: Image.asset(
                                            ConstIcons.confirmSendNotes,
                                            width: 22,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: ConstColors.mainColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "كتابة ملاحظة",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    //rate us
                    _buildSettingTile(
                      isDark: isDark,
                      iconPath: ConstIcons.rateUs,
                      title: "قم بتقييمنا",
                      trailing: FilledButton(
                        onPressed: () {
                          showRatingDialog(context);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: ConstColors.mainColor,
                          foregroundColor: Colors.white,

                          padding: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 36,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "تقييم",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12,),
                        ),
                      ),
                    ),
                    //version
                    _buildSettingTile(
                      isDark: isDark,
                      title: "الإصدار: 1.0",
                      trailing: FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          backgroundColor: ConstColors.mainColor,
                          foregroundColor: Colors.white,

                          padding: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "تحديث الإصدار",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    //share
                    _buildSettingTile(
                      onTap: shareApp,
                      isDark: isDark,
                      title: "مشاركة التطبيق",
                      iconPath: ConstIcons.share,
                    ),
                    SizedBox(height: 20),
                    Opacity(
                      opacity: 0.6,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium,

                          children: [
                            TextSpan(
                              text: "تواجهكم مشكلة؟ ",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                            TextSpan(text: "يسعدنا تواصلكم معنا عبر"),
                            TextSpan(
                              text: "\"إرسال ملاحظة\"",
                              style: TextStyle(color: ConstColors.mainColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: 0.6,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Text(
                          "تقبل الله هذا العمل صدقة جارية لي ولكل من ساهم في نشره",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required bool isDark,
    String? iconPath,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      color: isDark ? Colors.black : Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: (iconPath == null || iconPath.isEmpty)
            ? null
            : Image.asset(
                iconPath,
                width: 32,
                height: 32,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.settings,
                  color: ConstColors.mainColor,
                  size: 32,
                ),
              ),
        title: Text(
          title,
          style: TextStyle(
            color: ConstColors.mainColor,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              )
            : null,
        trailing: trailing,
      ),
    );
  }
}
