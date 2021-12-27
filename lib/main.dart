import 'dart:convert';

import 'package:course_o_pedia/topic_details.dart';
import 'package:course_o_pedia/course_details.dart';
import 'package:course_o_pedia/course_json.dart';
import 'package:course_o_pedia/size_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const CourseOPediaApp());
}

class CourseOPediaApp extends StatefulWidget {
  const CourseOPediaApp({Key? key}) : super(key: key);

  @override
  _CourseOPediaAppState createState() => _CourseOPediaAppState();
}

ThemeMode getSystemThemeMode() {
  return SchedulerBinding.instance?.window.platformBrightness == Brightness.dark
      ? ThemeMode.dark
      : ThemeMode.light;
}

class _CourseOPediaAppState extends State<CourseOPediaApp> {
  final ValueNotifier<ThemeMode> _notifier =
      ValueNotifier(getSystemThemeMode());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var window = WidgetsBinding.instance?.window;
    window?.onPlatformBrightnessChanged = () {
      _notifier.value = getSystemThemeMode();
    };
  }

  @override
  Widget build(BuildContext context) {
    var primaryColor = const Color(0xFFc5cae8);
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: _notifier,
        builder: (context, mode, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: mode,
            theme: ThemeData.light().copyWith(
              primaryColor: primaryColor,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    primary: primaryColor,
                    onPrimary: Colors.black,
                    textStyle: const TextStyle(fontFamily: "Poppins"),
                    padding: EdgeInsets.all(16)),
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: primaryColor,
                foregroundColor: Colors.black,
                iconTheme: IconThemeData(
                  color: mode == ThemeMode.light ? Colors.black : Colors.white,
                ),
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey.shade900,
                  onPrimary: Colors.white,
                  textStyle: const TextStyle(fontFamily: "Poppins"),
                  padding: EdgeInsets.all(16),
                ),
              ),
            ),
            home: LandingScreen(
              themeMode: mode,
              onToggleTheme: () {
                print("Hello");
                _notifier.value =
                    mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
              },
            ),
          );
        });
  }
}

class LandingScreen extends StatefulWidget {
  final Function() onToggleTheme;
  final ThemeMode themeMode;
  const LandingScreen(
      {Key? key, required this.onToggleTheme, required this.themeMode})
      : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  List<TopicDetails> courseDetails = [];
  @override
  void initState() {
    super.initState();

    dynamic json = jsonDecode(jsonCourse)["entries"];
    for (var item in json) {
      courseDetails
          .add(TopicDetails(item["image"], item["title"], item["description"]));
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeProvider().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Introduction to Designing",
          style: TextStyle(
              fontFamily: "Poppins",
              color: widget.themeMode == ThemeMode.light
                  ? Colors.black
                  : Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CourseDetailsScreen(
                          onToggleTheme: widget.onToggleTheme,
                          themeMode: widget.themeMode,
                          topicDetails: courseDetails,
                        )));
          },
          child: const Text("Course A"),
        ),
      ),
    );
  }
}
