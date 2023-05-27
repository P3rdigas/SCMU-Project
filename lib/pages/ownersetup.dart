import 'package:app/DTO/users.dart';
import 'package:app/pages/homeowner.dart';
import 'package:flutter/material.dart';

class OwnerSetUp extends StatefulWidget {
  const OwnerSetUp({Key? key, required this.user}) : super(key: key);

  final UserDTO user;

  @override
  _SignInState createState() => _SignInState(user);
}

class _SignInState extends State<OwnerSetUp> {
  late final UserDTO user;

  int _seletedItem = 0;

  final _pageController = PageController();

  _SignInState(this.user);

  @override
  Widget build(BuildContext context) {
    var pages = [HomeOwner(user: user), HomeOwner(user: user)];
    return Scaffold(
      body: PageView(
        onPageChanged: (index) {
          setState(() {
            _seletedItem = index;
          });
        },
        controller: _pageController,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF6CAD7C),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.black), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings, color: Colors.black),
              label: "Preferences"),
        ],
        currentIndex: _seletedItem,
        onTap: (index) {
          setState(() {
            _seletedItem = index;
            _pageController.animateToPage(_seletedItem,
                duration: const Duration(milliseconds: 200),
                curve: Curves.linear);
          });
        },
      ),
    );
  }
}
