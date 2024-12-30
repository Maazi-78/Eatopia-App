import 'package:eatopia/pages/Customer/cart.dart';
import 'package:eatopia/pages/Customer/user_more.dart';
import 'package:flutter/material.dart';
import 'package:eatopia/utilities/colours.dart';
import 'package:eatopia/pages/Customer/user_main_home.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  List<Widget> headings = [
    const Text('Home'),
    const Text('Cart'),
    const Text('More')
  ];
  int selectedIndex = 0;
  final pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        unselectedIconTheme: const IconThemeData(
          color: Colors.grey,
        ),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_outlined),
            label: 'Profile',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: appGreen,
        onTap: (index) => setState(() {
          selectedIndex = index;
          pageController.animateToPage(index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        }),
      ),
      appBar: AppBar(
        elevation: 0,
        title: headings[selectedIndex],
        backgroundColor: appGreen,
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: const [
          UserMainHome(),
          cart(),
          UserMore(),
        ],
      ),
    );
  }
}
