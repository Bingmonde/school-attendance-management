import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gestionpresence/models/user.dart';
import 'package:gestionpresence/pages/auth_screen.dart';
import 'package:gestionpresence/providers/admin_prof.dart';
import 'package:gestionpresence/providers/login_info.dart';
import 'package:gestionpresence/widgets/edit_profile.dart';
import 'package:provider/provider.dart';

import '../widgets/foot_bar.dart';
import '../widgets/head_bar.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  static String routeName = "my_profile";

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<LoginInfo>(context, listen: true);
    final adminService = Provider.of<AdminProfProvider>(context, listen: false);
    final user = ModalRoute.of(context)!.settings.arguments as CegepUser;
    return Scaffold(
        appBar: const HeadBar('Mon Profil'),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(user.imageUrl),
                ),
                SizedBox(height: 16),
                Text(
                  '${user.role}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${user.userName} ${user.userFamilyName}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Matricule: ${user.matricule}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Email: ${user.email}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                // le droit de modification est réservé à l'utilisateur lui-même ou à l'admin
                if (userInfo.getUser.email == user.email ||
                    userInfo.getUserRole == 'admin')
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(EditProfile.routeName);
                      },
                      child: Text('Modifier')),
                // le droit de changer le rôle est réservé à l'admin
                if (userInfo.getUserRole == 'admin' && user.role == 'etudiant')
                  ElevatedButton(
                    onPressed: () async {
                      await adminService.changeRole(user.matricule);
                      setState(() {
                        user.role = 'prof';
                      });
                    },
                    child: const Text('Changer de rôle à professeur'),
                  ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: FootBar());
  }
}
