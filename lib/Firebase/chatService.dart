import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_front/models/message.dart';

class ChatService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //send messgae message

  Future<void> sendMessage(String receiverID, message) async {
// get current user info

    final String currentUserID = _auth.currentUser!.uid;

    // final String currentUserEmail = _auth!.currentUser!.email;

    final Timestamp timestamp = Timestamp.now();

// create a new message

    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: receiverID,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

// construct chat room ID for the two users (sorted to ensure
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

// add new message to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // get message from database
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
