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
  int? selectedHour;

  Future<void> _selectHour(BuildContext context) async {
    int? pickedHour = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return _HourPickerDialog();
      },
    );

    if (pickedHour != null && pickedHour != selectedHour) {
      setState(() {
        selectedHour = pickedHour;
      });
      String hourString = pickedHour.toString().padLeft(2, '0') + ":00";
      widget.txtEditController.text = hourString;
      widget.onChanged(hourString);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2.0,
      ),
      child: InkWell(
        onTap: () => _selectHour(context),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 1,
          color: Color.fromARGB(255, 210, 233, 238),
          child: Center(
            child: SizedBox(
              height: 50,
              width: 160,
              child: Center(
                child: Text(
                  selectedHour != null
                      ? selectedHour!.toString().padLeft(2, '0') + ":00"
                      : widget.hint,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
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

class _HourPickerDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Hour',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(13, (index) {
                  int hour = 8 + index; // Hours from 8 to 20
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(hour);
                      },
                      child: Text(hour.toString().padLeft(2, '0')),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
