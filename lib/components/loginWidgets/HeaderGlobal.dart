// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'package:flutter/material.dart';

class HeaderGlobal extends StatelessWidget {
  final Widget child;

  const HeaderGlobal({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.blue.shade200,
              Colors.blue.shade800,
              Colors.blue.shade400
            ],
          ),
        ),
        child: child,
      ),
    );
  }
}