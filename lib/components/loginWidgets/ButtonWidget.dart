// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomButton extends StatelessWidget {
  final  String title;
  final VoidCallback onPressed;
  final Color color;

  const CustomButton({super.key, 
    required this.title,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      height: 50,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: Center(
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 20,
                      fontWeight: FontWeight.w600,),
        ),
      ),
    );
  }
}