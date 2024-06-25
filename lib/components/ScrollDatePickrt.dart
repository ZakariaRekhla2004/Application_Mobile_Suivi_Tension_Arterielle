import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class ScrollDatePickerField extends StatefulWidget {
  ScrollDatePickerField({
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

class _DatePickerFieldState extends State<ScrollDatePickerField> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _selectedDate = DateFormat('yyyy-MM-dd').parse(widget.initialValue!);
      widget.txtEditController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    }
  }

  void _openDatePickerDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: ScrollDatePicker(
            selectedDate: _selectedDate ?? DateTime.now(),
            locale: Locale('en'),
            onDateTimeChanged: (DateTime value) {
              setState(() {
                _selectedDate = value;
                String formattedDate = DateFormat('yyyy-MM-dd').format(value);
                widget.txtEditController.text = formattedDate;
                widget.onChanged(formattedDate);
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDatePickerDrawer(context),
      child: AbsorbPointer(
        child: TextField(
          controller: widget.txtEditController,
          readOnly: true,
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
        ),
      ),
    );
  }
}
