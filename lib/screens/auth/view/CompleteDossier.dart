import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_front/api/auth.dart';
import 'package:flutter_front/components/DatePicker.dart';
import 'package:flutter_front/components/ScrollDatePickrt.dart';
import 'package:flutter_front/components/SelectField.dart';
import 'package:flutter_front/components/TextField.dart';
import 'package:flutter_front/components/loginWidgets/ButtonWidget.dart';
import 'package:flutter_front/screens/home/views/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompleteDossier extends StatefulWidget {
  @override
  _CompleteDossierState createState() => _CompleteDossierState();
}

class _CompleteDossierState extends State<CompleteDossier> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late TextEditingController weightController;
  late TextEditingController heightController;
  late TextEditingController genderController;
  late TextEditingController cityController;
  late TextEditingController maritalStatusController;
  late TextEditingController dateOfBirthController;
  late TextEditingController familyHistoryController;
  late TextEditingController personalHistoryController;
  @override
  void initState() {
    super.initState();

    weightController = TextEditingController();
    heightController = TextEditingController();
    genderController = TextEditingController();
    cityController = TextEditingController();
    maritalStatusController = TextEditingController();
    dateOfBirthController = TextEditingController();
    familyHistoryController = TextEditingController();
    personalHistoryController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Complete the Medecal Folder',
          style: TextStyle(
            color: Color.fromARGB(255, 28, 89, 151),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        // elevation: 5,
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: ListView(
            children: [
              const SizedBox(height: 5),
              Row(
                children: [
                   
                  Expanded(
                   
                    child: buildTextField('Weight', 'Enter Weight',
                        weightController, TextInputType.number),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: buildTextField('Height', 'Enter Height',
                        heightController, TextInputType.number),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              buildTextField(
                  'City', 'Enter City', cityController, TextInputType.text),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: CustomSelectField(
                      label: 'Marital Status',
                      hint: 'Select an option',
                      items: ['Single', 'Married', 'Other'],
                      onChanged: (value) {
                        maritalStatusController.text = value!;
                      },
                      selectedValue: null,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CustomSelectField(
                      label: 'Gender',
                      hint: 'Select Gender',
                      items: ['Male', 'Female', 'Other'],
                      onChanged: (value) {
                        genderController.text = value!;
                      },
                      selectedValue: null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              ScrollDatePickerField(
                label: 'Date of Birth',
                hint: 'Select Date of Birth',
                txtEditController: dateOfBirthController,
                onChanged: (value) {
                  dateOfBirthController.text = value;
                },
              ),
              const SizedBox(height: 15),
              buildTextField('Family History', 'Enter Family History',
                  familyHistoryController, TextInputType.text),
              const SizedBox(height: 15),
              buildTextField('Personal History', 'Enter Personal History',
                  personalHistoryController, TextInputType.text),
              const SizedBox(height: 15),
              const SizedBox(height: 20),
              buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, String hint,
      TextEditingController controller, TextInputType keyboard) {
    return Text_Field(
      label: label,
      hint: hint,
      isPassword: false,
      keyboard: keyboard,
      txtEditController: controller,
      onChanged: (value) {
        controller.text = value;
      },
    );
  }

  Widget buildSubmitButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.42,
      height: 55,
      child: CustomButton(
        onPressed: _saveExam,
        title: _isLoading ? 'Is Sending...' : 'Save The Folder',
        color: Colors.blue.shade900,
      ),
    );
  }

  _saveExam() async {
    setState(() {
      _isLoading = true;
    });
  

    SharedPreferences localStorage = await SharedPreferences.getInstance();
      var id= localStorage.getString('id');
      

    var data = {
      "weight": weightController.text,
      "height": heightController.text,
      "gender": genderController.text,
      "city": cityController.text,
      "marital_status": maritalStatusController.text,
      "date_of_birth": dateOfBirthController.text,
      "family_history": [familyHistoryController.text],
      "personal_history": [personalHistoryController.text],
    };
    print(jsonDecode(id!));
    var res =
        await Network().authData(data, '/dossier/completeDossier?id=${jsonDecode(id!)}');
        var body = json.decode(res.body);
    print(body );

        if (res.statusCode == 201) {

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        }
        setState(() {
          _isLoading = false;
        });
 
    }
}