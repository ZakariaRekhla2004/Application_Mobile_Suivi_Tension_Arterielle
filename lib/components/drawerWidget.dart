import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_front/api/auth.dart';
import 'package:flutter_front/screens/Appointment/addAppointment.dart';
import 'package:flutter_front/screens/BMI/bmi.dart';
import 'package:flutter_front/screens/ExamTension/ExamDisplay.dart';
import 'package:flutter_front/screens/ExamTension/ExamTension.dart';
import 'package:flutter_front/screens/ExamTension/TensionApi.dart';
import 'package:flutter_front/screens/auth/view/Login.dart';
import 'package:flutter_front/screens/chat/chat.dart';
import 'package:flutter_front/screens/home/views/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const DrawerWidget({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late double _screenWidth;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenWidth = MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.5,
      child: Drawer(
        child: Column(
          children: [
            // Top container with custom text decoration
            Container(
              color: Color.fromARGB(255, 16, 72, 111),
              height: _screenWidth / 4,
              alignment: Alignment.center,
              child: Text(
                'BP Tracker',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black54,
                      offset: Offset(3.0, 3.0),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: Icon(Icons.home,
                        color: Color.fromARGB(255, 36, 118, 199)),
                    title: Text(
                      'Home',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person,
                        color: Color.fromARGB(255, 36, 118, 199)),
                    title: Text(
                      'Profile',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.add,
                        color: Color.fromARGB(255, 36, 118, 199)),
                    title: Text(
                      'Appointment',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Appointment(0)));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.favorite,
                        color: Color.fromARGB(255, 36, 118, 199)),
                    title: Text(
                      'Blood Pressure Exam',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DisplayTension()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.chat,
                        color: Color.fromARGB(255, 36, 118, 199)),
                    title: Text(
                      'Chat',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ChatPage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.directions_run,
                        color: Color.fromARGB(255, 36, 118, 199)),
                    title: Text(
                      'Add Activity',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => BMI()));
                  
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout,
                        color: Color.fromARGB(255, 36, 118, 199)),
                    title: Text(
                      'Logout',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      logout(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void logout(BuildContext context) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    try {
      var res = await Network().authData({}, '/auth/logout');
      var body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        localStorage.remove('user');
        localStorage.remove('token');
        localStorage.remove('token1');
        localStorage.remove('status');
        localStorage.remove('id');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        // Handle error if status code is not 200
        print('Logout failed: ${body['message']}');
      }
    } catch (e) {
      // Handle any exceptions during the network request
      print('Error occurred during logout: $e');
    }
  }
}
