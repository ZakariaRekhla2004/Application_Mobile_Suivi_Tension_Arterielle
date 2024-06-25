import 'package:flutter/material.dart';
import 'package:flutter_front/components/medicaments/MedicaDetails.dart';
import 'package:flutter_front/screens/Medicaments/display.dart';

class MedicineCard extends StatelessWidget {
  final Medicine medicine;

  MedicineCard(this.medicine);
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
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: InkWell(
        highlightColor: const Color.fromARGB(255, 212, 174, 174),
        splashColor: Colors.grey,
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder<Null>(
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (BuildContext context, Widget? child) {
                    return Opacity(
                      opacity: animation.value,
                      child: MedicineDetails(medicine),
                    );
                  },
                );
              },
              transitionDuration: Duration(milliseconds: 500),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                makeIcon(50.0),
                Hero(
                  tag: medicine.medicineName,
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      medicine.medicineName,
                      style: TextStyle(
                          fontSize: 22,
                          color: Color.fromARGB(255, 93, 153, 205),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Text(
                  medicine.times,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 128, 128, 128),
                      fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
