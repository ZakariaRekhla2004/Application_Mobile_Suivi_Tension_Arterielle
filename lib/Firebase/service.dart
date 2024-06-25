import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
// instance of auth

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 User? getCurrentUser() {
  return _auth.currentUser;
 }
// sign in

  Future<UserCredential> signInWithEmailPassword1(String email, String password) async {

    try {
      print("aaaaaaaaaaaaaaa");
      print(email);
      print(password);

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _firestore.collection('Users').doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
        },
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
    // print("aaaaaaaaaaaaaaa");

      throw Exception(e.code);
    }
  }
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    print(email);
      print(password);
   UserCredential userCredential = await _auth.createUserWithEmailAndPassword( email: email,
        password: password,);
   _firestore.collection('Users').doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
        },
      );
    return userCredential;
  }


  // sign out 
  Future<void> signOut() async {
    return await _auth.signOut();
  }


}
