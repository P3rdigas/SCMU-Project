
import 'package:app/pages/front.dart';
import 'package:app/pages/homeowner.dart';
import 'package:app/pages/signin.dart';
import 'package:app/pages/signup.dart';
import 'package:flutter/material.dart';




class OwnerSetUp extends StatefulWidget {
  const OwnerSetUp({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<OwnerSetUp> {
  int _seletedItem = 0;
  var _pages = [HomeOwner(), SignIn()];
  var _pageController = PageController();

  @override
  Widget build(BuildContext context) {
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