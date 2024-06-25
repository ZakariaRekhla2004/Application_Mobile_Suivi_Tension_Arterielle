import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_front/screens/Appointment/addAppointment.dart';
import 'package:flutter_front/screens/ExamTension/ExamTension.dart';
import 'package:flutter_front/screens/Medicaments/alarmreminder.dart';
import 'package:flutter_front/screens/home/views/home.dart';
// import 'package:flutter_front/screens/AlarmScreen.dart'; // Ensure you import the AlarmScreen

class Routes {
  static const String home = '/';
  static const String examTension = '/exam_tension';
  static const String appointment = '/appointment';
  static const String alarmScreen = '/alarm_screen'; // Define the route for AlarmScreen

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => Home());
      case examTension:
        return MaterialPageRoute(builder: (_) => TensionExam());
      case appointment:
        return MaterialPageRoute(builder: (_) => Appointment(0));
      case alarmScreen:
        final args = settings.arguments as AlarmSettings;
        return MaterialPageRoute(builder: (_) => AlarmScreen(alarmSettings: args));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}