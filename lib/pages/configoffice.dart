import 'package:app/pages/front.dart';
import 'package:app/pages/ownersetup.dart';
import 'package:flutter/material.dart';

class ConfigOffice extends StatefulWidget {
  const ConfigOffice({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<ConfigOffice> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
    child: Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.08, 30, 0),
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
                            builder: (context) => const OwnerSetUp()));
                  },
                  child: const Icon(Icons.arrow_back_ios_new),
                ),
                Container(
                  child: Align(
                    child: Text("Work Office 1",
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Inter", fontSize: 25)),
                ),

                ),
                Container()
              ],
            )
          ],
        )),
      )
    )
    );
  }
}