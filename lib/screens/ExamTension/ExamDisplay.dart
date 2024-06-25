import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_front/api/auth.dart';
import 'package:flutter_front/components/medicaments/ChartComponent.dart';
import 'package:flutter_front/components/medicaments/RecommendationComponent.dart';
import 'package:flutter_front/screens/ExamTension/ExamTension.dart';
import 'package:flutter_front/screens/ExamTension/TensionApi.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class DisplayTension extends StatefulWidget {
  const DisplayTension({Key? key}) : super(key: key);

  @override
  _DisplayTensionState createState() => _DisplayTensionState();
}

class _DisplayTensionState extends State<DisplayTension> {
  late TooltipBehavior _tooltipBehavior;
  late List<SalesData> _chartData;
  late List<SalesData> _chartData1;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _chartData = [];
    _chartData1 = [];
    _fetchData();
    super.initState();
  }

  Future<void> _fetchData() async {
    try {
      var res = await Network().getData('/TensionExam/getTensionExam');
      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        if (body.containsKey('TensionExam')) {
          List<dynamic> exams = body['TensionExam'];

          exams = exams.where((exam) => exam['date_Examen'] != null && exam['heure_Examen'] != null).toList();

          List<SalesData> chartData = exams.map<SalesData>((exam) {
            return SalesData(
              DateTime.parse('${exam['date_Examen']} ${exam['heure_Examen']}'),
              exam['Systolique'].toDouble(), exam['_id']
            );
          }).toList();

          List<SalesData> chartData1 = exams.map<SalesData>((exam) {
            return SalesData(
              DateTime.parse('${exam['date_Examen']} ${exam['heure_Examen']}'),
              exam['Diastolique'].toDouble(), exam['_id']
            );
          }).toList();

          chartData.sort((a, b) => a.dateTime.compareTo(b.dateTime));
          chartData1.sort((a, b) => a.dateTime.compareTo(b.dateTime));

          setState(() {
            _chartData = chartData;
            _chartData1 = chartData1;
          });
        } else {
          print('Key "TensionExam" not found in response body.');
        }
      } else {
        print('Failed to load data. Status code: ${res.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(68, 138, 255, 1),
        title: const Text(
          "Appointments",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ChartComponent(
                chartData: _chartData,
                chartData1: _chartData1,
                tooltipBehavior: _tooltipBehavior,
              ),
              RecommendationComponent(
                chartData: _chartData,
                chartData1: _chartData1,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 5),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TensionExam()),
            );
          },
          backgroundColor: Colors.blueAccent,
          child: Icon(
            Icons.text_snippet_outlined,
            size: 30,
            color: Color.fromARGB(255, 203, 226, 231),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
