import 'package:app/DTO/office.dart';
import 'package:app/DTO/users.dart';
import 'package:app/pages/configoffice.dart';
import 'package:app/utils/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeOwner extends StatefulWidget {
  const HomeOwner({Key? key, required this.user}) : super(key: key);

  final UserDTO user;

  @override
  _SignUpState createState() => _SignUpState(user);
}

class _SignUpState extends State<HomeOwner> {
  late final UserDTO user;

  late TextEditingController officeNameController;

  @override
  void initState() {
    super.initState();

    officeNameController = TextEditingController();
  }

  @override
  void dispose() {
    officeNameController.dispose();

    super.dispose();
  }

  _SignUpState(this.user);

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
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Stack(children: [
            SizedBox(
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
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text("Welcome, ${user.name}",
                            //Font Roboto Semi Bold
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Work Offices",
                            //Font Roboto Semi Bold
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                      ),
                      SingleChildScrollView(
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  0,
                                  MediaQuery.of(context).size.height * 0.05,
                                  0,
                                  0),
                              child: user.offices.isEmpty
                                  ? const Text("0 offices created",
                                      //Font Roboto Semi Bold
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold))
                                  : FutureBuilder(
                                      future: officeData(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData)
                                          return Container();

                                        List<Widget> officesItems = [];

                                        if (snapshot.data!.isNotEmpty) {
                                          for (Map<String, dynamic> data
                                              in snapshot.data!) {
                                            final officeDTO = OfficeDTO(
                                                owner: data["Owner"],
                                                name: data["Name"],
                                                blind: data["Blind"],
                                                isLightsOn: data["Lights"],
                                                luminosity: data["Luminosity"],
                                                isHeaterOn: data["Heater"],
                                                temperature:
                                                    data["Temperature"],
                                                employees: data["Employees"]);

                                            officesItems.add(
                                                office(data["ID"], officeDTO));

                                            var item = Container(
                                              height: 30,
                                            );

                                            officesItems.add(item);
                                          }
                                        }
                                        return Column(
                                          children: officesItems,
                                        );
                                      },
                                    ))),
                    ],
                  ),
                ),
              ),
            ),
            plusButton()
          ]),
        ));
  }

  Widget office(String id, OfficeDTO office) {
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
                  SizedBox(
                      height: 50,
                      child: Image.asset("assets/icons/office.png")),
                  const SizedBox(width: 10),
                  Text(office.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Inter",
                          fontSize: 15)),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Icon(CupertinoIcons.thermometer),
                      Text(
                        "${office.temperature.toString()}º",
                        style: const TextStyle(
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Inter",
                            fontSize: 12),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(CupertinoIcons.lightbulb),
                      Text(
                        "${office.luminosity.toString()}%",
                        style: const TextStyle(
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Inter",
                            fontSize: 12),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                          height: 23,
                          child:
                              Image.asset("assets/icons/air-conditioner.png")),
                      Text(office.isHeaterOn ? "ON" : "OFF",
                          style: const TextStyle(
                              color: Colors.lightBlue,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Inter",
                              fontSize: 12))
                    ],
                  ),
                  configOrAttend(id, office)
                ],
              ),
            ],
          ),
        ));
  }

  bool button = true;

  Widget configOrAttend(String id, OfficeDTO office) {
    if (user.kind == "Owner") {
      return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ConfigOffice(id: id, office: office, user: user)));
          },
          child: Container(
              width: 65,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xFF6CAD7C),
              ),
              alignment: Alignment.center,
              child: const Text(
                "Config",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Inter"),
              )));
    } else {
      return GestureDetector(
        onTap: () {
          setState(() {
            button = !button;
          });
        },
        child: Container(
          width: 65,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: button ? const Color(0xFF6CAD7C) : Colors.white,
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
    if (user.kind == "Owner") {
      return Positioned(
          left: MediaQuery.of(context).size.width - 90,
          top: MediaQuery.of(context).size.height - 140,
          child: GestureDetector(
            onTap: () async {
              openCreateOfficeDialog();
            },
            child: Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xFF6CAD7C)),
              child: const Align(
                alignment: Alignment(0, -0.5),
                child: Text("+",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Inter",
                        fontSize: 50,
                        fontWeight: FontWeight.normal)),
              ),
            ),
          ));
    } else {
      return Container();
    }
  }

  Future<String?> openCreateOfficeDialog() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Add an Office"),
            content: TextField(
              autofocus: true,
              cursorColor: const Color(0xFF6CAD7C),
              controller: officeNameController,
              decoration: const InputDecoration(
                hintText: "Office Name",
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6CAD7C)),
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: close,
                  style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.green.shade100)),
                  child: const Text("Close",
                      style:
                          TextStyle(color: Color(0xFF6CAD7C), fontSize: 15))),
              TextButton(
                  onPressed: submit,
                  style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.green.shade100)),
                  child: const Text("Create",
                      style: TextStyle(color: Color(0xFF6CAD7C), fontSize: 15)))
            ],
          ));

  void close() {
    Navigator.of(context).pop();

    officeNameController.clear();
  }

  Future<void> submit() async {
    if (officeNameController.text.trim().isNotEmpty) {
      final office = OfficeDTO(
          owner: user.email,
          name: officeNameController.text.trim(),
          blind: 0,
          isLightsOn: false,
          luminosity: 0,
          isHeaterOn: false,
          temperature: 16,
          employees: <String>[]);

      await FirebaseFirestore.instance
          .collection("Offices")
          .add(office.toJson())
          .then((value) async {
        successMessage(context, "Office created");

        //Atualizar offices do owner
        List<dynamic> userOffices = user.offices;
        userOffices.add(value.id);

        await FirebaseFirestore.instance
            .collection("Users")
            .doc(user.email)
            .update({"Offices": userOffices}).then((value) {
          Navigator.of(context).pop();

          officeNameController.clear();
        }).catchError((error) {
          errorMessage(context, error);
        });
      }).catchError((error) {
        errorMessage(context, error);
      });
    } else {
      errorMessage(context, "The name of the office cannot be empty!");
    }
  }
}
