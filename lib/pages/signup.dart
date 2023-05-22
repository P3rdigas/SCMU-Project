import 'package:app/pages/front.dart';
import 'package:app/pages/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

import '../utils/messages.dart';
import '../utils/reusable.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key, required this.kind}) : super(key: key);

  final String kind;

  @override
  _SignUpState createState() => _SignUpState(kind);
}

class _SignUpState extends State<SignUp> {
  late final String kind;

  bool isPasswordValid = false;

  final _signUpScreenFormKey = GlobalKey<FormState>();

  TextEditingController passwordTextController = TextEditingController();
  TextEditingController confirmPasswordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController nameTextController = TextEditingController();

  _SignUpState(this.kind);

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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Front()));
                              },
                              child: const Icon(Icons.arrow_back_ios_new),
                            ),
                            const Text(
                              "Sign Up",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const SignIn()));
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                    color: Color(0xFF6CAD7C), fontSize: 15),
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
                      reusableTextField(
                          "Name", Icons.person, false, nameTextController,
                          (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your name";
                        }
                        return null;
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField("Password", Icons.lock_outline, true,
                          passwordTextController, (value) {
                        if (!isPasswordValid) {
                          return "Please enter a valid password";
                        }
                        return null;
                      }),
                      const SizedBox(
                        height: 10,
                      ),
                      FlutterPwValidator(
                          controller: passwordTextController,
                          minLength: 6,
                          uppercaseCharCount: 1,
                          numericCharCount: 3,
                          specialCharCount: 1,
                          width: 400,
                          height: 150,
                          onSuccess: () {
                            isPasswordValid = true;
                          },
                          onFail: () {
                            isPasswordValid = false;
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField("Confirm Password", Icons.lock_outline,
                          true, confirmPasswordTextController, (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        }

                        if (value != passwordTextController.text) {
                          return "Password mismatch";
                        }
                        return null;
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      firebaseUIButton(context, "Sign Up", () async {
                        if (_signUpScreenFormKey.currentState!.validate()) {
                          try {
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: emailTextController.text.trim(),
                                    password:
                                        passwordTextController.text.trim())
                                .then((value) {
                              addUserDetails(
                                  value.user?.uid,
                                  nameTextController.text.trim(),
                                  emailTextController.text.trim(),
                                  kind);
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

  Future addUserDetails(
      String? uID, String name, String email, String kind) async {
    await FirebaseFirestore.instance.collection("Users").doc(uID).set({
      "Name": name,
      "Email": email,
      "Kind": kind,
      "Temperature": -1,
      "Lights": -1
    });
  }
}
