import 'package:flutter/material.dart';
import 'package:flutter_front/models/Notification.dart';

class NotificationList extends StatelessWidget {
  final List<NotificationItem> notifications;
  final Function(int) onNotificationTap;

  const NotificationList({
    Key? key,
    required this.notifications,
    required this.onNotificationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return NotificationTile(
          notification: notifications[index],
          onTap: () => onNotificationTap(index),
        );
      },
    );
  }
}
// Notification tile widget
class NotificationTile extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;

  const NotificationTile({
    Key? key,
    required this.notification,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 5,
        backgroundColor: notification.isRead ? Colors.transparent : Colors.blue,
      ),
      title: Text(notification.title),
      subtitle: Text(notification.message),
      tileColor: notification.isRead ? Colors.white : Colors.grey.shade300,
      onTap: onTap,
    );
  }
}