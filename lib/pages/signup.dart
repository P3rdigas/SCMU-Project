import 'package:app/pages/home.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/messages.dart';
import '../utils/reusable.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final _signUpScreenFormKey = GlobalKey<FormState>();

  TextEditingController passwordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController usernameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Sign Up",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  hexStringToColor("CB2B93"),
                  hexStringToColor("9546C4"),
                  hexStringToColor("5E61F4")
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)
            ),
            child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
                  child: Form(
                    key: _signUpScreenFormKey,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 20,
                        ),
                        reusableTextField("Enter Username", Icons.person_outline, false, usernameTextController, (value) {
                          if(value == null || value.isEmpty) {
                            return "Please choose a username to use";
                          } else if (value.length < 4) {
                            return "Please choose a username with at least 4 characters";
                          }

                          return null;
                        }),
                        const SizedBox(
                          height: 20,
                        ),
                        reusableTextField("Enter Email", Icons.email_outlined, false, emailTextController, (value) {
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
                        reusableTextField("Enter Password", Icons.lock_outlined, true, passwordTextController, (value) {
                          if(value == null || value.isEmpty) {
                            return "Please enter your password";
                          } else if(value.length < 8 || value.length > 16){
                            return "Your password must have a size between 7 and 17 characters";
                          }

                          return null;
                        }),
                        const SizedBox(
                          height: 20,
                        ),
                        reusableTextField("Confirm Password", Icons.lock_outline, true, null, (value) {
                          if(value == null || value.isEmpty) {
                            return "Please re-enter your password";
                          } else if(value != passwordTextController.text) {
                            return "Passwords mismatch";
                          }

                          return null;
                        }),
                        const SizedBox(
                          height: 20,
                        ),
                        firebaseUIButton(context, "Sign Up", () async {
                          if(_signUpScreenFormKey.currentState!.validate()) {
                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(email: emailTextController.text, password: passwordTextController.text)
                                  .then((value) {
                                    successMessage(context, "Signup complete");
                              });
                            } on FirebaseAuthException catch (e) {
                              errorMessage(context, e.message.toString());
                            }
                          }
                        })
                      ],
                    ),
                  ),
                )
            )
        ),
      ),
    );
  }
}
