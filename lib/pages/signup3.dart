import 'package:app/pages/front.dart';
import 'package:app/pages/signin3.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/messages.dart';
import '../utils/reusable.dart';

class SignUp3 extends StatefulWidget {
  const SignUp3({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp3> {
  final _signUpScreenFormKey = GlobalKey<FormState>();

  TextEditingController passwordTextController = TextEditingController();
  TextEditingController confirmPasswordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController usernameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.05, 20, 0),
                child: Form(
                  key: _signUpScreenFormKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 80,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Front()));
                              },
                              child: Icon(Icons.arrow_back_ios_new),
                            ),
                            Spacer(flex: 2),
                            Text(
                              "Sign Up",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Spacer(flex: 3),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignIn3()));
                              },
                              child: const Text(
                                "",
                                style: TextStyle(
                                    color: const Color(0xFF6CAD7C),
                                    fontSize: 15),
                              ),
                            )
                          ],
                        ),
                      ),
                      reusableTextField("Email", Icons.email_outlined, false,
                          emailTextController, (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email address";
                        } else if (!EmailValidator.validate(value)) {
                          return "Please enter a valid email.";
                        }
                        return null;
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField("Username", Icons.person, false,
                          usernameTextController, (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your username";
                        }
                        return null;
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField("Password", Icons.lock_outline, true,
                          passwordTextController, (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        }
                        return null;
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField("Confirm Password", Icons.lock_outline,
                          true, passwordTextController, (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        }
                        return null;
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      firebaseUIButton(context, "Log In", () async {
                        if (_signUpScreenFormKey.currentState!.validate()) {
                          try {
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: emailTextController.text,
                                    password: passwordTextController.text)
                                .then((value) {
                              successMessage(context, "Signin complete");
                            });
                          } on FirebaseAuthException catch (e) {
                            errorMessage(context, e.message.toString());
                          }
                        }
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
