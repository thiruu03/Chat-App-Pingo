import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:pingo/models/message_model.dart';

class ChatServices extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get all users
  Stream<List<Map<String, dynamic>>> usersStream() {
    return _firestore.collection("Users").snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      },
    );
  }

  //get all users  excluding the blocked users
  Stream<List<Map<String, dynamic>>> getUsersExcludingBlockedUsers() {
    final currentUser = _auth.currentUser;

    return _firestore
        .collection("Users")
        .doc(currentUser!.uid)
        .collection("BlockedUsers")
        .snapshots()
        .asyncMap(
      (snapshot) async {
        final blockedUsersIds = snapshot.docs
            .map(
              (doc) => doc.id,
            )
            .toList();

        final usersSnapshot = await _firestore.collection('Users').get();

        return usersSnapshot.docs
            .where((doc) =>
                doc.data()['email'] != currentUser.email &&
                !blockedUsersIds.contains(doc.id))
            .map((e) => e.data())
            .toList();
      },
    );
  }

  //send messages
  Future<void> sendMessage(String receiverId, String message) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    final String currentUserId = user.uid;
    final Timestamp timestamp = Timestamp.now();

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    MessageModel newMessage = MessageModel(
      senderId: currentUserId,
      senderEmail: user.email!,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    try {
      await _firestore
          .collection("chat_rooms")
          .doc(chatRoomId)
          .collection("messages")
          .add(newMessage.toMap());
      print("Message sent: ${newMessage.message}");
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  //get messages
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false) // Correct order: descending
        .snapshots();
  }

  //report user
  Future<void> reportUser(String messageId, userId) async {
    final currentUser = _auth.currentUser;
    final report = {
      'reportedBy': currentUser!.uid,
      'messageId': messageId,
      'messageOwnerId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('Reports').add(report);
  }

  //block user
  Future<void> blockUser(String userId) async {
    final currentUser = _auth.currentUser;

    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection("BlockedUsers")
        .doc(userId)
        .set({});
    notifyListeners();
  }

  //unblock user
  Future<void> unBlockUser(String blockedId) async {
    final currentUser = _auth.currentUser;

    await _firestore
        .collection("Users")
        .doc(currentUser!.uid)
        .collection("BlockedUsers")
        .doc(blockedId)
        .delete();
  }

  //get blocked users list
  Stream<List<Map<String, dynamic>>> getBlockedUsersStream(String userId) {
    return _firestore
        .collection("Users")
        .doc(userId)
        .collection("BlockedUsers")
        .snapshots()
        .asyncMap(
      (snapshot) async {
        final blockedUsersList = snapshot.docs
            .map(
              (e) => e.id,
            )
            .toList();

        final userDocs = await Future.wait(
          blockedUsersList.map(
            (id) => _firestore.collection("Users").doc(id).get(),
          ),
        );
        return userDocs.map((id) => id.data() as Map<String, dynamic>).toList();
      },
    );
  }
}
