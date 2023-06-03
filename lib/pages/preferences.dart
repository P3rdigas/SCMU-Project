import 'package:app/DTO/office.dart';
import 'package:app/DTO/users.dart';
import 'package:app/pages/configoffice.dart';
import 'package:app/pages/front.dart';
import 'package:app/utils/messages.dart';
import 'package:app/utils/reusable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Preferences extends StatefulWidget {
  const Preferences({Key? key, required this.user}) : super(key: key);

  final UserDTO user;

  @override
  _SignUpState createState() => _SignUpState(user);
}

class _SignUpState extends State<Preferences> {

  late double _lightV;
  late double _heaterV;

  void initState() {
    super.initState();

    _lightV = user.luminosity.toDouble();
    _heaterV = user.temperature.toDouble();
  }

  _SignUpState(this.user);
  final UserDTO user;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  30, MediaQuery.of(context).size.height * 0.07, 30, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text("Preferences",
                              //Font Roboto Semi Bold
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold, fontFamily: "Inter")),
                          SizedBox(height: 40),
                          Text("Enter the temperature and light intensity that you prefer to work with, so we can regulate it.",
                              //Font Roboto Semi Bold
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "Inter")),
                          SizedBox(height: 40),
                          Lights("assets/icons/sunny.png", "Light Intensity", "LIGHTS OFF"),
                          SizedBox(height: 40),
                          Heater("assets/icons/hot.png", "Temperature"),
                          SizedBox(height: 20),
                        ],
                      ),
                      firebaseUIButton(context, "Log Out",() async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Front()));
                      }, 0, 50, Colors.red)

                ]),
              ),
            ),
          )),
    );
  }

  Widget Lights(String image, String title, String offMessage) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
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
                    Container(height: 50, child: Image.asset(image)),
                    const SizedBox(width: 10),
                    Text(title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "Inter",
                            fontSize: 15)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: _ON_OFF(true, "", "light"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget Heater(String image, String title) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
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
                    Container(height: 50, child: Image.asset(image)),
                    const SizedBox(width: 10),
                    Text(title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "Inter",
                            fontSize: 15)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: _ON_OFF(true, "", "heater"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _ON_OFF(bool b, String offMessage, String s) {
    if (b) {
      if (s == "light") {
        return Lights_ON();
      } else {
          return Heater_ON();
      }
    } else {
      return Lights_OFF(offMessage);
    }
  }

  Widget Lights_ON() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Color(0xFF6CAD7C),
        inactiveTrackColor: Colors.green.shade100,
        trackShape: RoundedRectSliderTrackShape(),
        thumbColor: Color(0xFF6CAD7C),
        valueIndicatorColor: Color(0xFF6CAD7C),
        showValueIndicator: ShowValueIndicator.always,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.70,
        child: Slider(
          value: _lightV,
          label: _lightV.round().toString() + "%",
          onChanged: (value) async {
            setState(() {
              _lightV = value;
            });
            await FirebaseFirestore.instance
                .collection("Users")
                .doc(user.email)
                .update({"Luminosity": value.round()});
          },
          min: 0,
          max: 100,
        ),
      ),
    );
  }

  Widget Heater_ON() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Color(0xFF6CAD7C),
        inactiveTrackColor: Colors.green.shade100,
        trackShape: RoundedRectSliderTrackShape(),
        thumbColor: Color(0xFF6CAD7C),
        valueIndicatorColor: Color(0xFF6CAD7C),
        showValueIndicator: ShowValueIndicator.always,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.70,
        child: Slider(
          value: _heaterV,
          label: _heaterV.round().toString() + "ºC",
          onChanged: (value) async {
            setState(() {
              _heaterV = value;
            });
            await FirebaseFirestore.instance
                .collection("Users")
                .doc(user.email)
                .update({"Temperature": value.round()});
          },
          min: 16,
          max: 30,
        ),
      ),
    );
  }

  Widget Lights_OFF(String offMessage) {
    return Column(
      children: <Widget>[
        SizedBox(height: 15),
        Text(offMessage,
            style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontFamily: "Inter"))
      ],
    );
  }

  final MaterialStateProperty<Color?> trackColor =
  MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
      // Track color when the switch is selected.
      if (states.contains(MaterialState.selected)) {
        return Colors.green.shade100;
      }
      // Otherwise return null to set default track color
      // for remaining states such as when the switch is
      // hovered, focused, or disabled.
      return null;
    },
  );
}
