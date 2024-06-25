import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimePickerField extends StatefulWidget {
  TimePickerField({
    Key? key,
    required this.label,
    required this.hint,
    required this.txtEditController,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final String hint;
  final TextEditingController txtEditController;
  final void Function(String value) onChanged;

  @override
  _TimePickerFieldState createState() => _TimePickerFieldState();
}

class _TimePickerFieldState extends State<TimePickerField> {
  TimeOfDay? selectedTime;

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
      widget.txtEditController.text = picked.format(context);
      widget.onChanged(picked.format(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2.0,
      ),
      child: InkWell(
        onTap: () => _selectTime(context),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 1,
          color: Color.fromARGB(255, 210, 233, 238),
          // fillColor: Color.fromARGB(255, 210, 233, 238),

          child: Center(
            child: SizedBox(
              height: 50,
              width: 160,
              child: Center(
                child: Text(
                  selectedTime != null
                      ? selectedTime!.format(context)
                      : widget.hint,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    // letterSpacing: 3,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
