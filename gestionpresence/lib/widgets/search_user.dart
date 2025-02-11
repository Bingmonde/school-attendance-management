// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../models/user.dart';
// import '../providers/admin_prof.dart';

// class SearchUserWidget extends StatefulWidget {
//   const SearchUserWidget({super.key});

//   @override
//   State<SearchUserWidget> createState() => _SearchUserWidgetState();
// }

// class _SearchUserWidgetState extends State<SearchUserWidget> {
//     int _matricule = 0;
//   final TextEditingController _matriculeController = TextEditingController();
//   late final AdminProfProvider adminsService;
//   CegepUser? userFound;
//   String uid = '';

//   @override
//   void initState() {
//     // TODO: implement initState
//     adminsService = Provider.of<AdminProfProvider>(context, listen: false);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _matriculeController.dispose();
//   }

//     void _searchUser() async {
//     if (_matricule == 0) {
//       return;
//     }
//     final stu = await FirebaseFirestore.instance
//         .collection('users')
//         .where('matricule', isEqualTo: _matricule)
//         .get();
//     if (stu.docs.isNotEmpty) {
//       uid = stu.docs.first.id;
//       //print('uid:' + uid.toString());
//       _matriculeController.clear();
//       setState(() {
//         userFound = CegepUser.fromJson(stu.docs.first.data());
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//               children: [
//                 const Text('Rechercher un utilisateur par son matricule: '),
//                 TextField(
//                   decoration: const InputDecoration(labelText: 'Matricule'),
//                   controller: _matriculeController,
//                   keyboardType: TextInputType.number,
//                   onChanged: (value) {
//                     _matricule = int.parse(value);
//                   },
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     userFound = null;
//                     uid = '';
//                     //Navigator.of(context).pushNamed('user_profile', arguments: _matricule);
//                     _searchUser();
//                   },
//                   child: const Text('Rechercher'),
//                 ),
//                 // ElevatedButton(
//                 //   onPressed: () {
//                 //     Navigator.of(context).pop();
//                 //   },
//                 //   child: const Text('Retour'),
//                 // ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text('Résultat de la recherche: '),
//                 ),
//                 if (userFound != null)
//                   TextButton(
//                     onPressed: () => Navigator.of(context).pushReplacementNamed(
//                         MyProfile.routeName,
//                         arguments: userFound!),
//                     child: Text(
//                         '${userFound!.userName} ${userFound!.userFamilyName}'),
//                   )
//                 else
//                   Text('Aucun utilisateur trouvé'),
//               ],
//             );
//   }
// }