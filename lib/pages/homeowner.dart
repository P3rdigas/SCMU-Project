import 'package:app/pages/configoffice.dart';
import 'package:app/pages/front.dart';
import 'package:app/pages/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:flutter/cupertino.dart';
import '../utils/messages.dart';
import '../utils/reusable.dart';

class HomeOwner extends StatefulWidget {
  const HomeOwner({Key? key, required this.kind}) : super(key: key);
  final String kind;

  @override
  _SignUpState createState() => _SignUpState(kind);
}

class _SignUpState extends State<HomeOwner> {
  late final String kind;
  _SignUpState(this.kind);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Stack(children: [

          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    30, MediaQuery.of(context).size.height * 0.05, 30, 0),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 40,
                      ),
                        Container( child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                              "Welcome, Username",
                              //Font Roboto Semi Bold
                              textAlign: TextAlign.left,
                              style:
                              TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                        ),
                        ),

                      const SizedBox(
                        height: 40,
                      ),
                      Container( child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                            "Work Offices",
                            //Font Roboto Semi Bold
                            textAlign: TextAlign.left,
                            style:
                            TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                      ),
                      ),
                      Container(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                0, MediaQuery.of(context).size.height * 0.05, 0, 0),
                            child: Column(
                              children: <Widget>[
                                office(),
                                SizedBox(height: 30,),

                              ],
                            ),
                          )
                        )
                      ),

                      ],
                  ),
                ),
              ),
            ),
            plusButton()
          ]),
        )
    );
  }

  Widget office() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
          color: Color(0xFFffffff),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 15.0, // soften the shadow
              spreadRadius: 5.0, //extend the shadow
              offset: Offset(
                5.0, // Move to right 5  horizontally
                5.0, // Move to bottom 5 Vertically
              ),
            )
          ],
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).size.height * 0.02, 20, 0),
          child: Column(
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Container(height: 50,child: Image.asset("assets/icons/office.png")),
                  const SizedBox(width:10),
                  Text("Work Office 1",
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Inter", fontSize: 15)
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30,),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Icon(CupertinoIcons.thermometer),
                        Text("23º",
                            style: TextStyle(color: Colors.lightBlue,fontWeight: FontWeight.bold,fontFamily: "Inter",fontSize: 12),
                        ),
                        const SizedBox(width: 5,),
                        Icon(CupertinoIcons.lightbulb),
                        Text("80%",
                          style: TextStyle(color: Colors.lightBlue,fontWeight: FontWeight.bold,fontFamily: "Inter",fontSize: 12),
                        ),
                        const SizedBox(width: 5,),
                        Container(height: 23,child: Image.asset("assets/icons/air-conditioner.png")),
                        Text("ON",
                          style: TextStyle(color: Colors.lightBlue,fontWeight: FontWeight.bold,fontFamily: "Inter",fontSize: 12)
                        )
                      ],
                    ),
                  ),
                  configOrAttend()
                ],
              ),
            ),
          ],

        ),
    ));
  }

  bool button = true;

  Widget configOrAttend() {
    if(!button) {
      print("yauu");
    }
    if(kind == "Owner") {
      return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ConfigOffice()));
          },
          child: Container(
              width: 65,
              height: 40,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
                color: Color(0xFF6CAD7C),
              ),
              alignment: Alignment.center,
              child: Text("Config",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "Inter"),
              )
          ));

    }
    else {
      return GestureDetector(
        onTap: () {
          setState(() {
            button = !button;
            print(button);
          });
        },
        child: Container(
          width: 65,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: button ? Color(0xFF6CAD7C) : Colors.white,
            border: button ? null : Border.all(color: Colors.red, width: 2),
          ),
          alignment: Alignment.center,
          child: Text(
            button ? "Attend" : "Leave",
            style: TextStyle(
              color: button ? Colors.white : Colors.red,
              fontWeight: FontWeight.bold,
              fontFamily: "Inter",
            ),
          ),
        ),
      );
    }
  }

  Widget plusButton() {
    if(kind == "Owner") {
      return Positioned(
          left: MediaQuery.of(context).size.width-90,
          top: MediaQuery.of(context).size.height-140,

          child:GestureDetector(
            child: Container(
              width: 70,
              height: 70,
              child: Align(
                alignment: Alignment(0,-0.5),
                child:Text("+",
                    style: TextStyle(color: Colors.white, fontFamily: "Inter",fontSize: 50, fontWeight: FontWeight.normal)

                ),
              ),
              decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFF6CAD7C)),
            ),
          )
      );
    }
    else {
      return Container();
    }
  }
}
