
import 'package:app/pages/front.dart';
import 'package:app/pages/homeowner.dart';
import 'package:app/pages/signin.dart';
import 'package:app/pages/signup.dart';
import 'package:flutter/material.dart';

import 'ownersetup.dart';




class OwnerSetUp extends StatefulWidget {

  const OwnerSetUp({Key? key, required this.kind}) : super(key: key);
  final String kind;
  @override
  _SignInState createState() => _SignInState(kind);
}

class _SignInState extends State<OwnerSetUp> {
  late final String kind;
  _SignInState(this.kind);
  int _seletedItem = 0;

  var _pageController = PageController();


  @override
  Widget build(BuildContext context) {
    var _pages = [HomeOwner(kind: "Owner"), HomeOwner(kind: "User")];
    return Scaffold(
      body: PageView(
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _seletedItem = index;
          });
        },
        controller: _pageController,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.black), label:"Home"),
          BottomNavigationBarItem(icon: Icon(Icons.settings, color: Colors.black), label:"Preferences"),

        ],
        currentIndex: _seletedItem,
        onTap: (index) {
          setState(() {
            _seletedItem = index;
            _pageController.animateToPage(_seletedItem,
                duration: Duration(milliseconds: 200), curve: Curves.linear);
          });
        },
      ),
    );
  }
}