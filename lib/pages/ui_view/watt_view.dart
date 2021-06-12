import 'package:smartfarming_app/pages/home_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class WattView extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;

  const WattView({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: FitnessAppTheme.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FitnessAppTheme.grey.withOpacity(0.2),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ChartView extends StatelessWidget {
  final Widget series;
  const ChartView({Key key, this.series}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currDt = DateTime.now();
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 140, left: 10),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Text("Garfik Penggunaan Watt Tahun ${currDt.year}"),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              child: series,
              height: 250,
            ),
          ],
        ),
      ),
    );
  }
}
