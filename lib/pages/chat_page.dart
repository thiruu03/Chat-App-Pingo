import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pingo/models/chat_bubble.dart';
import 'package:pingo/services/auth/auth_services.dart';
import 'package:pingo/services/chat/chat_services.dart';
import 'package:pingo/themes/theme_provider.dart';
import 'package:pingo/utils/my_textfield.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ChatPage extends StatefulWidget {
  final String receiverMail;
  final String receiverId;
  const ChatPage({
    super.key,
    required this.receiverMail,
    required this.receiverId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //get the auth and chat servics
  final AuthServices authServices = AuthServices();

  final ChatServices chatServices = ChatServices();

  //textcontroller for textbox
  TextEditingController messageController = TextEditingController();
  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatServices.sendMessage(widget.receiverId, messageController.text);
      messageController.clear();
    }
    scrollDown();
  }

  //focusnode for textfield
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    focusNode.addListener(
      () {
        if (focusNode.hasFocus) {
          Future.delayed(
            const Duration(milliseconds: 500),
            () => scrollDown(),
          );
        }
      },
    );

    Future.delayed(
      const Duration(seconds: 1),
      () => scrollDown(),
    );
  }

  //scroll controller
  final ScrollController scrollController = ScrollController();

  void scrollDown() {
    scrollController.animateTo(
      scrollController
          .position.maxScrollExtent, // Scroll to the bottom (latest message)
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverMail),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: buildMessageList(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            child: buildUserInput(),
          ),
        ],
      ),
    );
  }

  Widget buildMessageList() {
    String senderId = authServices.getCurrentUSer()!.uid;
    // Empty string or handle appropriately
    if (senderId.isEmpty) {
      // Handle the error, such as showing a login prompt or a message
      return const Center(child: Text("Please log in to send messages"));
    }
    return StreamBuilder<QuerySnapshot>(
      stream: chatServices.getMessages(widget.receiverId, senderId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading messages"));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.data != null && snapshot.data!.docs.isNotEmpty) {
          print('message fetched');
          return ListView(
            controller: scrollController,
            children: snapshot.data!.docs
                .map((doc) => buildMessageItem(doc))
                .toList(),
          );
        } else {
          return const Center(child: Text("No messages"));
        }
      },
    );
  }

  Widget buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    DateTime messageTime = (data['timestamp'] as Timestamp).toDate();
    String formattedTime = DateFormat.jm().format(messageTime);
    bool isCurrentUser = data['senderId'] == authServices.getCurrentUSer()!.uid;
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            alignment: alignment,
            message: data['message'],
            isCurrentUser: isCurrentUser,
            time: '$formattedTime',
            messageId: doc.id,
            userid: data['senderId'],
          ),
        ],
      ),
    );
  }

  Widget buildUserInput() {
    bool isdarkMode = Provider.of<ThemeProvider>(context).isDarkmode;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: MyTextfield(
            focusNode: focusNode,
            hintText: "Type a message",
            controller: messageController,
            obsecureText: false,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: !isdarkMode ? Colors.blue : Colors.green.shade700),
          child: IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.arrow_upward_rounded,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
