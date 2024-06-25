import 'package:flutter/material.dart';

class TopContainer extends StatelessWidget {
  final int medicationsCount;

  const TopContainer({required this.medicationsCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      //  padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.elliptical(50, 27),
          bottomRight: Radius.elliptical(50, 27),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color:  Color.fromARGB(255, 189, 189, 189),
            offset: Offset(0, 3.5),
          )
        ],
        color: Color.fromARGB(255, 93, 153, 205),
      ),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              bottom: 2,
            ),
            child: Text(
              "Medicaments",
              style: const TextStyle(
                fontFamily: "Angel",
                fontSize: 64,
                color: Colors.white,
              ),
            ),
          ),
          const Divider(
            color: Color.fromARGB(255, 218, 248, 229),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Center(
              child: Text(
                "Number of Medications",
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Center(
              child: Text(
                medicationsCount.toString(),
                style: const TextStyle(
                  fontFamily: "Neu",
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class BottomContainer extends StatelessWidget {
  final Widget child;

  const BottomContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 232, 239, 255),
      child: child,
    );
  }
}
