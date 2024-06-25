import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_front/api/auth.dart';
import 'package:flutter_front/components/DatePicker.dart';
import 'package:flutter_front/components/TextField.dart';
import 'package:flutter_front/components/loginWidgets/ButtonWidget.dart';
import 'package:flutter_front/main.dart';
import 'package:flutter_front/models/MedicamentCategory.dart';
import 'package:flutter_front/screens/Medicaments/alarmreminder.dart';
import 'package:flutter_front/screens/Medicaments/display.dart';
import 'package:flutter_front/screens/home/views/home.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AddMedication extends StatefulWidget {
  List<CategoryModel2> categories = [];
  void _getInitialInfo() {
    categories = CategoryModel2.getCategories();
  }

  @override
  _AddMedicationState createState() => _AddMedicationState();
}

class _AddMedicationState extends State<AddMedication> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late TextEditingController nomController;
  late TextEditingController dozeController;
  late TextEditingController mg_gController;
  late TextEditingController qrController;
  late TextEditingController dateExamenControllerEnd;
  late TextEditingController dateExamenControllerStart;
  late TextEditingController _medicationTypeController;
  File? _image;
  int _selectedCategoryIndex = -1;
  final ImagePicker _picker = ImagePicker();
  final List<String> _times = ['Morning', 'Afternoon', 'Evening'];
  List<String> _selectedTimes = [];

  @override
  void initState() {
    super.initState();
    widget._getInitialInfo();
    nomController = TextEditingController();
    dozeController = TextEditingController();
    mg_gController = TextEditingController();
    qrController = TextEditingController();
    dateExamenControllerEnd = TextEditingController();
    dateExamenControllerStart = TextEditingController();
    _medicationTypeController = TextEditingController();
    tz.initializeTimeZones();  // Initialize time zones
  }

  @override
  void dispose() {
    nomController.dispose();
    dozeController.dispose();
    mg_gController.dispose();
    qrController.dispose();
    _medicationTypeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  

  Future<void> _saveMedication() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id');

    var data = {
      "Nom": nomController.text,
      "Doze": dozeController.text,
      "Mg_g": mg_gController.text,
      "MedicationType": _medicationTypeController.text,
      "Qr": _image != null ? base64Encode(_image!.readAsBytesSync()) : null,
      "Temps": _selectedTimes,
      "start": dateExamenControllerStart.text,
      "end": dateExamenControllerEnd.text,
    };

    var res = await Network().authData({"medications": [data]}, '/dossier/AddMedicament');
    var body = json.decode(res.body);

    if (res.statusCode == 201) {
      _setAlarms(data);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Medication()));
    }

    setState(() {
      _isLoading = false;
    });
  }
void _setAlarms(Map<String, dynamic> medicationData) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    DateTime startDate = formatter.parse(medicationData['start']);
    DateTime endDate = formatter.parse(medicationData['end']);
    Map<String, int> timeMapping = {
      'Morning': 9,
      'Afternoon': 14,
      'Evening': 21
    }; // Adjusted time mapping

    for (String time in medicationData['Temps']) {
      int hour = timeMapping[time]!;
      while (!startDate.isAfter(endDate)) {
        DateTime alarmTime = DateTime(startDate.year, startDate.month,
            startDate.day, hour);
        int alarmId =
            (startDate.microsecondsSinceEpoch + hour) % 2147483647; // Generate valid alarm ID
        Alarm.set(
          alarmSettings: AlarmSettings(
            id: alarmId,
            dateTime: alarmTime,
            // assetAudioPath: 'assets/marimba.mp3',
            assetAudioPath: '',
            loopAudio: false,
            vibrate: false,
            notificationTitle: 'Medication Reminder',
            notificationBody:
                'It\'s time to take your medication: ${medicationData['Nom']}',
            fadeDuration: 1, 
          ),
        );
        _showNotification(
          id: alarmId,
          title: 'Medication Reminder',
          body:
              'It\'s time to take your medication: ${medicationData['Nom']}',
          alarmTime: alarmTime,
          payload: alarmId.toString(),
        );
        startDate = startDate.add(Duration(days: 1));
      }
      startDate = formatter.parse(medicationData['start']);
    }
  }
Future<void> _showNotification(
    {required int id,
    required String title,
    required String body,
    required DateTime alarmTime,
    required String payload}) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'medication_channel_id',
    'Medication Reminders',
    channelDescription: 'Channel for medication reminder notifications',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    title,
    body,
    tz.TZDateTime.from(alarmTime, tz.local),
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
    payload: jsonEncode({'alarmId': id}),  // Updated payload
  );
}
  Widget buildTextField(String label, String hint, TextEditingController controller, TextInputType keyboard) {
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
        onPressed: _saveMedication,
        title: _isLoading ? 'Saving...' : 'Save Medication',
        color: Colors.blue.shade900,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Add Medicament",
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
              const SizedBox(height: 5),
              buildTextField('Nom', 'Enter Nom', nomController, TextInputType.text),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: buildTextField('Doze', 'Enter Doze', dozeController, TextInputType.number),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: buildTextField('Mg_g', 'Enter Mg_g', mg_gController, TextInputType.number),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  itemCount: widget.categories.length,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (_selectedCategoryIndex == index) {
                              _selectedCategoryIndex = -1;
                              _medicationTypeController.text = '';
                            } else {
                              if (_selectedCategoryIndex != -1) {
                                widget.categories[_selectedCategoryIndex].boxColor = const Color.fromARGB(255, 158, 158, 158);
                                widget.categories[_selectedCategoryIndex].isSelected = false;
                              }
                              _selectedCategoryIndex = index;
                              _medicationTypeController.text = widget.categories[index].name;
                              widget.categories[index].boxColor = const Color.fromARGB(255, 7, 82, 96).withOpacity(0.3);
                              widget.categories[index].isSelected = true;
                            }
                          });
                        },
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            color: widget.categories[index].boxColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(widget.categories[index].iconPath),
                                ),
                              ),
                              Text(
                                widget.categories[index].name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Select Times:',
                style: TextStyle(
                  color: Color.fromARGB(255, 71, 67, 67),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5),
              ..._times.map((time) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                  child: CheckboxListTile(
                    title: Text(
                      time,
                      style: TextStyle(fontSize: 18),
                    ),
                    value: _selectedTimes.contains(time),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedTimes.add(time);
                        } else {
                          _selectedTimes.remove(time);
                        }
                      });
                    },
                    activeColor: Colors.blueAccent,
                    checkColor: Colors.white,
                    controlAffinity: ListTileControlAffinity.leading,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DatePickerField(
                      label: 'Start',
                      hint: 'Enter start',
                      txtEditController: dateExamenControllerStart,
                      onChanged: (value) {
                        dateExamenControllerStart.text = value;
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DatePickerField(
                      label: 'End',
                      hint: 'Enter end',
                      txtEditController: dateExamenControllerEnd,
                      onChanged: (value) {
                        dateExamenControllerEnd.text = value;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'QR or Picture of Medicament:',
                style: TextStyle(
                  color: Color.fromARGB(255, 71, 67, 67),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              _image == null ? Text('No image selected.') : Image.file(_image!),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 140, 187, 225)),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  )),
                ),
                onPressed: _pickImage,
                child: Text(
                  'Take Picture',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}
