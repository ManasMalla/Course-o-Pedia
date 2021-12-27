import 'package:course_o_pedia/topic_details.dart';
import 'package:course_o_pedia/size_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CourseDetailsScreen extends StatefulWidget {
  final Function() onToggleTheme;
  final ThemeMode themeMode;
  final List<TopicDetails> topicDetails;
  const CourseDetailsScreen(
      {Key? key,
      required this.onToggleTheme,
      required this.themeMode,
      required this.topicDetails})
      : super(key: key);

  @override
  _CourseDetailsScreenState createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  var indicator = 0;
  var pageController = PageController(initialPage: 0);
  var isPageReady = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        isPageReady = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.chevron_left_rounded),
                splashRadius: getProportionalScreenHeight(24),
              )
            : null,
        title: Text(
          "Topic 1",
          style: TextStyle(fontFamily: "Poppins"),
        ),
        centerTitle: false,
        actions: [
          Container(
            decoration:
                BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            height: getProportionalScreenHeight(64),
            width: getProportionalScreenHeight(64),
            margin: EdgeInsets.symmetric(
                horizontal: getProportionalScreenWidth(32)),
            child: IconButton(
              onPressed: () {
                widget.onToggleTheme();
              },
              icon: Icon(
                widget.themeMode == ThemeMode.light
                    ? Icons.dark_mode_rounded
                    : Icons.light_mode_rounded,
                color: Colors.grey.shade800,
              ),
              splashRadius: getProportionalScreenHeight(32),
              iconSize: getProportionalScreenHeight(48),
              padding: EdgeInsets.all(0),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding:
                EdgeInsets.symmetric(vertical: getProportionalScreenHeight(30)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _indicators(
                  indicator, widget.topicDetails.length, widget.themeMode),
            ),
          ),
          Flexible(
            child: PageView(
              controller: pageController,
              onPageChanged: (value) {
                setState(() {
                  indicator = value;
                });
              },
              children:
                  getTopicDetailScreens(widget.topicDetails, widget.themeMode),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  style: widget.themeMode == ThemeMode.light
                      ? ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  getProportionalScreenHeight(54))),
                          primary: Colors.white,
                          onPrimary: const Color(0xFF1b2272),
                        )
                      : ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  getProportionalScreenHeight(54))),
                        ),
                  onPressed: () {
                    pageController.animateToPage(indicator - 1,
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeInOut);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.chevron_left_rounded),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionalScreenWidth(20)),
                        child: Text("Back"),
                      ),
                    ],
                  )),
              ElevatedButton(
                  onPressed: () {
                    pageController.animateToPage(indicator + 1,
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeInOut);
                  },
                  style: widget.themeMode == ThemeMode.light
                      ? ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  getProportionalScreenHeight(54))),
                          primary: Colors.white,
                          onPrimary: const Color(0xFF1b2272),
                        )
                      : ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  getProportionalScreenHeight(54))),
                        ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionalScreenWidth(20)),
                        child: Text("Next"),
                      ),
                      Icon(Icons.chevron_right_rounded),
                    ],
                  ))
            ],
          ),
          SizedBox(
            height: getProportionalScreenHeight(48),
          )
        ],
      ),
    );
  }
}

List<Widget> getTopicDetailScreens(List<TopicDetails> details, ThemeMode mode) {
  List<Widget> widgets = [];
  for (var item in details) {
    widgets.add(
      SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(getProportionalScreenHeight(32)),
          child: Column(
            children: [
              SizedBox(
                height: getProportionalScreenHeight(420),
                child: Image.network(item.image),
              ),
              SizedBox(
                height: getProportionalScreenHeight(48),
              ),
              Text(
                item.title,
                style: TextStyle(
                    fontSize: getProportionalScreenHeight(45),
                    color: mode == ThemeMode.light
                        ? Color(0xFF1b2272)
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins"),
              ),
              SizedBox(
                height: getProportionalScreenHeight(60),
              ),
              Text(
                item.description,
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: getProportionalScreenHeight(27),
                    fontWeight: FontWeight.w500,
                    color: mode == ThemeMode.light
                        ? Colors.grey.shade700
                        : Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
  return widgets;
}

Widget _indicator(bool isIndexed, double width, ThemeMode mode) {
  print(isIndexed);
  var inactiveColor =
      mode == ThemeMode.light ? Colors.black : Colors.grey.shade700;
  return Container(
    height: getProportionalScreenHeight(6),
    width: width,
    color: !isIndexed ? inactiveColor : const Color(0xFFc5cae8),
  );
}

List<Widget> _indicators(int progress, int number, ThemeMode mode) {
  List<Widget> indicators = [];
  var paddingWidth = (number + 1) * getProportionalScreenWidth(18);
  var width = (getProportionalScreenWidth(738) - paddingWidth) / number;
  for (var i = 0; i < number; i++) {
    indicators.add(_indicator(i <= progress, width, mode));
  }
  return indicators;
}
