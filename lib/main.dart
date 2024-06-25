// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'dart:convert';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_front/firebase_options.dart';
import 'package:flutter_front/screens/Medicaments/alarmreminder.dart';
import 'package:flutter_front/screens/auth/view/Login.dart';
import 'package:flutter_front/screens/auth/view/ResetPassword.dart';
import 'package:flutter_front/screens/home/views/home.dart';
import 'package:flutter_front/utils/Routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_front/firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



import 'package:shared_preferences/shared_preferences.dart';
// import './screens/auth/';
// import 'firebase_options.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test App',
      debugShowCheckedModeBanner: false,
      home: CheckAuth(),
      onGenerateRoute: Routes.generateRoute,
    );
  }
}

class CheckAuth extends StatefulWidget {
  const CheckAuth({super.key});

  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;

  bool comp = false;
late Timer _logoutTimer;

@override
void initState() {
  _checkIfLoggedIn();
  super.initState();
   _configureSelectNotificationSubject();
}

@override
void dispose() {
  _logoutTimer.cancel(); // Cancel the timer when the widget is disposed
  super.dispose();
}
  void _configureSelectNotificationSubject() {
    flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('app_icon'),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null) {
          Map<String, dynamic> payloadMap = jsonDecode(response.payload!);
          int alarmId = payloadMap['alarmId'];
          String notificationBody = payloadMap['notificationBody'];

          AlarmSettings alarmSettings = AlarmSettings(
            id: alarmId,
            dateTime: DateTime.now(),
            assetAudioPath: '',
            loopAudio: false,
            vibrate: false,
            notificationTitle: 'Medication Reminder',
            notificationBody: notificationBody,
            fadeDuration: 1,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlarmScreen(alarmSettings: alarmSettings),
            ),
          );
        }
      },
    );
  }

void _checkIfLoggedIn() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var token = localStorage.getString('token');
  if (token != null) {
    setState(() {
      isAuth = true;
    });
    _startLogoutTimer();
  }
}

void _startLogoutTimer() {
  var tokenExpireTime = 1440;
  
    var tokenExpireTime1 = tokenExpireTime * 60 * 1000;
    var remainingTime = tokenExpireTime1 - DateTime.now().millisecondsSinceEpoch - (5 * 60 * 1000);
    if (remainingTime > 0) {
      _logoutTimer = Timer(Duration(minutes: (remainingTime / 1000 / 60).round()), _logout);
    } else {
      _logout();
    }
 
}

void _logout() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  print(localStorage.getString('token'));
  localStorage.remove('token');
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => Login()),
  );
}
  @override
  Widget build(BuildContext context) {
    Widget child;

    if (!isAuth) {
      child = Login();
      // child = ResetPassword();
        // child = Home();
    } else {
        child = Home();
    }
    return Scaffold(
      body: child,
    );
  }
}
