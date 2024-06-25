import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_front/api/auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  late Future<UserInfo> userInfo;

  @override
  void initState() {
    super.initState();
    userInfo = fetchUserInfo();
  }

  Future<UserInfo> fetchUserInfo() async {
  
    var res = await Network().getData('/Statistique/moreInfo');
    print( json.decode(res.body));

    if (res.statusCode == 200) {
      return UserInfo.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to load user information');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<UserInfo>(
        future: userInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) { 
            print("Error: ${snapshot.error}");
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            final user = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Center the information
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 80,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'General Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  UserInfoRow(label: 'Name', value: user.name),
                  UserInfoRow(label: 'Email', value: user.email),
                  UserInfoRow(label: 'Date of Birth', value: user.dossierPatient.dateOfBirth),
                  UserInfoRow(label: 'Gender', value: user.dossierPatient.gender),
                  UserInfoRow(label: 'Marital Status', value: user.dossierPatient.maritalStatus),
                  SizedBox(height: 16),
                  Divider(), // Add a line between sections
                  SizedBox(height: 16),
                  Text(
                    'Supplement Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  UserInfoRow(label: 'Weight', value: '${user.dossierPatient.weight} kg'),
                  UserInfoRow(label: 'Height', value: '${user.dossierPatient.height} cm'),
                  UserInfoRow(label: 'Personal History', value: user.dossierPatient.personalHistory.join(', ')),
                  UserInfoRow(label: 'Family History', value: user.dossierPatient.familyHistory.join(', ')),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class UserInfoRow extends StatelessWidget {
  final String label;
  final String value;

  UserInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center each row
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18, color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }
}

class UserInfo {
  final String name;
  final String email;
  final DossierPatient dossierPatient;

  UserInfo({required this.name, required this.email, required this.dossierPatient});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      name: json['user']['name'],
      email: json['user']['email'],
      dossierPatient: DossierPatient.fromJson(json['user']['dossier_patient']),
    );
  }
}

class DossierPatient {
  final String dateOfBirth;
  final String gender;
  final String maritalStatus;
  final String height;
  final String weight;
  final List<String> personalHistory;
  final List<String> familyHistory;

  DossierPatient({
    required this.dateOfBirth,
    required this.gender,
    required this.maritalStatus,
    required this.height,
    required this.weight,
    required this.personalHistory,
    required this.familyHistory,
  });

  factory DossierPatient.fromJson(Map<String, dynamic> json) {
    return DossierPatient(
      dateOfBirth: json['date_of_birth'],
      gender: json['gender'],
      maritalStatus: json['marital_status'],
      height: json['height'],
      weight: json['weight'],
      personalHistory: List<String>.from(json['personal_history']),
      familyHistory: List<String>.from(json['family_history']),
    );
  }
}
