import 'package:flutter/material.dart';
import 'package:pingo/services/auth/auth_services.dart';
import 'package:pingo/utils/my_button.dart';
import 'package:pingo/utils/my_textfield.dart';

class LoginPage extends StatefulWidget {
  final void Function()? ontap;

  const LoginPage({super.key, required this.ontap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

//login method
void login(BuildContext context) async {
  AuthServices authServices = AuthServices();

  try {
    authServices.signiInWithEmailAndPassword(
        emailController.text, passwordController.text);
  } catch (e) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          e.toString(),
        ),
      ),
    );
  }
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //image or icon
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              height: 5,
            ),

            //welcome message
            Text(
              "Welcome back , You have been missed!",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
            const SizedBox(
              height: 25,
            ),

            //email textfield
            MyTextfield(
              obsecureText: false,
              hintText: "Email",
              controller: emailController,
            ),
            const SizedBox(
              height: 15,
            ),

            //password textfield
            MyTextfield(
              hintText: "Password",
              controller: passwordController,
              obsecureText: true,
            ),

            const SizedBox(
              height: 20,
            ),
            MyButton(
              text: "Login",
              ontap: () => login(context),
            ),

            const SizedBox(
              height: 20,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member?",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                TextButton(
                  onPressed: widget.ontap,
                  child: Text(
                    "Register now",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
