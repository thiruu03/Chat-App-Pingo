import 'package:flutter/material.dart';
import 'package:pingo/pages/chat_page.dart';
import 'package:pingo/services/auth/auth_services.dart';
import 'package:pingo/services/chat/chat_services.dart';
import 'package:pingo/utils/my_drawer.dart';
import 'package:pingo/utils/user_tile.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  ChatServices chatServices = ChatServices();
  AuthServices authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'HOME',
          style: TextStyle(),
        ),
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      body: buildUserList(),
    );
  }

//list of users
  Widget buildUserList() {
    return StreamBuilder(
      stream: chatServices.getUsersExcludingBlockedUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Error"),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView(
            children: snapshot.data!
                .map<Widget>((userData) => buildUserListItem(userData, context))
                .toList(),
          );
        }
      },
    );
  }

  //single user tile
  Widget buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData['email'] != authServices.getCurrentUSer()?.email) {
      return UserTile(
        text: userData['email'],

        //navigate to chatpage
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ChatPage(
                  receiverMail: userData['email'],
                  receiverId: userData['uid'],
                );
              },
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
