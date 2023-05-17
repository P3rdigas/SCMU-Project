import 'package:app/pages/signup.dart';
import 'package:app/pages/signup3.dart';
import 'package:app/utils/colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/messages.dart';
import '../utils/reusable.dart';

class SignIn3 extends StatefulWidget {
  const SignIn3({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn3> {
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
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.05, 20, 0),
              child: Form(
                key: _signInScreenFormKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 80,
                      child: Row(

                        children: [
                          Icon(Icons.arrow_back_ios_new),
                          Spacer(),
                          Text(
                            "Log In",
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => SignUp3()));
                            },
                            child: const Text("Register", style: TextStyle(color: const Color(0xFF6CAD7C), fontSize: 15),
                            ),
                          )
                        ],
                      ),
                    ),
                    reusableTextField("Email", Icons.email_outlined, false,
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
                    reusableTextField("Password", Icons.lock_outline, true,
                        _passwordTextController, (value) {
                          if(value == null || value.isEmpty) {
                            return "Please enter your password";
                          }

                          return null;
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    firebaseUIButton(context, "Log In", () async {
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
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUp()));
          },
          child: const Text("Forgot your password?",
              style: TextStyle(color: const Color(0xFF6CAD7C))),
        )
      ],
    );
  }
}