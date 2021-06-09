import 'dart:convert';

import 'package:smartfarming_app/api/api.dart';
import 'package:smartfarming_app/main.dart';
import 'package:smartfarming_app/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home_app_theme.dart';

class ProfileView extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;

  const ProfileView({Key key, this.animationController, this.animation})
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
                margin: EdgeInsets.only(top: 90),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/smartfarming/user_pic.png',
                        height: 100,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ProfileState()
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProfileState extends StatefulWidget {
  const ProfileState({Key key}) : super(key: key);

  @override
  _ProfileStateState createState() => _ProfileStateState();
}

class _ProfileStateState extends State<ProfileState> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        logout();
      },
      child: Text(
        "Logout",
        style: TextStyle(color: Colors.white),
      ),
      color: FitnessAppTheme.nearlyDarkBlue,
      minWidth: 100,
      height: 40,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
    );
  }

  void logout() async {
    var res = await Network().getData('/logout');
    var body = jsonDecode(res.body);

    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }
}
