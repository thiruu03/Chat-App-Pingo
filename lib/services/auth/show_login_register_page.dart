import 'package:flutter/material.dart';
import 'package:pingo/pages/login_page.dart';
import 'package:pingo/pages/register_page.dart';

class ShowLoginRegisterPage extends StatefulWidget {
  const ShowLoginRegisterPage({super.key});

  @override
  State<ShowLoginRegisterPage> createState() => _ShowLoginRegisterPageState();
}

class _ShowLoginRegisterPageState extends State<ShowLoginRegisterPage> {
  bool showLoginPagee = true;

  void togglePages() {
    setState(() {
      showLoginPagee = !showLoginPagee;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPagee) {
      return LoginPage(
        ontap: togglePages,
      );
    } else {
      return RegisterPage(
        ontap: togglePages,
      );
    }
  }
}
