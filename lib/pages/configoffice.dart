import 'package:app/DTO/office.dart';
import 'package:app/DTO/records.dart';
import 'package:app/pages/ownersetup.dart';
import 'package:app/utils/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../DTO/users.dart';
import '../utils/reusable.dart';

class ConfigOffice extends StatefulWidget {
  const ConfigOffice(
      {Key? key, required this.id, required this.office, required this.user})
      : super(key: key);

  final String id;
  final OfficeDTO office;
  final UserDTO user;

  @override
  _SignUpState createState() => _SignUpState(id, office, user);
}

class _SignUpState extends State<ConfigOffice> {
  final List<bool> _isOpen = [false, false];

  final String id;
  final OfficeDTO office;
  final UserDTO user;

  late TextEditingController _emailTextController;
  List<RecordDTO> records = [];

  late bool lightBool;
  late bool heaterBool;
  late bool lightBoolAutomatic;
  late bool heaterBoolAutomatic;
  late double _lightV;
  late double _heaterV;
  late double _rollerV;

  @override
  void initState() {
    super.initState();

    _emailTextController = TextEditingController();

    lightBool = office.isLightsOn;
    heaterBool = office.isHeaterOn;
    lightBoolAutomatic = office.lightsBoolAutomatic;
    heaterBoolAutomatic = office.heaterBoolAutomatic;
    _lightV = office.luminosity.toDouble();
    _heaterV = office.temperature.toDouble();
    _rollerV = office.blind.toDouble();
    getRecordsFromFirebase();
  }

  @override
  void dispose() {
    _emailTextController.dispose();

    super.dispose();
  }

  _SignUpState(this.id, this.office, this.user);

  void getRecordsFromFirebase() async {
    await FirebaseFirestore.instance
        .collection("Offices")
        .doc(id)
        .collection("Records")
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = docSnapshot.data();
        Timestamp ts = data["Day"] as Timestamp;
        final record = RecordDTO(
            day: ts.toDate(), email: data["Email"], type: data["Type"]);
        records.add(record);
      }
    });
  }

  List<Widget> recordsData(DateTime selectedDay) {
    List<Widget> recordsData = [];

    if (records.isEmpty) {
      var item = const Text("No records created",
          //Font Roboto Semi Bold
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold));

      recordsData.add(item);
    } else {
      for (RecordDTO record in records) {
        DateTime recordDate = record.day;
        if (recordDate.day == selectedDay.day &&
            recordDate.month == selectedDay.month &&
            recordDate.year == selectedDay.year) {
          String hours = "${recordDate.hour}h${recordDate.minute}";
          var item = CardDiv(record.email, record.type, hours);
          recordsData.add(item);
          item = const SizedBox(
            height: 10,
          );
          recordsData.add(item);
        }
      }
    }

    return recordsData;
  }

  Future<List<dynamic>> officeData() async {
    List<dynamic> officesData = [];

    for (String officeId in user.offices) {
      await FirebaseFirestore.instance
          .collection("Offices")
          .doc(officeId)
          .get()
          .then((DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data["ID"] = doc.id;
        officesData.add(data);
      });
    }

    return officesData;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
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
                              Align(
                                child: Text(office.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Inter",
                                        fontSize: 25)),
                              ),
                              Container()
                            ],
                          ),
                          const SizedBox(height: 40),
                          Saving(),
                          const SizedBox(height: 40),
                          Lights("assets/icons/light-bulb.png",
                              "Light Intensity", "LIGHTS OFF"),
                          const SizedBox(height: 40),
                          Heater("assets/icons/air-source-heat-pump.png",
                              "Heater", "HEATER OFF"),
                          const SizedBox(height: 40),
                          Roller("assets/icons/up-and-down.png", "Roller Blind",
                              "HEATER OFF"),
                          const SizedBox(height: 40),
                          expand(),
                          const SizedBox(height: 40),
                        ],
                      ))),
            ))));
  }

  Widget expand() {
    return ExpansionPanelList(
        elevation: 0,
        animationDuration: const Duration(seconds: 2),
        expansionCallback: (i, isOpen) {
          setState(() {
            _isOpen[i] = !isOpen;
          });
        },
        children: [
          ExpansionPanel(
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return Row(children: const [
                  SizedBox(height: 10),
                  Text("Office Tracking",
                      style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.bold,
                          fontSize: 20))
                ]);
              },
              body: calendarDiv(),
              isExpanded: _isOpen[0]),
          ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return Row(children: const [
                  SizedBox(height: 10),
                  Text("Add User",
                      style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.bold,
                          fontSize: 20))
                ]);
              },
              body: addUserDiv(),
              isExpanded: _isOpen[1]),
        ]);
  }

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  Widget addUserDiv() {
    return Column(
      children: [
        const Text("Insert an email to add a User to this Office:",
            style: TextStyle(fontFamily: "Inter")),
        const SizedBox(height: 30),
        reusableTextField(
            "Email", Icons.email_outlined, false, _emailTextController,
            (value) {
          if (value == null || value.isEmpty) {
            return "Please enter your email address";
          } else if (!EmailValidator.validate(value)) {
            return "Please enter a valid email.";
          }
          return null;
        }),
        const SizedBox(height: 30),
        firebaseUIButton(context, "Add User", () async {
          String email = _emailTextController.text.trim();

          var docRef =
              FirebaseFirestore.instance.collection("Users").doc(email);

          docRef.get().then((doc) async {
            if (doc.exists) {
              List<dynamic> employees = office.employees;

              if (employees.contains(email)) {
                errorMessage(context, "That user is already an employee");
              } else {
                employees.add(email);
                await FirebaseFirestore.instance
                    .collection("Offices")
                    .doc(id)
                    .update({"Employees": employees});

                List<dynamic> offices = doc.data()!["Offices"];
                offices.add(id);

                await FirebaseFirestore.instance
                    .collection("Users")
                    .doc(email)
                    .update({"Offices": offices});

                successMessage(context, "User added");
              }
            } else {
              errorMessage(context, "No user with that email");
            }
          });
        }, MediaQuery.of(context).size.width / 2, 30, const Color(0xFF6CAD7C)),
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
          headerStyle: const HeaderStyle(
              formatButtonVisible: false, titleCentered: true),
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
        const SizedBox(height: 40),
        Column(
          children: recordsData(_selectedDay),
        ),
        //CardDiv(),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget CardDiv(String email, String type, String hours) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
          boxShadow: const [
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
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("assets/icons/profile.png"),
              Text(email,
                  style: const TextStyle(fontFamily: "Inter", fontSize: 12)),
              Text("$type - $hours",
                  style: const TextStyle(fontFamily: "Inter", fontSize: 12)),
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
          color: const Color(0xFF6CAD7C),
          boxShadow: const [
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
              Row(
                children: <Widget>[
                  SizedBox(
                      height: 50, child: Image.asset("assets/icons/flash.png")),
                  const SizedBox(width: 10),
                  const Text("Energy Saving",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Inter",
                          fontSize: 20))
                ],
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
              Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          "Today",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Inter",
                              fontSize: 10),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: const <Widget>[
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
                      alignment: const Alignment(0.2, 0.2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: const Alignment(0.2, 0.2),
                            child: const Text(
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
                                alignment: const Alignment(0, 0),
                                child: const Icon(CupertinoIcons.arrow_up,
                                    color: Colors.white, size: 20),
                              ),
                              Container(
                                alignment: const Alignment(0.35, 0.35),
                                child: const Text(
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
            ],
          ),
        ));
  }

  Widget Lights(String image, String title, String offMessage) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 230,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color(0xFFffffff),
          boxShadow: const [
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(height: 50, child: Image.asset(image)),
                      const SizedBox(width: 10),
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Inter",
                              fontSize: 15)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Switch(
                          value: lightBool,
                          trackColor: trackColorGreen,
                          thumbColor: const MaterialStatePropertyAll<Color>(
                              Color(0xFF6CAD7C)),
                          onChanged: (bool value) async {
                            setState(() {
                              lightBool = value;
                            });

                            await FirebaseFirestore.instance
                                .collection("Offices")
                                .doc(id)
                                .update({"Lights": value});
                          }),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: _ON_OFF(lightBool, offMessage, "light"),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget Heater(String image, String title, String offMessage) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 230,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color(0xFFffffff),
          boxShadow: const [
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(height: 50, child: Image.asset(image)),
                      const SizedBox(width: 10),
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Inter",
                              fontSize: 15)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Switch(
                          value: heaterBool,
                          trackColor: trackColorGreen,
                          thumbColor: const MaterialStatePropertyAll<Color>(
                              Color(0xFF6CAD7C)),
                          onChanged: (bool value) async {
                            setState(() {
                              heaterBool = value;
                            });

                            await FirebaseFirestore.instance
                                .collection("Offices")
                                .doc(id)
                                .update({"Heater": value});
                          }),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: _ON_OFF(heaterBool, offMessage, "heater"),
                  ),
                ],
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
          color: const Color(0xFFffffff),
          boxShadow: const [
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
              Row(
                children: <Widget>[
                  SizedBox(height: 50, child: Image.asset(image)),
                  const SizedBox(width: 10),
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Inter",
                          fontSize: 15)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: _ON_OFF(true, offMessage, "roller"),
                  ),
                ],
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
    return Column(
      children: [
        Text("Switch ON to control the lights:",
            style: const TextStyle(
              color: Color(0xFF6CAD7C),
              fontWeight: FontWeight.bold,
              fontFamily: "Inter",
            )
        ),
        SizedBox(height: 10),
        Switch(
            value: lightBoolAutomatic,
            trackColor: trackColorGreen,
            thumbColor: const MaterialStatePropertyAll<Color>(
                Color(0xFF6CAD7C)),
            onChanged: (bool value) async {
              setState(() {
                if(!value) {
                  calculateAverageTemperature(id, office, heaterBoolAutomatic, lightBoolAutomatic);
                }
                lightBoolAutomatic = value;
              });

              await FirebaseFirestore.instance
                  .collection("Offices")
                  .doc(id)
                  .update({"automatic_light": value});
            }),

        automaticLights(),
      ],
    );
  }

  Widget automaticLights() {
    if(!lightBoolAutomatic) {
      return SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFF6CAD7C),
                  inactiveTrackColor: Colors.green.shade100,
                  trackShape: const RoundedRectSliderTrackShape(),
                  thumbColor: const Color(0xFF6CAD7C),
                  valueIndicatorColor: const Color(0xFF6CAD7C),
                  showValueIndicator: ShowValueIndicator.always,
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Slider(
                    value: _lightV,
                    label: "${_lightV.round()}%",
                    onChanged: (value) async {
                      setState(() {
                        _lightV = value;
                      });

                      await FirebaseFirestore.instance
                          .collection("Offices")
                          .doc(id)
                          .update({"target_Luminosity": value.round()});
                    },
                    min: 0,
                    max: 100,
                  ),
                ),
      );
    }
    else {
      return Column(
        children: [
          SizedBox(height: 15),
          Text("AUTOMATIC LIGHTS",
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontFamily: "Inter",
              )
          ),
        ],
      );
    }
  }

  Widget Heater_ON() {
    return Column(
      children: [
        Text("Switch ON to control the heater:",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF6CAD7C),
              fontWeight: FontWeight.bold,
              fontFamily: "Inter",

            )
        ),
        SizedBox(height: 10),
        Switch(
            value: heaterBoolAutomatic,
            trackColor: trackColorGreen,
            thumbColor: const MaterialStatePropertyAll<Color>(
                Color(0xFF6CAD7C)),
            onChanged: (bool value) async {
              setState(() {
                if(!value) {
                  calculateAverageTemperature(id, office, heaterBoolAutomatic, lightBoolAutomatic);
                }
                heaterBoolAutomatic = value;
              });

              await FirebaseFirestore.instance
                  .collection("Offices")
                  .doc(id)
                  .update({"automatic_Temperature": value});
            }),
        automaticHeater(),
      ],
    );
  }

  Widget automaticHeater() {
    if(!heaterBoolAutomatic) {
      return SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: const Color(0xFF6CAD7C),
          inactiveTrackColor: Colors.green.shade100,
          trackShape: const RoundedRectSliderTrackShape(),
          thumbColor: const Color(0xFF6CAD7C),
          valueIndicatorColor: const Color(0xFF6CAD7C),
          showValueIndicator: ShowValueIndicator.always,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: Slider(
            value: _heaterV,
            label: "${_lightV.round()}ºC",
            onChanged: (value) async {
              setState(() {
                _heaterV = value;
              });

              await FirebaseFirestore.instance
                  .collection("Offices")
                  .doc(id)
                  .update({"target_Temperature": value.round()});
            },
            min: 16,
            max: 30,
          ),
        ),
      );
    }
    else {
      return Column(
        children: [
          SizedBox(height: 15),
          Text("AUTOMATIC HEATER",
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontFamily: "Inter",
              )
          ),
        ],
      );
    }
  }

  Widget Roller_ON() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: const Color(0xFF6CAD7C),
        inactiveTrackColor: Colors.green.shade100,
        trackShape: const RoundedRectSliderTrackShape(),
        thumbColor: const Color(0xFF6CAD7C),
        valueIndicatorColor: const Color(0xFF6CAD7C),
        showValueIndicator: ShowValueIndicator.always,
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Slider(
          value: _rollerV,
          label: "${_rollerV.round()}%",
          onChanged: (value) async {
            setState(() {
              _rollerV = value;
            });

            await FirebaseFirestore.instance
                .collection("Offices")
                .doc(id)
                .update({"Blind": value.round()});
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
        const SizedBox(height: 35),
        Text(offMessage,
            style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontFamily: "Inter",
                fontSize: 20
            ))
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

  final MaterialStateProperty<Color?> trackColorGreen =
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

  final MaterialStateProperty<Color?> trackColorBlue =
  MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
      // Track color when the switch is selected.
      if (states.contains(MaterialState.selected)) {
        return Colors.blue.shade100;
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
