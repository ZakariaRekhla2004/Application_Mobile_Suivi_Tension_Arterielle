import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_front/api/auth.dart';
import 'package:flutter_front/components/medicaments/TopCont.dart';
import 'package:flutter_front/components/medicaments/medicard.dart';
import 'package:flutter_front/screens/home/views/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'addMedicaments.dart';

// Medicine model class
class Medicine {
  final String medicineName;
  final String medicineType;
  final String times;
  final String dose;
  final String strength;
   final String start ;
  final String end;
  // final String qr;
  final String strengthUnit;
  // final int interval;

  Medicine({

    this.start= "",
     this.end="",
    required this.medicineName,
    required this.medicineType,
    required this.times,
    required this.dose,
    required this.strength,
    //  this.start,
    //  this.end,
    // required this.qr,
    required this.strengthUnit,
    // required this.interval,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      medicineName: json['Nom'],
      medicineType: json['MedicationType'] ?? "Unknown",
      times: json['Temps'].join(", "),
      dose: json['Doze'],
      strength: json['Mg_g'],
      start: json['start']?? "Unknown" ,
      end: json['end']?? "Unknown",
      // qr: json['Qr'],
      strengthUnit: "mg",
      // interval: json['Interval'] ?? 1, // Assuming there's an 'Interval' field
    );
  }
}

class Medication extends StatefulWidget {
  const Medication({Key? key}) : super(key: key);

  @override
  State<Medication> createState() => _MedicationState();
}

class _MedicationState extends State<Medication> {
  late Future<void> _medicationsFuture;
  List<Medicine> medications = [];

  Future<void> fetchMedications() async {
    try {
      var response = await Network().getData('/dossier/getDossier_Medicaments');
      var data = json.decode(response.body);

      print("API Response: $data"); // Debug print to check API response

      List<dynamic> meds = data['medications'];

      List<Medicine> newMedications = [];
      for (var med in meds) {
        newMedications.add(Medicine.fromJson(med));
      }

      print("New Medications: $newMedications"); // Debug print to check the new medications list

      setState(() {
        medications = newMedications; // Update the medications list with the new data
      });
    } catch (e) {
      print("Error fetching medications: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _medicationsFuture = fetchMedications();
  }

  Widget returnFAB() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddMedication(),
          ),
        );
      },
      backgroundColor:  Color.fromARGB(255, 93, 153, 205),
      child: const Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color.fromARGB(255, 93, 153, 205),
        elevation: 0.0,
       leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
          },),
      ),
      body: Container(
        color: Color.fromARGB(255, 232, 239, 255),
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 3, // Reduced flex value to decrease height
              child: TopContainer(
                medicationsCount: medications.length,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Flexible(
              flex: 7, // Adjusted flex value to balance the layout
              child: FutureBuilder(
                future: _medicationsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (medications.isEmpty) {
                      return BottomContainer(
                        child: Center(
                          child: Text(
                            "Press + to add a Medication",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24,
                                color: Color(0xFFC9C9C9),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    } else {
                    //   return BottomContainer(
                    //     child: ListView.builder(
                    //       itemCount: medications.length,
                    //       itemBuilder: (context, index) {
                    //         return MedicineCard(medications[index]);
                    //       },
                    //     ),
                    //   );
                    // }
                    return BottomContainer(
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, 
                            mainAxisSpacing: 1.0,
                            crossAxisSpacing: 1.0,
                            childAspectRatio: 1, // Adjust the aspect ratio as needed
                          ),
                          itemCount: medications.length,
                          itemBuilder: (context, index) {
                            return MedicineCard(medications[index]);
                          },
                        ),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: returnFAB(),
    );
  }
}


