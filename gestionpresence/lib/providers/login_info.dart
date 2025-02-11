import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class LoginInfo with ChangeNotifier {
  late String user_uid;
  late CegepUser user;
  String userRole = 'etudiant';
  // bool isCreatingAccount = false;

  Future<void> setUser(String uid) async {
    user_uid = uid;
    print(uid);
    //await Future.delayed(Duration(seconds: 1));
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (documentSnapshot.exists) {
      user =
          CegepUser.fromJson(documentSnapshot.data() as Map<String, dynamic>);
      print(user.email);
      if (user.role == 'admin') {
        userRole = 'admin';
      } else if (user.role == 'prof') {
        userRole = 'prof';
      }

      // vefirier si l'utilisateur est un admin
      //   DocumentSnapshot documentSnapshotAdmin;

      //   try {
      //     documentSnapshotAdmin = await FirebaseFirestore.instance
      //         .collection('admins')
      //         .doc(uid)
      //         .get();
      //     if (documentSnapshotAdmin.exists) {
      //       userRole = 'admin';
      //       print(userRole);
      //     }
      //   } catch (e) {
      //     userRole = 'etudiant';
      //     print(userRole);
      //     print(e);
      //   }
    }
    notifyListeners();
  }

  void setUID(String uid) {
    user_uid = uid;
  }

//   Future<void> createUser() async {
// final ref = FirebaseStorage.instance
//             .ref()
//             .child("user_image")
//             .child(authResult.user!.uid + '.jpg');
//         await ref.putFile(File(image!.path)).whenComplete((() => true));
//         final myUserImageLink = await ref.getDownloadURL();
//         print(myUserImageLink);

//   }

  CegepUser get getUser => user;
  String get getUserRole => userRole;

  void logout() {
    userRole = '';
    user_uid = '';
    notifyListeners();
  }

  Future<void> updateUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user_uid)
        .update(user.toJson());
    print("user updated" + user.userName);
    notifyListeners();
  }

  void setUserImage(String newUrl) {
    user.imageUrl = newUrl;
    notifyListeners();
  }

  void setUserName(String newName) {
    user.userName = newName;
    notifyListeners();
  }

  void setUserFamilyName(String newFamilyName) {
    user.userFamilyName = newFamilyName;
    notifyListeners();
  }
}
