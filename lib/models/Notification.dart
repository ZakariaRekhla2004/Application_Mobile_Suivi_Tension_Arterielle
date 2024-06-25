class NotificationItem {
  final String id;
  final String sender;
   String title;

  final String recever;
  final String message;
  final String appointmentId;
  bool isRead;
  final DateTime updatedAt;
  final DateTime createdAt;

  NotificationItem({
    required this.id,
    required this.title,
    required this.sender,
    required this.recever,
    required this.message,
    required this.appointmentId,
    required this.isRead,
    required this.updatedAt,
    required this.createdAt,
  });
  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['_id'],
      sender: json['sender'],
      title: json['title'],
      recever: json['recever'],
      message: json['message'],
      appointmentId: json['appoint_id'],
      isRead: json['read'],
      updatedAt: DateTime.parse(json['updated_at']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
