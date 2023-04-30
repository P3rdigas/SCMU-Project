import 'package:app/pages/signup.dart';
import 'package:app/utils/colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/messages.dart';
import '../utils/reusable.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _signInScreenFormKey = GlobalKey<FormState>();

  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [hexStringToColor("CB2B93"),
                  hexStringToColor("9546C4"),
                  hexStringToColor("5E61F4")],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
            )),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Form(
              key: _signInScreenFormKey,
              child: Column(
                children: <Widget>[
                  logoWidget("assets/images/officeIcon.png", null),
                  const SizedBox(
                    height: 30,
                  ),
                  reusableTextField("Enter Email", Icons.email_outlined, false,
                      _emailTextController, (value) {
                        if(value == null || value.isEmpty) {
                          return "Please enter your email address";
                        } else if(!EmailValidator.validate(value)){
                          return "Please enter a valid email.";
                        }

                        return null;
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  reusableTextField("Enter Password", Icons.lock_outline, true,
                      _passwordTextController, (value) {
                        if(value == null || value.isEmpty) {
                          return "Please enter your password";
                        }

                        return null;
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  firebaseUIButton(context, "Login", () async {
                    if(_signInScreenFormKey.currentState!.validate()) {
                      try {
                        await FirebaseAuth.instance
                            .signInWithEmailAndPassword(email: _emailTextController.text, password: _passwordTextController.text)
                            .then((value) {
                          successMessage(context, "Signin complete");
                        });
                      } on FirebaseAuthException catch (e) {
                        errorMessage(context, e.message.toString());
                      }
                    }
                  }),
                  signUpOption()
                ],
              ),
            ),
          ),
        ),
      ),
      )
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUp()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}