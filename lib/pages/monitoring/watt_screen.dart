import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartfarming_app/api/api.dart';
import 'package:smartfarming_app/pages/ui_view/dashboard_view.dart';
import 'package:smartfarming_app/pages/ui_view/watt_view.dart';
import 'package:smartfarming_app/pages/ui_view/title_view.dart';
import 'package:smartfarming_app/pages/ui_view/dashboard_view.dart';
import 'package:smartfarming_app/pages/home_app_theme.dart';
import 'package:smartfarming_app/pages/home/water_view.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class WattScreen extends StatefulWidget {
  const WattScreen({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;
  @override
  _WattScreenState createState() => _WattScreenState();
}

class _WattScreenState extends State<WattScreen> with TickerProviderStateMixin {
  Animation<double> topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  List _dataWatt;
  String serialNumber;
  String jan = "0.00",
      feb = "0.00",
      mar = "0.00",
      apr = "0.00",
      may = "0.00",
      jun = "0.00",
      jul = "0.00",
      aug = "0.00",
      sep = "0.00",
      oct = "0.00",
      nov = "0.00",
      dec = "0.00";

  void getWattGraphics() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString("user"));
    if (user != null) {
      setState(() {
        serialNumber = user['serial_number'];
      });
    }

    var response =
        await Network().getData('/watt/$serialNumber/get-watt-graphics');
    var data = jsonDecode(response.body);
    setState(() {
      _dataWatt = data['data'];
    });

    for (var i = 0; i < _dataWatt.length; i++) {
      setState(() {
        if (_dataWatt[i]['bulan'] != null) {
          if (_dataWatt[i]['bulan'] == 'Jan') {
            jan = _dataWatt[i]['power'];
          } else if (_dataWatt[i]['bulan'] == 'Feb') {
            feb = _dataWatt[i]['power'];
          } else if (_dataWatt[i]['bulan'] == 'Mar') {
            mar = _dataWatt[i]['power'];
          } else if (_dataWatt[i]['bulan'] == 'Apr') {
            apr = _dataWatt[i]['power'];
          } else if (_dataWatt[i]['bulan'] == 'May') {
            may = _dataWatt[i]['power'];
          } else if (_dataWatt[i]['bulan'] == 'Jun') {
            jun = _dataWatt[i]['power'];
          } else if (_dataWatt[i]['bulan'] == 'Jul') {
            jul = _dataWatt[i]['power'];
          } else if (_dataWatt[i]['bulan'] == 'Aug') {
            aug = _dataWatt[i]['power'];
          } else if (_dataWatt[i]['bulan'] == 'Sep') {
            sep = _dataWatt[i]['power'];
          } else if (_dataWatt[i]['bulan'] == 'Oct') {
            oct = _dataWatt[i]['power'];
          } else if (_dataWatt[i]['bulan'] == 'Nov') {
            nov = _dataWatt[i]['power'];
          } else if (_dataWatt[i]['bulan'] == 'Dec') {
            dec = _dataWatt[i]['power'];
          }
        }
      });
    }
  }

  @override
  void initState() {
    getWattGraphics();
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  void addAllListData() {
    const int count = 9;

    listViews.add(
      WattView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 5, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var data = [
      Watt("Jan", jan),
      Watt("Feb", feb),
      Watt("Mar", mar),
      Watt("Apr", apr),
      Watt("Mei", may),
      Watt("Jun", jun),
      Watt("Jul", jul),
      Watt("Aug", aug),
      Watt("Sep", sep),
      Watt("Oct", oct),
      Watt("Nov", nov),
      Watt("Dec", dec),
    ];

    var series = [
      charts.Series(
          domainFn: (Watt watt, _) => watt.month,
          measureFn: (Watt watt, _) => double.parse(watt.watt),
          id: 'Watt',
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xFF2633C5)),
          data: data,
          labelAccessorFn: (Watt watt, _) => '${watt.watt} W'),
    ];

    var chart = charts.BarChart(
      series,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
    );
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            ChartView(
              series: chart,
            ),
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: FitnessAppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: FitnessAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Penggunaan Watt',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: FitnessAppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

class Watt {
  final String month;
  final String watt;

  Watt(this.month, this.watt);
}
