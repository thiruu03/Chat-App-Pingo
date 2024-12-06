import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pingo/services/auth/auth_services.dart';
import 'package:pingo/utils/my_button.dart';
import 'package:pingo/utils/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? ontap;

  const RegisterPage({super.key, required this.ontap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmPassword = TextEditingController();

//register account
void register(BuildContext context) async {
  AuthServices authServices = AuthServices();

  //checks the password and confirm password

  if (passwordController.text == confirmPassword.text) {
    try {
      authServices.signup(emailController.text, passwordController.text);
    } on FirebaseAuthException catch (e) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  } else {
    return showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (context) => const AlertDialog(
        content: Text(
          "Passwords doesn't match! ",
        ),
      ),
    );
  }
}

class _RegisterPageState extends State<RegisterPage> {
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
              "Join to have endless pings!",
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
              height: 15,
            ),
            MyTextfield(
              hintText: "Confirm Password",
              controller: confirmPassword,
              obsecureText: true,
            ),

            const SizedBox(
              height: 20,
            ),
            MyButton(
              text: "Register",
              ontap: () => register(context),
            ),

            const SizedBox(
              height: 20,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already a member?",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                TextButton(
                  onPressed: widget.ontap,
                  child: Text(
                    "Login",
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
