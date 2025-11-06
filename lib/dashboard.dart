import 'package:flutter/material.dart';
import 'package:mk_one/calendarscreen.dart';
import 'package:mk_one/homescreen.dart';
import 'package:mk_one/notificationscreen.dart';
import 'package:mk_one/profilescreen.dart';
import 'package:mk_one/task_creation.dart';

class Dashboard1 extends StatefulWidget {
  const Dashboard1({super.key});

  @override
  State<Dashboard1> createState() => _Dashboard1State();
}

class _Dashboard1State extends State<Dashboard1> {
  int _selectedIndex = 0;

  // List of pages for navigation
  final List<Widget> _pages = [
    const Homescreen(),
    const Calendarscreen(),
    const Notificationscreen(),
    const Profilescreen(),
    const TaskCreation(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget taskItem(String title, bool done) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle : Icons.radio_button_unchecked,
            color: done ? Colors.black : Colors.black,
          ),
          const SizedBox(width: 5),
          Text(title,
              style: TextStyle(
                color: done ? Colors.black : Colors.black,
                decoration: done ? TextDecoration.lineThrough : null,
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        floatingActionButton: SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            shape: const CircleBorder(),
            backgroundColor: Colors.deepOrangeAccent,
            foregroundColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => TaskCreation(),
                ),
              );
            },
            child: const Icon(Icons.add, size: 30),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          color: Colors.black,
          child: BottomAppBar(
            shape: const AutomaticNotchedShape(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              // CircularNotchedRectangle(), // ✅ Correct usage
            ),
            elevation: 5,
            color: Colors.grey.shade900,
            notchMargin: 9.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _navIcon(Icons.home, 0),
                    _navIcon(Icons.calendar_month, 1),
                  ],
                ),
                Row(
                  children: [
                    _navIcon(Icons.notifications, 2),
                    _navIcon(Icons.person, 3),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  /// Helper for nav icons
  Widget _navIcon(IconData icon, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: IconButton(
        onPressed: () => _onItemTapped(index),
        icon: Icon(
          icon,
          size: 30,
          color:
              _selectedIndex == index ? Colors.deepOrangeAccent : Colors.white,
        ),
      ),
    );
  }
}

class CircularNotchedAndRoundedShape extends NotchedShape {
  final double radius;
  const CircularNotchedAndRoundedShape({this.radius = 25});

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    const notchRadius = 38.0;
    final r = radius;

    final path = Path()
      ..moveTo(0, host.top + r)
      ..quadraticBezierTo(0, host.top, r, host.top)
      ..lineTo(host.center.dx - notchRadius, host.top)
      ..arcToPoint(
        Offset(host.center.dx + notchRadius, host.top),
        radius: const Radius.circular(notchRadius + 4),
        clockwise: false,
      )
      ..lineTo(host.right - r, host.top)
      ..quadraticBezierTo(host.right, host.top, host.right, host.top + r)
      ..lineTo(host.right, host.bottom)
      ..lineTo(0, host.bottom)
      ..close();

    return path;
  }
}
