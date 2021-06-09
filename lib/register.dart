import 'dart:convert';
import 'package:smartfarming_app/pages/home_app_theme.dart';
import 'package:flutter/material.dart';
import 'api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'dart:async';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var name, username, password, email, phone, landArea, serialNumber;

  int _farmerGroup;

  List _dataFarmerGroups;
  void getFarmerGroups() async {
    setState(() {
      _dataFarmerGroups = [
        {"id": 0, "name": "Pilih Kelompok Petani"}
      ];
    });
    final respose = await Network().getDataWithoutToken("/farmer-groups");
    var listData = jsonDecode(respose.body);
    setState(() {
      _dataFarmerGroups = listData['data'];
    });
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    getFarmerGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FitnessAppTheme.background,
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 90),
          child: Stack(
            children: <Widget>[
              Positioned(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextFormField(
                                style: TextStyle(color: Color(0xFF000000)),
                                cursorColor: Color(0xFF9b9b9b),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.account_circle,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Nama Lengkap",
                                  hintStyle: TextStyle(
                                      color: Color(0xFF9b9b9b),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (nameValue) {
                                  if (nameValue.isEmpty) {
                                    return 'Masukan nama lengkap';
                                  }
                                  name = nameValue;
                                  return null;
                                },
                              ),
                              TextFormField(
                                style: TextStyle(color: Color(0xFF000000)),
                                cursorColor: Color(0xFF9b9b9b),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Username",
                                  hintStyle: TextStyle(
                                      color: Color(0xFF9b9b9b),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (usernameValue) {
                                  if (usernameValue.isEmpty) {
                                    return 'Masukan username';
                                  }
                                  username = usernameValue;
                                  return null;
                                },
                              ),
                              TextFormField(
                                style: TextStyle(color: Color(0xFF000000)),
                                cursorColor: Color(0xFF9b9b9b),
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                      color: Color(0xFF9b9b9b),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (passwordValue) {
                                  if (passwordValue.isEmpty) {
                                    return 'Masukan password';
                                  }
                                  password = passwordValue;
                                  return null;
                                },
                              ),
                              TextFormField(
                                style: TextStyle(color: Color(0xFF000000)),
                                cursorColor: Color(0xFF9b9b9b),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Email",
                                  hintStyle: TextStyle(
                                      color: Color(0xFF9b9b9b),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (emailValue) {
                                  if (emailValue.isEmpty) {
                                    return 'Please enter email';
                                  }
                                  email = emailValue;
                                  return null;
                                },
                              ),
                              TextFormField(
                                style: TextStyle(color: Color(0xFF000000)),
                                cursorColor: Color(0xFF9b9b9b),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Telepon",
                                  hintStyle: TextStyle(
                                      color: Color(0xFF9b9b9b),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (phoneValue) {
                                  if (phoneValue.isEmpty) {
                                    return 'Masukan nomor telepon';
                                  }
                                  phone = phoneValue;
                                  return null;
                                },
                              ),
                              TextFormField(
                                style: TextStyle(color: Color(0xFF000000)),
                                cursorColor: Color(0xFF9b9b9b),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.image,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Luas Lahan",
                                  hintStyle: TextStyle(
                                      color: Color(0xFF9b9b9b),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (landAreaValue) {
                                  if (landAreaValue.isEmpty) {
                                    return 'Masukan luas lahan';
                                  }
                                  landArea = landAreaValue;
                                  return null;
                                },
                              ),
                              TextFormField(
                                style: TextStyle(color: Color(0xFF000000)),
                                cursorColor: Color(0xFF9b9b9b),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.vpn_key,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Serial Number",
                                  hintStyle: TextStyle(
                                      color: Color(0xFF9b9b9b),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (serialNumberValue) {
                                  if (serialNumberValue.isEmpty) {
                                    return 'Masukan serial number';
                                  }
                                  serialNumber = serialNumberValue;
                                  return null;
                                },
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: FitnessAppTheme.background,
                                ),
                                padding: EdgeInsets.only(left: 0.0),
                                margin: EdgeInsets.only(top: 7.0, right: 4.0),
                                child: DropdownButton(
                                  hint: Text("Pilih Kelompok Petani"),
                                  isExpanded: true,
                                  value: _farmerGroup,
                                  items: _dataFarmerGroups.map((item) {
                                    return DropdownMenuItem(
                                      child: Text(item['name']),
                                      value: item['id'],
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _farmerGroup = value;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              SizedBox(
                                  height: 50,
                                  width: double.infinity,
                                  child: FlatButton(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 8,
                                          bottom: 8,
                                          left: 10,
                                          right: 10),
                                      child: Text(
                                        _isLoading ? 'Loading...' : 'Register',
                                        textDirection: TextDirection.ltr,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          decoration: TextDecoration.none,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    color: FitnessAppTheme.nearlyDarkBlue,
                                    disabledColor: Colors.grey,
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0)),
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        _register();
                                      }
                                    },
                                  ))
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => Login()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(margin: EdgeInsets.only(bottom: 100)),
                                Text(
                                  "Already have an Account ? ",
                                  style: TextStyle(
                                      color: FitnessAppTheme.darkText),
                                ),
                                GestureDetector(
                                  // onTap: press,
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(
                                      color: FitnessAppTheme.nearlyDarkBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          color: FitnessAppTheme.background,
        ),
      ),
    );
  }

  void showMessageDialog(title, message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _register() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'name': name,
      'username': username,
      'password': password,
      'email': email,
      'phone': phone,
      'land_area': landArea,
      'serial_number': serialNumber,
      'farmer_group_id': _farmerGroup
    };

    var res = await Network().authData(data, '/register');
    var body = json.decode(res.body);
    if (body['success']) {
      showMessageDialog("Registrasi Berhasil!",
          "Anda sudah berhasil registrasi, silahkan login!");
    } else {
      if (body['messages']['username'] != null) {
        _showMsg(body['messages']['username'][0]);
      } else {
        if (body['messages']['email'] != null) {
          _showMsg(body['messages']['email'][0]);
        } else {
          if (body['messages']['land_area'] != null) {
            _showMsg(body['messages']['land_area'][0]);
          } else {
            if (body['messages']['serial_number'] != null) {
              _showMsg(body['messages']['serial_number'][0]);
            }
          }
        }
      }
    }
    setState(() {
      _isLoading = false;
    });
  }
}
