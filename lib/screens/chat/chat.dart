import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_front/Firebase/chatService.dart';
import 'package:flutter_front/Firebase/service.dart';
import 'package:flutter_front/components/loginWidgets/InputField.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  final String receiverEmail = "medecin1@gmail.com";
  final String receiverID = "uXa70p8gwgM0rOjci53XCMyfXWz2";

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService authService = AuthService();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(receiverID, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = authService.getCurrentUser();

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text(receiverEmail), backgroundColor: Colors.blue),
        body: const Center(
          child: Text("User not authenticated"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              backgroundImage: AssetImage('assets/Doctors-pana.png'),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  receiverEmail,
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                Row(
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "online",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 1,
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList(currentUser.uid)),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList(String senderID) {
    return StreamBuilder(
      stream: _chatService.getMessages(receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        List<DocumentSnapshot> reversedList = snapshot.data!.docs.reversed.toList();

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: reversedList.length,
          reverse: true,
          itemBuilder: (context, index) {
            return _buildMessageItem(reversedList[index], context);
          },
        );
      },
    );
  }

 Widget _buildMessageItem(DocumentSnapshot doc, BuildContext context) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  bool isCurrentUser = data['senderID'] == authService.getCurrentUser()!.uid;
  var align = isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
  var color = isCurrentUser ? Colors.blue[100] : Colors.grey[300];
  var textColor = isCurrentUser ? Colors.white : Colors.black;

  final String messageText = data["message"];
  final double maxWidth = MediaQuery.of(context).size.width * 0.8; // Set maximum width to 80% of screen width
  final TextSpan span = TextSpan(
    text: messageText,
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
  );

  final TextPainter tp = TextPainter(
    text: span,
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: maxWidth);

  final double messageWidth = tp.size.width + 20; // Add some padding

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
    margin: const EdgeInsets.symmetric(vertical: 4.0),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12.0),
    ),
    width: messageWidth,
    child: Column(
      crossAxisAlignment: align,
      children: [
        Text(
          messageText,
          style: TextStyle(
            fontSize: 14,
            color: textColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 4),
        Text(
          _formatTimestamp(data['timestamp']),
          style: TextStyle(
            fontSize: 12,
            color: textColor.withOpacity(0.7),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type a message",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: Colors.blue,
            iconSize: 30,
            onPressed: sendMessage,
          ),
        ],
      ),
    );
  }
}
