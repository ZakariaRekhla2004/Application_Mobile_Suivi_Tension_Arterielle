import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_front/components/DatePicker.dart';
import 'package:flutter_front/api/auth.dart';
import 'package:flutter_front/components/TimePicker.dart';
import 'package:flutter_front/components/TextField.dart';
import 'package:flutter_front/components/loginWidgets/ButtonWidget.dart';
import 'package:flutter_front/screens/ExamTension/ExamDisplay.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateTension extends StatefulWidget {
  final String examId;

  UpdateTension(this.examId);

  @override
  _UpdateTensionState createState() => _UpdateTensionState();
}

class _UpdateTensionState extends State<UpdateTension> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late TextEditingController systoliqueController;
  late TextEditingController diastoliqueController;
  late TextEditingController dateExamenController;
  late TextEditingController heureExamenController;
  late double systolique;
  late double diastolique;

  @override
  void initState() {
    super.initState();
    systoliqueController = TextEditingController();
    diastoliqueController = TextEditingController();
    dateExamenController = TextEditingController();
    heureExamenController = TextEditingController();
    // Fetch existing exam details and populate the controllers
    _fetchExamDetails();
  }

  void _fetchExamDetails() async {
    var res = await Network().getData('/TensionExam/getTension_Examid?id=${widget.examId}');
    var body = json.decode(res.body);
    print(body);
    if (res.statusCode == 200) {
      dynamic exams = body['TensionExam'];
      setState(() {
        systoliqueController.text = exams['Systolique'].toString();
        diastoliqueController.text = exams['Diastolique'].toString();
        dateExamenController.text = exams['date_Examen'];
        heureExamenController.text = convert24HourTo12Hour(exams['heure_Examen']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (dateExamenController.text == "") {
      dateExamenController.text =
          DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
    return Scaffold(
      backgroundColor: Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Update Blood Pressure Exam",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: ListView(
            children: [
              Text(
                'Systolique : ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text_Field(
                label: 'Systolique ',
                hint: 'Enter Systolique',
                isPassword: false,
                keyboard: TextInputType.number,
                txtEditController: systoliqueController,
                onChanged: (value) {
                  systoliqueController.text = value;
                },
              ),
              const SizedBox(height: 10),
              Container(
                  margin: const EdgeInsets.all(10),
                  width: double.infinity,
                  height: 2,
                  color: Color.fromARGB(255, 50, 70, 87)),
              const SizedBox(height: 10),
              Text(
                'Diastolique :',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text_Field(
                label: 'Diastolique',
                hint: 'Enter Diastolique',
                isPassword: false,
                keyboard: TextInputType.number,
                txtEditController: diastoliqueController,
                onChanged: (value) {
                  diastoliqueController.text = value;
                },
              ),
              const SizedBox(height: 10),
              Container(
                  margin: const EdgeInsets.all(10),
                  width: double.infinity,
                  height: 2,
                  color: Color.fromARGB(255, 50, 70, 87)),
              const SizedBox(height: 10),
              Text(
                'Date Examen :',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              DatePickerField(
                label: 'Date of Examen',
                hint: 'Select Date of Birth',
                txtEditController: dateExamenController,
                initialValue: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                onChanged: (value) {
                  dateExamenController.text = value;
                },
              ),
              const SizedBox(height: 20),
              TimePickerField(
                label: 'Heure Examen',
                hint: 'Enter heure Examen',
                txtEditController: heureExamenController,
                onChanged: (value) {
                  heureExamenController.text = value;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.42,
                height: 55,
                child: CustomButton(
                  onPressed: () {
                    _updateExam();
                  },
                  title: _isLoading ? 'Is Sending...' : 'Update Exam',
                  color: Colors.blue.shade900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String convert12HourTo24Hour(String time) {
    final inputFormat = DateFormat('h:mm a');
    final outputFormat = DateFormat('HH:mm:ss');
    final timeObj = inputFormat.parse(time);
    final formattedTime = outputFormat.format(timeObj);
    return formattedTime;
  }
  String convert24HourTo12Hour(String time) {
  final inputFormat = DateFormat('HH:mm:ss');
  final outputFormat = DateFormat('h:mm a');
  final timeObj = inputFormat.parse(time);
  final formattedTime = outputFormat.format(timeObj);
  return formattedTime;
}

  _updateExam() async {
    setState(() {
      _isLoading = true;
    });
    String twentyFourHourTime =
        convert12HourTo24Hour(heureExamenController.text);
    var data = {
      "Systolique": int.parse(systoliqueController.text),
      "Diastolique": int.parse(diastoliqueController.text),
      "date_Examen": dateExamenController.text,
      "heure_Examen": twentyFourHourTime
    };
    var res = await Network().updateData(data, '/TensionExam/updateTension_Exam?id=${widget.examId}');
    var body = json.decode(res.body);

    if (res.statusCode == 201) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DisplayTension()),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }
}
