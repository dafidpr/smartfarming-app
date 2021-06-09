import 'package:smartfarming_app/app_theme.dart';
import 'package:flutter/material.dart';
// import 'model/homelist.dart';
import 'pages/home_screen.dart';

class IndexHomepage extends StatefulWidget {
  const IndexHomepage({Key key}) : super(key: key);

  @override
  _IndexHomepageState createState() => _IndexHomepageState();
}

class _IndexHomepageState extends State<IndexHomepage>
    with TickerProviderStateMixin {
  AnimationController animationController;
  bool multiple = true;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: HomeScreen(),
    );
  }
}
