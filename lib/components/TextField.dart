import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class Text_Field extends StatelessWidget {
  Text_Field({
    Key? key,
    required this.label,
    required this.hint,
    required this.isPassword,
    required this.keyboard,
    required this.txtEditController,
    required this.onChanged,
    this.initialValue, 
  });

  final String label;
  final String hint;
  final bool isPassword;
  final TextInputType keyboard;
  final TextEditingController txtEditController;
  final void Function(String value) onChanged;
  final String? initialValue; 

  @override
  Widget build(BuildContext context) {
    if (initialValue != null) {
      txtEditController.text = initialValue!;
    }
    
    return TextField(
      keyboardType: keyboard,
      obscureText: isPassword,
      controller: txtEditController,
      onChanged: onChanged,
      cursorColor: const Color.fromARGB(255, 7, 82, 96),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Color.fromRGBO(210, 233, 238, 1),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              20,
            ),
          ),
          borderSide: BorderSide(
            color: Color.fromARGB(255, 7, 82, 96),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              20,
            ),
          ),
          borderSide: BorderSide(
            color: Color.fromARGB(0, 177, 34, 34),
          ),
        ),
        labelText: label,
        labelStyle: GoogleFonts.roboto(
          color: const Color.fromARGB(255, 16, 15, 15),
        ),
        hintStyle: GoogleFonts.roboto(
          fontSize: 14, // Reduced hint text size
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), // Adjust padding to reduce height
      ),
    );
  }
}
