import 'package:app/pages/ownersetup.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../DTO/users.dart';
import '../utils/reusable.dart';

class ConfigOffice extends StatefulWidget {
  const ConfigOffice({Key? key, required this.user}) : super(key: key);

  final UserDTO user;

  @override
  _SignUpState createState() => _SignUpState(user);
}

class _SignUpState extends State<ConfigOffice> {

  List<bool> _isOpen = [false, false];
  final UserDTO user;
  final TextEditingController _emailTextController = TextEditingController();

  bool lightBool = true;
  bool heaterBool = true;
  double _lightV = 0.00;
  double _heaterV = 12.00;
  double _rollerV = 0.00;

  _SignUpState(this.user);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
                body: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          20, MediaQuery.of(context).size.height * 0.08, 30, 0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              OwnerSetUp(user: user)));
                                },
                                child: const Icon(Icons.arrow_back_ios_new),
                              ),
                              Container(
                                child: Align(
                                  child: Text("Work Office 1",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Inter",
                                          fontSize: 25)),
                                ),
                              ),
                              Container()
                            ],
                          ),
                          SizedBox(height: 40),
                          Saving(),
                          SizedBox(height: 40),
                          Lights("assets/icons/light-bulb.png", "Light Intensity", "LIGHTS OFF"),
                          SizedBox(height: 40),
                          Heater("assets/icons/air-source-heat-pump.png", "Heater", "HEATER OFF"),
                          SizedBox(height: 40),
                          Roller("assets/icons/up-and-down.png", "Roller Blind", "HEATER OFF"),
                          SizedBox(height: 40),
                          expand(),
                          SizedBox(height: 40),
                        ],
                      ))),
            ))));
  }

  Widget expand() {
    return ExpansionPanelList(
      elevation: 0,
      animationDuration: Duration(seconds: 2),
      expansionCallback: (i, isOpen) {
        setState(() {
          _isOpen[i] = !isOpen;
        });

      },
      children: [
        ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Row(children:[
              SizedBox(height: 10),
              Text("Office Tracking", style:TextStyle(fontFamily: "Inter", fontWeight: FontWeight.bold, fontSize:20))]);
          },
          body: calendarDiv(),
          isExpanded: _isOpen[0]
        ),
        ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return Row(children:[
                SizedBox(height: 10),
                Text("Add User", style:TextStyle(fontFamily: "Inter", fontWeight: FontWeight.bold, fontSize:20))]);
            },
          body: addUserDiv(),
          isExpanded: _isOpen[1]
        ),
      ]
    );
  }

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  Widget addUserDiv() {
    return Column(
      children: [
        Text("Insert an email to add a User to this Office:",
            style: TextStyle(fontFamily: "Inter")
        ),
        SizedBox(height: 30),
        reusableTextField("Email", Icons.email_outlined, false,
            _emailTextController, (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your email address";
              } else if (!EmailValidator.validate(value)) {
                return "Please enter a valid email.";
              }
              return null;
            }),
        SizedBox(height: 30),
        firebaseUIButton(context, "Add User", () async {
        }, MediaQuery.of(context).size.width/2, 30),
      ],
    );
  }

  Widget calendarDiv() {
    return Column(
      children: [
        Text(_selectedDay.toString()),
        Text(_focusedDay.toString()),
        TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focusedDay,
          headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay; // update `_focusedDay` here as well
            });
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
        SizedBox(height: 40),
        CardDiv(),
        SizedBox(height: 40),
      ],
    );
  }

  Widget CardDiv() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0, // soften the shadow
              offset: Offset(
                0, // Move to right 5  horizontally
                5.0, // Move to bottom 5 Vertically
              ),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              10, 5, 10, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("assets/icons/profile.png"),
              Text(user.name, style: TextStyle(fontFamily: "Inter", fontSize: 12)),
              Text("Entrada/Saída - 00h00", style: TextStyle(fontFamily: "Inter", fontSize: 12)),

            ],
          ),
        ),
      ),
    );
  }

  Widget Saving() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Color(0xFF6CAD7C),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF6CAD7C),
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
                    Container(
                        height: 50,
                        child: Image.asset("assets/icons/flash.png")),
                    const SizedBox(width: 10),
                    Text("Energy Saving",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Inter",
                            fontSize: 20))
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: 0.2,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Today",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Inter",
                                fontSize: 10),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Icon(CupertinoIcons.arrow_up,
                                  color: Colors.white, size: 20),
                              Text(
                                "22 kW",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Inter",
                                    fontSize: 18),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                        alignment: Alignment(0.2, 0.2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment(0.2, 0.2),
                              child: Text(
                                "This Month",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Inter",
                                    fontSize: 10),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Stack(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment(0, 0),
                                  child: Icon(CupertinoIcons.arrow_up,
                                      color: Colors.white, size: 20),
                                ),
                                Container(
                                  alignment: Alignment(0.35, 0.35),
                                  child: Text(
                                    "22 kW",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Inter",
                                        fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ],
          ),
        ));
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
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
                    Row(
                      children: <Widget>[
                        Switch(
                            value: lightBool,
                            trackColor: trackColor,
                            thumbColor: const MaterialStatePropertyAll<Color>(
                                Color(0xFF6CAD7C)),
                            onChanged: (bool value) {
                              setState(() {
                                lightBool = value;
                              });
                            }),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: _ON_OFF(lightBool, offMessage, "light"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget Heater(String image, String title, String offMessage) {
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
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
                    Row(
                      children: <Widget>[
                        Switch(
                            value: heaterBool,
                            trackColor: trackColor,
                            thumbColor: const MaterialStatePropertyAll<Color>(
                                Color(0xFF6CAD7C)),
                            onChanged: (bool value) {
                              setState(() {
                                heaterBool = value;
                              });
                            }),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: _ON_OFF(heaterBool, offMessage, "heater"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget Roller(String image, String title, String offMessage) {
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
                      child: _ON_OFF(true, offMessage, "roller"),
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
        if (s == "heater") {
          return Heater_ON();
        } else {
          return Roller_ON();
        }
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
        width: MediaQuery.of(context).size.width * 0.75,
        child: Slider(
          value: _lightV,
          label: _lightV.round().toString() + "%",
          onChanged: (value) {
            setState(() {
              _lightV = value;
            });
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
        width: MediaQuery.of(context).size.width * 0.75,
        child: Slider(
          value: _heaterV,
          label: _heaterV.round().toString() + "ºC",
          onChanged: (value) {
            setState(() {
              _heaterV = value;
            });
          },
          min: 12,
          max: 30,
        ),
      ),
    );
  }

  Widget Roller_ON() {
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
        width: MediaQuery.of(context).size.width * 0.75,
        child: Slider(
          value: _rollerV,
          label: _rollerV.round().toString() + "%",
          onChanged: (value) {
            setState(() {
              _rollerV = value;
            });
          },
          min: 0,
          max: 100,
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

  final MaterialStateProperty<Color?> overlayColor =
      MaterialStateProperty.resolveWith<Color?>(
    (Set<MaterialState> states) {
      // Material color when switch is selected.
      if (states.contains(MaterialState.selected)) {
        return Colors.green.shade50;
      }
      // Material color when switch is disabled.
      if (states.contains(MaterialState.disabled)) {
        return Colors.green.shade400;
      }
      // Otherwise return null to set default material color
      // for remaining states such as when the switch is
      // hovered, or focused.
      return null;
    },
  );

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

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
    );
  });
}
