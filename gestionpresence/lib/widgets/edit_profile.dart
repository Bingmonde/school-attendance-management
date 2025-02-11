import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestionpresence/pages/profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/login_info.dart';
import 'user_picker_image.dart';

class EditProfile extends StatefulWidget {
  //const EditProfile({this.userToEdit, this.uid, super.key});
  const EditProfile({super.key});
  //final CegepUser? userToEdit;
  //final String? uid;
  static const routeName = 'edit_profile';

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late final LoginInfo userInfo;
  final _key = GlobalKey<FormState>();
  // String _userPassword = "";
  late String _userName = "";
  late String _userFamilyName = "";
  XFile? _myUserImageFile;

  @override
  void initState() {
    super.initState();
    userInfo = Provider.of<LoginInfo>(context, listen: false);
  }

  void _myPickImage(XFile pickedImage) {
    _myUserImageFile = pickedImage;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (_key.currentState!.validate()) {
      _key.currentState!.save();

// verifier si les infos sont modifiées
      if (_myUserImageFile != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child("user_image")
            .child('${userInfo.user_uid}.jpg');
        print('${userInfo.user_uid}.jpg');
        await ref
            .putFile(File(_myUserImageFile!.path))
            .whenComplete((() => true));
        final myUserImageLink = await ref.getDownloadURL();
        userInfo.setUserImage(myUserImageLink);
      }

      if (_userFamilyName != userInfo.getUser.userFamilyName) {
        print(_userFamilyName);
        userInfo.setUserFamilyName(_userFamilyName);
      }
      if (_userName != userInfo.getUser.userName) {
        print(_userName);
        userInfo.setUserName(_userName);
      }

      await userInfo.updateUser();
      Navigator.of(context).pushReplacementNamed(MyProfile.routeName);
    } else if (!_key.currentState!.validate()) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      margin: EdgeInsets.all(20),
      child: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _key,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            UserImagePicker(_myPickImage),
            TextFormField(
              decoration: InputDecoration(labelText: "Prénom"),
              key: ValueKey("Name"),
              initialValue: userInfo.getUser.userName,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Entrez votre prénom.';
                }
                return null;
              },
              onSaved: (value) {
                _userName = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Nom"),
              initialValue: userInfo.getUser.userFamilyName,
              key: ValueKey("FamilyName"),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Entrez votre nom.';
                }
                return null;
              },
              onSaved: (value) {
                _userFamilyName = value!;
              },
            ),
            SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: (() {
                _submit();
              }),
              child: const Text("Modifier"),
            ),
            ElevatedButton(
              onPressed: (() {
                Navigator.of(context).pop();
              }),
              child: const Text("Annuler"),
            ),
            SizedBox(
              height: 50,
            ),
          ]),
        ),
      )),
    ));
  }
}
