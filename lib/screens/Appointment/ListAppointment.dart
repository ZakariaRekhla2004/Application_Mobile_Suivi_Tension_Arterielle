import 'package:flutter/material.dart';
import 'package:flutter_front/api/auth.dart';
import 'package:flutter_front/screens/Appointment/addAppointment.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';

class Listappointment extends StatefulWidget {
  @override
  _ListappointmentState createState() => _ListappointmentState();
}

class _ListappointmentState extends State<Listappointment> {
  Map<DateTime, List<dynamic>> _appointments = {};
  late Future<void> _fetchDataFuture;
  DateTime _selectedDay = DateTime.now();
  List<dynamic> _selectedEvents = [];

  @override
  void initState() {
    super.initState();
    _fetchDataFuture = _fetchData();
  }

  _delete(event) async {
    print(event);
    var res =
        await Network().deleteData('/apppoint/deleteAppointment?id=$event');
    // var body = json.decode(res.body);
    _fetchData();
  }

  Future<void> _fetchData() async {
    var res = await Network().getData('/apppoint/getAppointment');
    if (res.statusCode == 200) {
      List<dynamic> appointments = json.decode(res.body);
      setState(() {
        _appointments = {};
        for (var appointment in appointments) {
          DateTime date = DateTime.parse(appointment['date']);
          DateTime normalizedDate = DateTime(date.year, date.month, date.day);
          if (_appointments[normalizedDate] == null) {
            _appointments[normalizedDate] = [];
          }
          _appointments[normalizedDate]?.add(appointment);
        }
        _selectedEvents = _appointments[_normalizeDate(_selectedDay)] ?? [];
      });
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _selectedEvents = _appointments[_normalizeDate(selectedDay)] ?? [];
    });
    print(_selectedEvents);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Appointments",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<void>(
        future: _fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Column(
              children: [
                _buildCalendar(),
                const SizedBox(height: 16.0),
                Expanded(child: _buildEventList()),
              ],
            );
          }
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 5),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Appointment(0)),
            );
          },
          backgroundColor: Colors.blueAccent,
          child: Icon(
            Icons.add,
            size: 30,
            color: Color.fromARGB(255, 203, 226, 231),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      focusedDay: DateTime.now(),
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      calendarFormat: CalendarFormat.month,
      eventLoader: (day) {
        DateTime normalizedDate = _normalizeDate(day);
        // print("Loading events for day: $normalizedDate");
        // print("Events: ${_appointments[normalizedDate]}");
        return _appointments[normalizedDate] ?? [];
      },
      onDaySelected: _onDaySelected,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          // print("Marker builder for date: $date with events: $events");
          if (events.isNotEmpty) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: events.map((event) {
                var eventMap = event as Map<String, dynamic>;
                var status = eventMap['status'];

                Color color;
                if (status == 'Waiting') {
                  color = Colors.yellow;
                } else if (status == 'Accept') {
                  color = Colors.green;
                } else if (status == 'Rejected') {
                  color = Colors.red;
                } else {
                  color = Colors.grey;
                }
                return Container(
                  margin: const EdgeInsets.all(2.0),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                );
              }).toList(),
            );
          }
          return null;
        },
      ),
    );
  }

  Widget _buildEventList() {
    if (_selectedEvents.isEmpty) {
      return Center(
        child: Text("No events for the selected day."),
      );
    } else {
      return ListView.builder(
        itemCount: _selectedEvents.length,
        itemBuilder: (context, index) {
          var event = _selectedEvents[index];
          Color color;
          if (event['status'] == 'Waiting') {
            color = Color.fromARGB(255, 177, 188, 29);
          } else if (event['status'] == 'Accept') {
            color = Color.fromARGB(255, 96, 212, 99);
          } else if (event['status'] == 'Rejected') {
            color = Color.fromARGB(255, 244, 130, 122);
          } else {
            color = Colors.grey;
          }
          return Card(
            color: color,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                'Appointment : ${event['status']}',
                style: TextStyle(
                  fontSize: 18, // Example font size
                  fontWeight: FontWeight.bold, // Example font weight
                  color: Colors.black, // Example text color
                ),
              ),
              subtitle: Text(
                'Date: ${event['date']}, Time: ${event['heure']}',
                style: TextStyle(
                  fontSize: 16, // Example font size
                  color: Color.fromARGB(255, 50, 43, 43),
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete,
                    color: Color.fromARGB(255, 218, 215, 215)),
                onPressed: () {
                  _delete(event['_id']);
                },
              ),
            ),
          );
        },
      );
    }
  }
}
