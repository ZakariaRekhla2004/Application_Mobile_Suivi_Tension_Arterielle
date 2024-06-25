import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_front/api/auth.dart';
import 'package:flutter_front/screens/Medicaments/display.dart';

class MedicineDetails extends StatelessWidget {
  final Medicine medicine;

  MedicineDetails(this.medicine);
deleteMedicamts(BuildContext context) async {
  var data = {
     'Nom'  : medicine.medicineName,
    'start' : medicine.start,
    'end' : medicine.end,
  };
  print(data);
   var res = await Network().authData(data, '/dossier/deleteMedicament');
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Medication()),
      );
  //  print(jsonDecode(res));
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:Color.fromARGB(255, 93, 153, 205),
       
        centerTitle: true,
        title: Text(
          "Medicament Details",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MainSection(medicine: medicine),
            SizedBox(
              height: 15,
            ),
            ExtendedSection(medicine: medicine),
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.height * 0.05,
                right: MediaQuery.of(context).size.height * 0.05,
                top: 25,
              ),
              child: Container(
                width: 450,
                // height: 70,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 93, 153, 205),
                    shape: StadiumBorder(),
                  ),
                  onPressed: () {
                    openAlertBox(context);
                  },
                  child: Center(
                    child: Text(
                      "Delete Medicament",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openAlertBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
          ),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: 450.0,
            height: 120,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(18),
                  child: Center(
                    child: Text(
                      "Delete this Medicament?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2.743,
                          padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
                          decoration: BoxDecoration(
                            color: Colors.red[700],
                            borderRadius: BorderRadius.all(
                                 Radius.circular(30.0)),
                          ),
                          child: Text(
                            "No",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        deleteMedicamts(context);
                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Medication()));
                      },
                      child: InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2.743,
                          padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 93, 153, 205),
                            borderRadius: BorderRadius.all(
                             Radius.circular(30.0),
                            ),
                          ),
                          child: Text(
                            "Yes",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class MainSection extends StatelessWidget {
  final Medicine medicine;

  MainSection({
    Key? key,
    required this.medicine,
  }) : super(key: key);

  String categoryImagePath(String categoryStr) {
    switch (categoryStr) {
      case 'Capsule':
        return 'assets/pills.gif';
      case 'Tablet':
        return 'assets/tablet.gif';
      case 'Liquid':
        return 'assets/liquid.gif';
      default:
        return 'assets/pills.gif';
    }
  }

  Hero makeIcon(double size) {
    return Hero(
      tag: medicine.medicineName + medicine.medicineType,
      child: Image.asset( width: 60, height: 60,
        categoryImagePath(medicine.medicineType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          makeIcon(175),
          SizedBox(
            width: 15,
          ),
          Column(
            children: <Widget>[
              Hero(
                tag: medicine.medicineName,
                child: Material(
                  color: Colors.transparent,
                  child: MainInfoTab(
                    fieldTitle: "Medicine Name",
                    fieldInfo: medicine.medicineName,
                  ),
                ),
              ),
              MainInfoTab(
                fieldTitle: "Dosage",
                fieldInfo: medicine.dose + " " + medicine.strengthUnit,
              )
            ],
          )
        ],
      ),
    );
  }
}

class MainInfoTab extends StatelessWidget {
  final String fieldTitle;
  final String fieldInfo;

  MainInfoTab({Key? key, required this.fieldTitle, required this.fieldInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.35,
      height: 100,
      child: ListView(
        padding: EdgeInsets.only(top: 15),
        shrinkWrap: true,
        children: <Widget>[
          Text(
            fieldTitle,
            style: TextStyle(
                fontSize: 17,
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold),
          ),
          Text(
            fieldInfo,
            style: TextStyle(
                fontSize: 24,
                color: Color.fromARGB(255, 93, 153, 205),
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ExtendedSection extends StatelessWidget {
  final Medicine medicine;

  ExtendedSection({Key? key, required this.medicine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          ExtendedInfoTab(
            fieldTitle: "Medicine Type",
            fieldInfo: medicine.medicineType 
          ),
          ExtendedInfoTab(
            fieldTitle: "Times",
            fieldInfo: medicine.times,
          ),
          ExtendedInfoTab(
            fieldTitle: "Start",
            fieldInfo: medicine.start  ,
          ),
          ExtendedInfoTab(
            fieldTitle: "End",
            fieldInfo: medicine.end ,
          ),
        ],
      ),
    );
  }
}

class ExtendedInfoTab extends StatelessWidget {
  final String fieldTitle;
  final String fieldInfo;

  ExtendedInfoTab({Key? key, required this.fieldTitle, required this.fieldInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom:4.0),
              child: Text(
                fieldTitle,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              fieldInfo,
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 154, 153, 153),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}