import 'package:app/DTO/users.dart';
import 'package:app/pages/front.dart';
import 'package:app/pages/signUpQuestion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/messages.dart';
import '../utils/reusable.dart';
import 'ownersetup.dart';

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
        child: Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.05, 20, 0),
                child: Form(
                  key: _signInScreenFormKey,
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
                              "Log In",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpQuestion()));
                              },
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: Color(0xFF6CAD7C), fontSize: 15),
                              ),
                            )
                          ],
                        ),
                      ),
                      reusableTextField("Email", Icons.email_outlined, false,
                          _emailTextController, (value) {
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
                      reusableTextField("Password", Icons.lock_outline, true,
                          _passwordTextController, (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        }

                        return null;
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      firebaseUIButton(context, "Log In", () async {
                        if (_signInScreenFormKey.currentState!.validate()) {
                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: _emailTextController.text,
                                    password: _passwordTextController.text)
                                .then((value) async {
                              successMessage(context, "Signin complete");

                              await FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(_emailTextController.text)
                                  .get()
                                  .then((DocumentSnapshot doc) {
                                final data = doc.data() as Map<String, dynamic>;

                                final user = UserDTO(
                                    email: data["Email"],
                                    kind: data["Kind"],
                                    luminosity: data["Luminosity"],
                                    name: data["Name"],
                                    temperature: data["Temperature"]);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OwnerSetUp(user: user)));
                              });
                            });
                          } on FirebaseAuthException catch (e) {
                            errorMessage(context, e.message.toString());
                          }
                        }
                      }),
                      //TODO
                      forgetPassword()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Row forgetPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SignUpQuestion()));
          },
          child: const Text("Forgot your password?",
              style: TextStyle(color: Color(0xFF6CAD7C))),
        )
      ],
    );
  }
}
