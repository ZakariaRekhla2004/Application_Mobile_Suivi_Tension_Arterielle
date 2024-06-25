import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_front/Firebase/service.dart';
import 'package:flutter_front/api/auth.dart';
import 'package:flutter_front/components/loginWidgets/ButtonWidget.dart';
import 'package:flutter_front/components/loginWidgets/HeaderGlobal.dart';
import 'package:flutter_front/components/loginWidgets/HeaderLogin.dart';
import 'package:flutter_front/components/loginWidgets/InputField.dart';
import 'package:flutter_front/screens/auth/ForgetPassword.dart';
import 'package:flutter_front/screens/auth/view/CompleteDossier.dart';
import 'package:flutter_front/screens/auth/view/ResetPassword.dart';
import 'package:flutter_front/screens/home/views/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Login> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HeaderGlobal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20),
          Header(title: "Login", subtitle: "Welcome Back"),
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
                    Image.asset(
                      "assets/Doctors-pana.png",
                      width: 300,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    Column(
                      children: <Widget>[
                        InputField(
                          hintText: "Email",
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
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Forgetpassword(),
                          ),
                        );
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    CustomButton(
                      title: _isLoading ? 'Processing...' : 'Login',
                      onPressed: () {
                        _login();
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

  void _login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email and Password cannot be empty'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    var data = {
      'email': emailController.text,
      'password': passwordController.text
    };
  final authService = AuthService();
   
   
    try {
    print('Signed in successfully');

    await authService.signInWithEmailPassword1(
      emailController.text,
      passwordController.text,
    );
    print('Signed in successfully');
  } catch (e) {
    try {
      print(emailController.text);
      await authService.createUserWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
      print('User created successfully');
    } catch (e) {
      print('Failed to create user: $e');
    }
  }
    try {
      var res = await Network().authData(data, '/auth/login');
      var body = json.decode(res.body);

      if (res.statusCode == 200) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', json.encode(body['token']));
        localStorage.setString('token1', json.encode(body['token']));
        localStorage.setString('user', json.encode(body['user']));
        localStorage.setString('email', json.encode(body['email']));
        localStorage.setString('status', json.encode(body['status']));
        localStorage.setString('id', json.encode(body['_id']));

        if (json.encode(body['resetpassword']) == 'false') {
          if (localStorage.getString('status') != "Completed") {
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
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ResetPassword()),
          );
        }
      } else if (res.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unauthorized: Invalid email or password'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${res.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }
}
