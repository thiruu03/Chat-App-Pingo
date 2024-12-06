import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  //initialize firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //get current user
  // ignore: body_might_complete_normally_nullable
  User? getCurrentUSer() {
    // ignore: unused_local_variable
    final currentUser = _auth.currentUser;
    return currentUser;
  }

  //login
  Future<UserCredential> signiInWithEmailAndPassword(
      String email, password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      firestore
          .collection('Users')
          .doc(userCredential.user!.uid)
          .set({"uid": userCredential.user!.uid, 'email': email});
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //register
  Future<UserCredential> signup(String email, password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      firestore
          .collection('Users')
          .doc(userCredential.user!.uid)
          .set({"uid": userCredential.user!.uid, 'email': email});
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //logout
  Future<void> signout() async {
    await _auth.signOut();
  }
}
