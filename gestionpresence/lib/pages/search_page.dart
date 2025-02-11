import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestionpresence/models/user.dart';
import 'package:gestionpresence/providers/admin_prof.dart';
import 'package:provider/provider.dart';

import '../widgets/head_bar.dart';
import 'profile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  static String routeName = "search_page";
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _matricule = 0;
  final TextEditingController _matriculeController = TextEditingController();
  late final AdminProfProvider adminsService;
  CegepUser? userFound;
  String uid = '';

  @override
  void initState() {
    // TODO: implement initState
    adminsService = Provider.of<AdminProfProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    _matriculeController.dispose();
  }

  void _searchUser() async {
    if (_matricule == 0) {
      return;
    }
    final stu = await FirebaseFirestore.instance
        .collection('users')
        .where('matricule', isEqualTo: _matricule)
        .get();
    if (stu.docs.isNotEmpty) {
      uid = stu.docs.first.id;
      //print('uid:' + uid.toString());
      _matriculeController.clear();
      setState(() {
        userFound = CegepUser.fromJson(stu.docs.first.data());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const HeadBar('Rechercher'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text('Rechercher un utilisateur par son matricule: '),
                TextField(
                  decoration: const InputDecoration(labelText: 'Matricule'),
                  controller: _matriculeController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _matricule = int.parse(value);
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    userFound = null;
                    uid = '';
                    //Navigator.of(context).pushNamed('user_profile', arguments: _matricule);
                    _searchUser();
                  },
                  child: const Text('Rechercher'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Retour'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Résultat de la recherche: '),
                ),
                if (userFound != null)
                  Column(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context)
                            .pushReplacementNamed(MyProfile.routeName,
                                arguments: userFound!),
                        child: Text(
                            '${userFound!.userName} ${userFound!.userFamilyName}'),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(Etudiant(
                                etudiantId: uid,
                                etudiantName: userFound!.userName,
                                etudiantFamilyName: userFound!.userFamilyName));
                          },
                          child: Text('Sélectionner'))
                    ],
                  )
                else
                  Text('Aucun utilisateur trouvé'),
              ],
            ),
          ),
        ));
  }
}
