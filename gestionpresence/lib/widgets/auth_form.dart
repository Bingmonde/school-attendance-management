import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestionpresence/models/user.dart';
import 'package:gestionpresence/widgets/user_picker_image.dart';
import 'package:image_picker/image_picker.dart';

class AuthFormWidget extends StatefulWidget {
  const AuthFormWidget(this._submitForm, {super.key});
  final void Function(
      bool isLogin,
      String email,
      String password,
      int matricule,
      String username,
      String userFamilyName,
      XFile? _myUserImageFile) _submitForm;

  //final CegepUser? user;

  @override
  State<AuthFormWidget> createState() => _AuthFormWidgetState();
}

class _AuthFormWidgetState extends State<AuthFormWidget> {
  final _key = GlobalKey<FormState>();

  var _isLogin = true;
  String _userEmail = "";
  String _userPassword = "";
  int _matricule = 0;
  String _userName = "";
  String _userFamilyName = "";
  XFile? _myUserImageFile;

  void _myPickImage(XFile pickedImage) {
    _myUserImageFile = pickedImage;
  }

  void _submit() {
    final isValid = _key.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (!_isLogin && _myUserImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("SVP Ajouter une image"),
        ),
      );
      return;
    }

    if (isValid ?? false) {
      _key.currentState?.save();

      widget._submitForm(
          _isLogin,
          _userEmail.trim(),
          _userPassword.trim(),
          _matricule,
          _userName.trim(),
          _userFamilyName.trim(),
          _myUserImageFile);
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
            if (!_isLogin) UserImagePicker(_myPickImage),
            TextFormField(
              key: ValueKey("email"),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: "Adresse courriel"),
              validator: (val) {
                if (val!.isEmpty || val.length < 8) {
                  return 'Au moins 7 caracteres.';
                }
                return null;
              },
              onSaved: (value) {
                _userEmail = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Mot de passe"),
              key: ValueKey("password"),
              obscureText: true,
              validator: (val) {
                if (val!.isEmpty || val.length < 8) {
                  return 'Au moins 8 caracteres.';
                }
                return null;
              },
              onSaved: (value) {
                _userPassword = value!;
              },
            ),
            if (!_isLogin)
              TextFormField(
                decoration: InputDecoration(labelText: "Matricule"),
                key: ValueKey("Matricule"),
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Entrez votre nom.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _matricule = int.tryParse(value!) ?? 0;
                },
              ),
            if (!_isLogin)
              TextFormField(
                decoration: InputDecoration(labelText: "Prénom"),
                key: ValueKey("Name"),
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
            if (!_isLogin)
              TextFormField(
                decoration: InputDecoration(labelText: "Nom"),
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
              child: Text(_isLogin ? "Me connecter" : "M'inscrire"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
              child:
                  Text(_isLogin ? "Créer un nouveau compte" : "J'ai un compte"),
            ),
          ]),
        ),
      )),
    ));
  }
}
