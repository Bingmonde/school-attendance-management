import 'package:flutter/material.dart';
import 'package:gestionpresence/pages/calendrier.dart';
import 'package:gestionpresence/pages/profile.dart';
import 'package:provider/provider.dart';

import '../pages/accueil.dart';
import '../providers/login_info.dart';

class FootBar extends StatefulWidget {
  FootBar({super.key});

  @override
  State<FootBar> createState() => _FootBarState();
}

class _FootBarState extends State<FootBar> {
  int _currentIndex = 0;
  late final LoginInfo user;

  Future<void> goGoPage(BuildContext context, int index) async {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed(PageAcceuil.routeName);
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed(PageCalendrier.routeName);
        break;
      case 2:
        break;
      case 3:
        Navigator.of(context)
            .pushReplacementNamed(MyProfile.routeName, arguments: user.getUser);
        break;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = Provider.of<LoginInfo>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        // type: BottomNavigationBarType.fixed,
        //backgroundColor: Colors.black,
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.calendar_today),
            label: 'Calendrier',
          ),
          // BottomNavigationBarItem(
          //   backgroundColor: Colors.black,
          //   icon: Icon(Icons.chat),
          //   label: 'Chat',
          // ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.class_),
            label: 'Presence',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        onTap: (int index) async {
          goGoPage(context, index);
        });
  }
}
