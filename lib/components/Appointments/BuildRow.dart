import 'package:flutter/material.dart';

class BuildRow extends StatelessWidget {
  final String date;
  final String time;
  final String status;

  const BuildRow({
    Key? key,
    required this.date,
    required this.time,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.white;
    IconData statusIcon = Icons.hourglass_empty;
    switch (status) {
      case "Accept":
        statusColor = Color(0xFF89ED8C);
        statusIcon = Icons.check_circle_outline;
        break;
      case "Reject":
        statusColor = Color(0xFFFFBDC0);
        statusIcon = Icons.cancel_outlined;
        break;
      default:
        statusColor = Color(0xFFE8E2E2);
        statusIcon = Icons.hourglass_empty;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                time,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                status,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              SizedBox(width: 8.0),
              Icon(
                statusIcon,
                color: Colors.black54,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
