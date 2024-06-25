import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_front/api/auth.dart';
import 'package:flutter_front/components/NotificationWidget.dart';
import 'package:flutter_front/models/Notification.dart';
class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<NotificationItem>> _futureNotifications;

  @override
  void initState() {
    super.initState();
    _futureNotifications = fetchNotifications();
  }


  Future<List<NotificationItem>> fetchNotifications() async {
  var res = await Network().getData('/Notifications/getNotifications');
  print('Response Body: ${res.body}');
  if (res.statusCode == 200) {
    List<dynamic> data = json.decode(res.body)['notification'];
    print('Decoded Data: $data');
    return data.map((item) => NotificationItem.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load notifications');
  }
}
  

  void _handleNotificationTap(int index, List<NotificationItem> notifications) async {
  try {
    var res = await Network().getData('/Notifications/updateNotification?id=${notifications[index].id}');
   
    if (res.statusCode == 200) {
      setState(() {
        notifications[index].isRead = true;
      });
      // print(res.body);
    } else {
      throw Exception('Failed to update notification status');
    }
  } catch (e) {
    print('Error updating notification status: $e');
    
}



  }

  @override
  Widget build(BuildContext context)
   {
  
    return Scaffold(
      backgroundColor: Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Notifications",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
    
      body: FutureBuilder<List<NotificationItem>>(
        future: _futureNotifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
     
            return Center(child: Text('Failed to load notifications'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No notifications available'));
          } else {
            return NotificationList(
              notifications: snapshot.data!,
              onNotificationTap: (index) => _handleNotificationTap(index, snapshot.data!),
            );
          }
        },
      ),
    );
  }
}