import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_front/api/auth.dart';
import 'package:flutter_front/components/loginWidgets/ButtonWidget.dart';
import 'package:flutter_front/components/loginWidgets/HeaderGlobal.dart';
import 'package:flutter_front/components/loginWidgets/HeaderLogin.dart';
import 'package:flutter_front/components/loginWidgets/InputField.dart';
import 'package:flutter_front/screens/auth/view/Login.dart';

class Forgetpassword extends StatefulWidget {
  @override
  _ForgetpasswordState createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();

    super.dispose();
  }

  Future<void> _registerUser() async {
    if (passwordController.text == phoneNumberController.text) {
      var data = {
        'email': emailController.text,
        'password': passwordController.text,
        // 'phone_number': phoneNumberController.text,
      };
      print(data);
      var res = await Network().authData(data, '/auth/forgetPassword');
      var body = jsonDecode(res.body);
      print(body);
      if (res.statusCode == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
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
              title: "Forget Password",
              subtitle: "Please don't worry about your password"),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        InputField(
                          hintText: "Email ",
                          controller: emailController,
                          onChanged: (value) {
                            emailController.text = value;
                          },
                        ),
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
                          controller: phoneNumberController,
                          onChanged: (value) {
                            phoneNumberController.text = value;
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
