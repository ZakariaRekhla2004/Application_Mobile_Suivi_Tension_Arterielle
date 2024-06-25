import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatefulWidget {
  DatePickerField({
    Key? key,
    required this.label,
    required this.hint,
    required this.txtEditController,
    required this.onChanged,
    this.initialValue, 
    
  }) : super(key: key);

  final String label;
  final String hint;
  final TextEditingController txtEditController;
  final void Function(String value) onChanged;
  final String? initialValue; 


  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}
class _DatePickerFieldState extends State<DatePickerField> {
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
       initialDate: widget.initialValue != null
        ? DateFormat('yyyy-MM-dd').parse(widget.initialValue!)
        : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        widget.txtEditController.text = formattedDate;
      }); 
      widget.onChanged(formattedDate);
    }
  }
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.txtEditController ,
      readOnly: true,
      onTap: () => _selectDate(context),
      decoration: InputDecoration(
        hintText: widget.hint,
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
        labelText: widget.label,
        labelStyle: GoogleFonts.roboto(
          color: const Color.fromARGB(255, 16, 15, 15),
        ),
        hintStyle: GoogleFonts.roboto(
          fontSize: 14,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      ),
    );
  }
}
