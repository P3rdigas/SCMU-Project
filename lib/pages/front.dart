import 'package:app/pages/signUpQuestion.dart';
import 'package:app/pages/signin.dart';
import 'package:flutter/material.dart';

import '../utils/reusable.dart';

class Front extends StatefulWidget {
  const Front({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<Front> {
  final _signInScreenFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
              body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Image.asset("assets/images/background.jpg",
                      width: 1000, fit: BoxFit.fitWidth),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Form(
                      key: _signInScreenFormKey,
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 10,
                          ),
                          firebaseUIButton(context, "Log In", () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignIn()));
                          }),
                          firebaseUIButton(context, "Sign Up", () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUpQuestion()));
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ))),
      const Positioned(
          child: Text("Welcome",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none)),
          top: 100,
          left: 20),
      const Positioned(
          child: Text("OfficeRats",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 23,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none)),
          top: 150,
          left: 20),
      Positioned(
        child: Image.asset("assets/images/officeIcon.png"),
        top: 430,
        left: 20,
        width: 140,
        height: 140,
      ),
    ]);
  }
}
