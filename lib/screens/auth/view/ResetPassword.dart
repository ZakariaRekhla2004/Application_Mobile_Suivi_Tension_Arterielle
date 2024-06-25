import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_front/api/auth.dart';
import 'package:flutter_front/components/loginWidgets/ButtonWidget.dart';
import 'package:flutter_front/components/loginWidgets/HeaderGlobal.dart';
import 'package:flutter_front/components/loginWidgets/HeaderLogin.dart';
import 'package:flutter_front/components/loginWidgets/InputField.dart';
import 'package:flutter_front/screens/auth/view/CompleteDossier.dart';
import 'package:flutter_front/screens/auth/view/Login.dart';
import 'package:flutter_front/screens/home/views/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  Future<void> _registerUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if (passwordController.text == confirmPasswordController.text) {

      var data = {
        'id':jsonDecode(localStorage.getString("id")!),
        'password': passwordController.text,
      };
      // print(data);

      var res = await Network().authData(data, '/auth/forgetPassword');
      var body = jsonDecode(res.body);
      // print(body);
print(localStorage.getString('status'));
      if (res.statusCode == 201) {
        if (localStorage.getString('status')== 'Completed') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
          
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CompleteDossier()),
          );
        }
        // Navigator.push(context, route)
      } else {
        // Handle errors
        print('Error: ${res.reasonPhrase}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return HeaderGlobal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20),
          Header(
              title: "Reset Password", subtitle: "Secure Your Account Access"),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(80),
                  topRight: Radius.circular(80),
                  bottomLeft: Radius.circular(80),
                  bottomRight: Radius.circular(80),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      "assets/Reset password-bro.png", // Adjust the image path
                      width: 300, // Adjust the image width as needed
                      height: 300, // Adjust the image height as needed
                      fit: BoxFit.cover,
                    ),
                    Column(
                      children: <Widget>[
                        InputField(
                          hintText: "Password",
                          obscureText: true,
                          controller: passwordController,
                          onChanged: (value) {
                            passwordController.text = value;
                            // Handle password input changes
                          },
                        ),
                        InputField(
                          hintText: "Confirm Password",
                          obscureText: true,
                          controller: confirmPasswordController,
                          onChanged: (value) {
                            confirmPasswordController.text = value;
                            // Handle password input changes
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    CustomButton(
                      title: "Save",
                      onPressed: () {
                        _registerUser();
                      },
                      color: const Color.fromARGB(255, 4, 27, 46),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
