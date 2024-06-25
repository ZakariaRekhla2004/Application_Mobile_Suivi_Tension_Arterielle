import 'dart:ffi';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_front/components/DatePicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_front/api/auth.dart';
import 'package:flutter_front/components/TimePicker.dart';
import 'package:flutter_front/components/TextField.dart';
import 'package:flutter_front/components/loginWidgets/ButtonWidget.dart';
import 'package:flutter_front/screens/ExamTension/ExamDisplay.dart';
import 'package:flutter_front/screens/home/views/home.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart'; // Add this import

class TensionExam extends StatefulWidget {
  @override
  _AddMedication2State createState() => _AddMedication2State();
}

class _AddMedication2State extends State<TensionExam> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
   File? _image;
  final ImagePicker _picker = ImagePicker();
  late TextEditingController systoliqueController;
  late TextEditingController diastoliqueController;
  late TextEditingController dateExamenController;
  late TextEditingController heureExamenController;
  late double systolique;
  late double diastolique;

  @override
  void initState() {
    super.initState();
    // systolique = "";
    // diastolique = "";
    systoliqueController = TextEditingController();
    diastoliqueController = TextEditingController();
    dateExamenController = TextEditingController();
    heureExamenController = TextEditingController();
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
          "Blood Pressure Exam",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          :  Form(
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
                // initialValue: systolique ? 0 : systolique,
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
                // initialValue: diastolique ==null ? null : diastolique,
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
                    _saveExam();
                  },
                  title: _isLoading ? 'Is Sending...' : 'Save Exam',
                  color: Colors.blue.shade900,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 5),
        child: FloatingActionButton(
          onPressed: () {
            _openCamera(); // Call the camera function
          },
          backgroundColor: Color.fromARGB(255, 50, 70, 87),
          child: Icon(Icons.camera,
              size: 30, color: Color.fromARGB(255, 203, 226, 231)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  String convert12HourTo24Hour(String time) {
  try {
    final inputFormat = DateFormat('h:mm a');
    final outputFormat = DateFormat('HH:mm:ss');
    final timeObj = inputFormat.parse(time);
    final formattedTime = outputFormat.format(timeObj);
    return formattedTime;
  } catch (e) {
    print("Error converting time: $e");
    return time; // Ou une valeur par défaut
  }
}
  _saveExam() async {
  setState(() {
    _isLoading = true;
  });
  try {
    String twentyFourHourTime = convert12HourTo24Hour(heureExamenController.text);
    var data = {
      "Systolique": int.parse(systoliqueController.text),
      "Diastolique": int.parse(diastoliqueController.text),
      "date_Examen": dateExamenController.text,
      "heure_Examen": heureExamenController.text
    };
    var res = await Network().authData(data, '/TensionExam/addTension_Exam');
    var body = json.decode(res.body);
    print(body);
    if (res.statusCode == 201) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DisplayTension()),
      );
    }
  } catch (e) {
    print("Error saving exam: $e");
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

   Future<void> _openCamera() async {
  setState(() {
    _isLoading = true;
  });
  try {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      var data = {"file": base64Encode(_image!.readAsBytesSync())};
      var res;
      var body;

      do {
        res = await Network().authData(data, '/TensionExam/ocr');
        body = json.decode(res.body);
        print(body);
        await Future.delayed(Duration(seconds: 2)); // Add a delay between retries
      } while (res.statusCode != 200);

      if (res.statusCode == 200) {
        setState(() {
          systoliqueController.text = body['Systolique'].toString();
          diastoliqueController.text = body['Diastolique'].toString();
        });
      }
    }
  } catch (e) {
    print("Error opening camera or processing OCR: $e");
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

}
