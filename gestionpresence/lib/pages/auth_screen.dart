import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gestionpresence/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/login_info.dart';
import '../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  //final CegepUser? userToEdit;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final auth = FirebaseAuth.instance;
  late final LoginInfo userInfo;

  Future<void> _submitAuthForm(
    bool isLogin,
    String email,
    String password,
    int matricule,
    String username,
    String userFamilyName,
    XFile? image,
  ) async {
    UserCredential authResult;
    try {
      if (isLogin) {
        authResult = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        // // vérifier si l'utilisateur existe déjà par son matricule
        // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        //     .collection('users')
        //     .where('matricule', isEqualTo: matricule)
        //     .get();
        // if (querySnapshot.docs.isNotEmpty) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(
        //       content: Text("Cet utilisateur existe déjà."),
        //     ),
        //   );
        // } else {
        authResult = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child("user_image")
            .child(authResult.user!.uid + '.jpg');
        await ref.putFile(File(image!.path)).whenComplete((() => true));
        final myUserImageLink = await ref.getDownloadURL();
        print(myUserImageLink);

        print("begin to save in firestore");
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'email': email,
          'matricule': matricule,
          'user_name': username,
          'user_familyname': userFamilyName,
          'image_url': myUserImageLink,
          'role': 'etudiant',
        });
        print("Utilisateur créé avec succès");
        userInfo.setUser(authResult.user!.uid);
        //}
      }
    } on FirebaseException catch (e) {
      var message = "Un erreur s'est produite.";

      if (e.message != null) {
        message = e.message!;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (err) {
      print("Erreur non géré $err");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userInfo = Provider.of<LoginInfo>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: AuthFormWidget(_submitAuthForm));
  }
}
