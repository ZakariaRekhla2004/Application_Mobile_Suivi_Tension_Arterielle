import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_front/api/auth.dart';
import 'package:flutter_front/components/DatePicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BMI extends StatefulWidget {
  const BMI({super.key});

  @override
  State<BMI> createState() => _BMIState();
}

class _BMIState extends State<BMI> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late TextEditingController dateExamenController;

  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  

  // Define lists for dropdown options
  final List<String> weightUnits = ['kg', 'lbs'];
  final List<String> heightUnits = ['cm', 'ft'];

  // Selected values for dropdowns
  String selectedWeightUnit = 'kg';
  String selectedHeightUnit = 'cm';

  String yourBMITxt = '';
  double bmiValue = 0;
  String BMI_Value = '';
  String postComment = '';
  IconData? commentIcon;
  Color? bgColor;
  String idealWeightMessage = ''; // Variable for ideal weight message

  void calculateBMI() {
    final double doubleWeight = double.parse(_weightController.text);
    final double doubleHeight = double.parse(_heightController.text);
    // Convert units based on user's selection
    double weightInKg =
        selectedWeightUnit == 'lbs' ? doubleWeight * 0.453592 : doubleWeight;
    double heightInCm =
        selectedHeightUnit == 'ft' ? doubleHeight * 30.48 : doubleHeight;

    setState(() {
      bmiValue = weightInKg / ((heightInCm / 100) * (heightInCm / 100));
    });
  }

  void displayComment() {
    setState(() {
      yourBMITxt = "Your BMI Value is: ";
      BMI_Value = bmiValue.toStringAsFixed(3);

      if (bmiValue < 18.5) {
        bgColor = Colors.orange[300];
        commentIcon = Icons.sentiment_dissatisfied;
        postComment = "You're Underweight!";
      } else if (bmiValue < 24.9) {
        bgColor = Colors.green[300];
        commentIcon = Icons.sentiment_very_satisfied;
        postComment = "You're Healthy!";
      } else {
        bgColor = Colors.red[300];
        commentIcon = Icons.sentiment_very_dissatisfied;
        postComment = "You're Overweight!";
      }

      double height = double.parse(_heightController.text);
      // Convert units based on user's selection
      double heightInCm = selectedHeightUnit == 'ft' ? height * 30.48 : height;

      double idealWeight = 50 + 0.91 * (heightInCm - 152.4);
      idealWeightMessage = 'Ideal weight: ${idealWeight.toStringAsFixed(2)} kg';
    });
  }
 @override
  void initState() {
    super.initState();
    // systolique = "";
    // diastolique = "";
  
    dateExamenController = TextEditingController();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    dateExamenController.dispose(); 
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if( dateExamenController.text =="")
    {
      dateExamenController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'BMI Calculator',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        elevation: 5.0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Center(
          child: ListView(
            children: [
              const SizedBox(
                height: 15.0,
              ),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.asset(
                            'assets/weight-scale.gif',
                            color: const Color.fromARGB(255, 241, 250, 251),
                            colorBlendMode: BlendMode.darken,
                            height: 80.0,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.asset(
                            'assets/height.gif',
                            color: const Color.fromARGB(255, 241, 250, 251),
                            colorBlendMode: BlendMode.darken,
                            height: 80.0,
                          ),
                        ),
                      ]),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      "Body Mass Index(BMI) is a metric of body fat percentage commonly used to estimate risk levels of potential health problems.",
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _weightController,
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.roboto(
                                  height: 2,
                                  color: const Color.fromARGB(255, 16, 15, 15),
                                ),
                                cursorColor:
                                    const Color.fromARGB(255, 7, 82, 96),
                                decoration: InputDecoration(
                                  fillColor: Color.fromRGBO(210, 233, 238, 1),
                                  filled: true,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
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
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  labelText: "Weight",
                                  labelStyle: GoogleFonts.roboto(
                                    color:
                                        const Color.fromARGB(255, 16, 15, 15),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            DropdownButton<String>(
                              borderRadius: BorderRadius.circular(10),
                              dropdownColor:
                                  const Color.fromARGB(255, 220, 228, 232),
                              value: selectedWeightUnit,
                              items: weightUnits.map((String unit) {
                                return DropdownMenuItem<String>(
                                  value: unit,
                                  child: Text(unit),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedWeightUnit = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                     
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _heightController,
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.roboto(
                                  height: 2,
                                  color: const Color.fromARGB(255, 16, 15, 15),
                                ),
                                cursorColor:
                                    const Color.fromARGB(255, 7, 82, 96),
                                decoration: InputDecoration(
                                  fillColor: Color.fromRGBO(210, 233, 238, 1),

                                  filled: true,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  // fillColor: Colors.white,
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
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  labelText: "Height",
                                  labelStyle: GoogleFonts.roboto(
                                    color:
                                        const Color.fromARGB(255, 16, 15, 15),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            DropdownButton<String>(
                              value: selectedHeightUnit,
                              borderRadius: BorderRadius.circular(10),
                              dropdownColor:
                                  const Color.fromARGB(255, 220, 228, 232),
                              items: heightUnits.map((String? unit) {
                                return DropdownMenuItem<String>(
                                  value: unit,
                                  child: Text(
                                      unit ?? ''), // Ensure unit is non-null
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedHeightUnit = newValue ?? '';
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DatePickerField(
                        label: 'Date of Examen',
                        hint: 'Select Date of Birth',
                        txtEditController: dateExamenController,
                       
                        onChanged: (value) {
                          dateExamenController.text = value;
                        },
                      ),
                      ],
                     
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  //calculate button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: FilledButton(
                      onPressed: () {
                        if (_weightController.text == '') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  const Color.fromARGB(255, 7, 83, 96),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                              content: Text(
                                "Please enter your weight",
                              ),
                            ),
                          );
                        } else if (_heightController.text == '') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  const Color.fromARGB(255, 7, 83, 96),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                              content: Text(
                                "Please enter your height",
                              ),
                            ),
                          );
                        } else {
                          if (_formKey.currentState!.validate()) {
                            calculateBMI();
                            displayComment();
                            _saveExam();
                          } else {
                            // Do nothing
                          }
                        }
                      },
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                          Color.fromRGBO(13, 71, 161, 1),
                        ),
                        elevation: MaterialStatePropertyAll(2),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      child: Text(
                        _isLoading ? 'Is Sending...' : 'Calculate BMI',
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: bgColor,
                    ),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          yourBMITxt,
                          style: const TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Text(
                        // bmiValue.toStringAsFixed(3),
                        BMI_Value,
                        style: const TextStyle(
                            fontSize: 35.0, fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              commentIcon,
                              size: 35.0,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              postComment,
                              style: const TextStyle(fontSize: 20.0),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          idealWeightMessage,
                          style: const TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  _saveExam() async {
    setState(() {
      _isLoading = true;
    });
    

    var data = {
      "Poids": _weightController.text,
      'Taille': _heightController.text,
      "dateExam" : dateExamenController.text
    };
    print(data);
    var res = await Network().authData(data, '/Activite/addActivite');
    var body = json.decode(res.body);

    if (res.statusCode == 201) {
      print('aaaaaaaaaaaaaaaaaaaa');
    }

    setState(() {
      _isLoading = false;
    });
  }
}
