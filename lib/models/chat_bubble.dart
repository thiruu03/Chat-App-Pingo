import 'package:flutter/material.dart';
import 'package:pingo/services/chat/chat_services.dart';
import 'package:pingo/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final Alignment alignment;
  final String message;
  final String time;
  final bool isCurrentUser;
  final String userid;
  final String messageId;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.time,
    required this.alignment,
    required this.userid,
    required this.messageId,
  });

  void showOptions(BuildContext context) {
    if (userid.isEmpty) return;

    showModalBottomSheet(
      elevation: 2,
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text("Report"),
                onTap: () {
                  Navigator.pop(context);
                  reportUser(context, messageId, userid);
                },
              ),
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text("Block"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context); // Dismiss chat page
                  blockUser(context, userid);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void reportUser(BuildContext context, String messageId, String userid) {
    if (userid.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Are you sure you want to report this message?'),
        title: const Text("Report Message"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              ChatServices().reportUser(messageId, userid);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Message Reported!")),
              );
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  void blockUser(BuildContext context, String userid) {
    if (userid.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Are you sure you want to block this user?'),
        title: const Text("Block User"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              ChatServices().blockUser(userid);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("User Blocked!")),
              );
            },
            child: const Text("Block"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkmode;

    return Align(
      alignment: alignment,
      child: GestureDetector(
        onLongPress: () {
          if (!isCurrentUser) {
            showOptions(context);
          }
        },
        child: Container(
          constraints: const BoxConstraints(maxWidth: 250),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isCurrentUser
                ? (isDarkMode ? Colors.green.shade700 : Colors.blue)
                : (isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: isCurrentUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color:
                      isDarkMode || isCurrentUser ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color:
                      isDarkMode || isCurrentUser ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
