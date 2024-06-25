// ignore_for_file: file_names
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  final String subtitle;

  const Header({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: TextStyle(color: Colors.white, fontSize: 40)),
          SizedBox(height: 10),
          Text(subtitle, style: TextStyle(color: Colors.white, fontSize: 18)),
        ],
      ),
    );
  }
}

