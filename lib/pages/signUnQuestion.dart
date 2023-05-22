import 'package:app/pages/signin3.dart';
import 'package:app/pages/signup3.dart';
import 'package:flutter/material.dart';

import '../utils/reusable.dart';
import 'front.dart';

class SignUpQuestion extends StatelessWidget {
  const SignUpQuestion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.05, 20, 0),
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
                                builder: (context) => const Front()));
                      },
                      child: const Icon(Icons.arrow_back_ios_new),
                    ),
                    const Spacer(flex: 2),
                    const Text(
                      "Sign Up",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    const Spacer(flex: 3),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignIn3()));
                      },
                      child: const Text(
                        "Login",
                        style:
                            TextStyle(color: Color(0xFF6CAD7C), fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              //TODO Parece nao estar bem
              const Center(
                child: Text(
                    "Pretend to use the application as an office owner?",
                    //Font Roboto Semi Bold
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(
                height: 20,
              ),
              firebaseUIButton(context, "Yes", () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        //TODO Mandar parametro a dizer que é um Owner
                        builder: (context) => const SignUp3()));
              }),
              firebaseUIButton(context, "No", () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        //TODO Mandar parametro a dizer que é um User
                        builder: (context) => const SignUp3()));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
