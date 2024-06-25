import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_front/Firebase/service.dart';
import 'package:flutter_front/api/auth.dart';
import 'package:flutter_front/screens/auth/Profile.dart';
import 'package:flutter_front/screens/auth/view/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PopupMenuButtonWidget extends StatelessWidget {
  const PopupMenuButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.account_circle,
        color: Color.fromARGB(255, 36, 118, 199),
        size: 35,
      ),
      onSelected: (String result) {
        switch (result) {
          case 'Profile':
          
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserInfoPage()),
            );
            break;
          case 'Logout':
            logout(context); // Pass context to the logout function
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'Profile',
          child: ListTile(
            leading: Icon(Icons.person, color: Color.fromARGB(255, 36, 118, 199)),
            title: Text('Profile'),
          ),
        ),
        PopupMenuItem<String>(
          value: 'Logout',
          child: ListTile(
            leading: Icon(Icons.logout, color: Color.fromARGB(255, 36, 118, 199)),
            title: Text('Logout'),
          ),
        ),
      ],
      color: Colors.white, // Change background of menu to white
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      elevation: 8, // Add shadow effect
    );
  }

  void logout(BuildContext context) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    try {
      final authService = AuthService();
      authService.signOut();
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
