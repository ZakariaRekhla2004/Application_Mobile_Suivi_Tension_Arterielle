import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSelectField extends StatelessWidget {
  const CustomSelectField({
    Key? key,
    required this.label,
    required this.hint,
    required this.items,
    required this.onChanged,
    required this.selectedValue,
  }) : super(key: key);

  final String label;
  final String hint;
  final List<String> items;
  final void Function(String?) onChanged;
  final String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      onChanged: onChanged,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Color.fromARGB(255, 210, 233, 238),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          borderSide: BorderSide(
            color: Color.fromARGB(255, 7, 82, 96),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
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
          fontSize: 14,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      ),
    );
  }
}
