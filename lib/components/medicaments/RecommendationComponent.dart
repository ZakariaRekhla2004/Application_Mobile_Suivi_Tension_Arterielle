import 'package:flutter/material.dart';
import 'package:flutter_front/api/auth.dart';
import 'package:flutter_front/screens/ExamTension/ExamDisplay.dart';
import 'package:flutter_front/screens/ExamTension/ExamTension.dart';
import 'package:flutter_front/screens/ExamTension/TensionApi.dart';
import 'package:flutter_front/screens/ExamTension/updateExam.dart';

class RecommendationComponent extends StatelessWidget {
  final List<SalesData> chartData;
  final List<SalesData> chartData1;

  RecommendationComponent({
    required this.chartData,
    required this.chartData1,
  });

  String _getStatus(double systolic, double diastolic) {
    if (systolic < 100 && diastolic < 60) {
      return 'Low Blood Pressure';
    } else if (systolic < 120 && diastolic < 80) {
      return 'Normal';
    } else if (systolic < 130 && diastolic < 80) {
      return 'Elevated';
    } else if (systolic < 140 || diastolic < 90) {
      return 'High Blood Pressure (Hypertension) Stage 1';
    } else if (systolic < 180 || diastolic < 120) {
      return 'High Blood Pressure (Hypertension) Stage 2';
    } else {
      return 'Hypertensive Crisis';
    }
  }

  String _getRecommendations(String status) {
    switch (status) {
      case 'Low Blood Pressure':
        return 'Consult a healthcare provider for advice.';
      case 'Normal':
        return 'Maintain a healthy lifestyle and regular checkups.';
      case 'Elevated':
        return 'Adopt a healthier lifestyle and monitor your blood pressure.';
      case 'High Blood Pressure (Hypertension) Stage 1':
        return 'Consult your doctor and consider lifestyle changes and possible medication.';
      case 'High Blood Pressure (Hypertension) Stage 2':
        return 'Seek medical advice for a treatment plan.';
      case 'Hypertensive Crisis':
        return 'Seek emergency medical attention immediately.';
      default:
        return 'Consult your healthcare provider.';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (chartData.isEmpty || chartData1.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(14.0),
        child: Text('No data available for recommendations.'),
      );
    }

    final latestSystolic = chartData.last.sales;
    final latestDiastolic = chartData1.last.sales;
    final status = _getStatus(latestSystolic, latestDiastolic);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.white,
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Latest Blood Pressure Exam',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Systolic Pressure: $latestSystolic mmHg',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        'Diastolic Pressure: $latestDiastolic mmHg',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.update,
                          color: Colors.blue,
                        ),
                        onPressed: ()  {
                          
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateTension(chartData.last.id)),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          await Network().deleteData(
                              '/TensionExam/deleteTension_Exam?id=${chartData.last.id}');
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DisplayTension()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 4.0,
            color: _getStatusColor(status),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    status,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Recommendations: ${_getRecommendations(status)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildGeneralAwareness(context),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _buildGeneral(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Low Blood Pressure':
        return Colors.blue;
      case 'Normal':
        return Colors.green;
      case 'Elevated':
        return Colors.orange;
      case 'High Blood Pressure (Hypertension) Stage 1':
        return Colors.redAccent;
      case 'High Blood Pressure (Hypertension) Stage 2':
        return Colors.red;
      case 'Hypertensive Crisis':
        return Colors.deepPurple;
      default:
        return const Color.fromARGB(255, 255, 255, 255);
    }
  }

  Widget _buildGeneralAwareness(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey[400],
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(8.0), // Adjust the value as needed
          ),
        ),
        child: const Text(
          'Show General Awareness',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
            // color: Colors.green[400],
          ),
        ),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      Colors.blue.shade200,
                      Colors.blue.shade400,
                      Colors.blue.shade800
                    ],
                  ),
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(
                        color: Colors.white,
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'General Blood Pressure Awareness',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.green[400],
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                '1. Normal Blood Pressure: Systolic < 120 and Diastolic < 80.',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              const Text(
                                '2. Elevated Blood Pressure: Systolic between 120-129 and Diastolic < 80.',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              const Text(
                                '3. Hypertension Stage 1: Systolic between 130-139 or Diastolic between 80-89.',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              const Text(
                                '4. Hypertension Stage 2: Systolic >= 140 or Diastolic >= 90.',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              const Text(
                                '5. Hypertensive Crisis: Systolic > 180 and/or Diastolic > 120. Seek emergency care.',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              const Text(
                                '6. Low Blood Pressure: Systolic < 100 and Diastolic < 60. Consult a healthcare provider.',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildGeneral(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey[400],
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(8.0), // Adjust the value as needed
          ),
        ),
        child: const Text(
          'Show Recommendations',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
            // color: Colors.green[400],
          ),
        ),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      Colors.blue.shade200,
                      Colors.blue.shade400,
                      Colors.blue.shade800
                    ],
                  ),
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(
                        color: Colors.white,
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recommendations',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.green[400],
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                '1. Maintain a healthy diet low in salt, fat, and cholesterol.',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              const Text(
                                '2. Exercise regularly, at least 30 minutes most days of the week.',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              const Text(
                                '3. Avoid smoking and limit alcohol intake.',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              const Text(
                                '4. Monitor your blood pressure regularly.',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              const Text(
                                '5. Follow your healthcare provider\'s recommendations.',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
              );
            },
          );
        },
      ),
    );
  }
}
