import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Color(0xffffffff),
      ),
      child: Stack(
        children: [
          Positioned(
              left: 0,
              top: 0,
              child: Align(
                child: SizedBox(
                  width: 400,
                  height: 600,
                  child: Image.asset("assets/images/background.jpg"),
                ),
              ))
        ],
      ),
    );
  }
}
