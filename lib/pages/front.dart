import 'package:app/pages/signUnQuestion.dart';
import 'package:app/pages/signin3.dart';
import 'package:flutter/material.dart';

import '../utils/reusable.dart';

class Front extends StatefulWidget {
  const Front({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<Front> {
  final _signInScreenFormKey = GlobalKey<FormState>();

  //final TextEditingController _passwordTextController = TextEditingController();
  //final TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Image.asset("assets/images/building.jpg",
                    width: 1000, fit: BoxFit.fitWidth),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Form(
                    key: _signInScreenFormKey,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 30,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        firebaseUIButton(context, "Log In", () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignIn3()));
                        }),
                        firebaseUIButton(context, "Sign Up", () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpQuestion()));
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )));
  }

  /*Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpQuestion()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }*/
}
