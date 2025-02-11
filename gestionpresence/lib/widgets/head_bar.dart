import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestionpresence/providers/login_info.dart';
import 'package:provider/provider.dart';

class HeadBar extends StatelessWidget implements PreferredSizeWidget {
  const HeadBar(this.pageTitle, {super.key});
  final String pageTitle;

  @override
  Widget build(BuildContext context) {
    final LoginInfo loginInfo = Provider.of<LoginInfo>(context, listen: false);
    return AppBar(
      title: Text(pageTitle),
      actions: [
        // logout button  in the app bar
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            // logout the user
            print('logout');
            loginInfo.logout();
            FirebaseAuth.instance.signOut();
            FirebaseAuth.instance.authStateChanges().listen((User? user) {
              if (user == null) {
                Navigator.of(context).pushReplacementNamed('/');
              }
            });
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
