// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:pingo/services/auth/auth_services.dart';
import 'package:pingo/services/chat/chat_services.dart';
import 'package:pingo/utils/user_tile.dart';

class BlockedUsersPage extends StatelessWidget {
  BlockedUsersPage({super.key});

  //services
  ChatServices chatServices = ChatServices();
  AuthServices authServices = AuthServices();

  //unblock dialogue
  void showUnblockDialogue(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Unblock user'),
          content: const Text('Are you sure , you want to unblock the user ?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("No")),
            TextButton(
              onPressed: () {
                chatServices.unBlockUser(userId);
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("User Unblocked"),
                  ),
                );
              },
              child: const Text("unblock"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = authServices.getCurrentUSer()!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blocked Users'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: ChatServices().getBlockedUsersStream(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching data'),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final blockedUsersList = snapshot.data ?? [];

          if (blockedUsersList.isEmpty) {
            return const Center(
              child: Text("No blocked users"),
            );
          }
          return ListView.builder(
            itemCount: blockedUsersList.length,
            itemBuilder: (context, index) {
              final user = blockedUsersList[index];
              return UserTile(
                text: user['email'],
                onTap: () => showUnblockDialogue(context, user['uid']),
              );
            },
          );
        },
      ),
    );
  }
}
