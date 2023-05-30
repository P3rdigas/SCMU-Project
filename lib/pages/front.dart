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
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          SizedBox(
            width: screenWidth,
            height: screenHeight * 0.7,
            child: Stack(
              children: [
                Container(
                  width: screenWidth,
                  height: screenHeight * 0.7,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/background.jpg"))),
                ),
                const Positioned(
                    top: 100,
                    left: 66,
                    child: Text("Welcome",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none))),
                const Positioned(
                    top: 140,
                    left: 66,
                    child: Text("OfficeRats",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 23,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none)))
              ],
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: Container(
              width: screenWidth,
              height: screenHeight * 0.35,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Positioned(
                    top: -100,
                    left: 0,
                    child: Image(
                      image: AssetImage("assets/icons/logo.png"),
                      height: 150,
                      width: 150,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        firebaseUIButton(context, "Log In", () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignIn()));
                        }, 0, 50, const Color(0xFF6CAD7C)),
                        firebaseUIButton(context, "Sign Up", () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SignUpQuestion()));
                        }, 0, 50, const Color(0xFF6CAD7C)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
