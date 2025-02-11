import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gestionpresence/widgets/head_bar.dart';
import 'package:provider/provider.dart';

import '../providers/login_info.dart';

class CreateCourse extends StatefulWidget {
  const CreateCourse({super.key});

  static const routeName = 'create_course';

  @override
  State<CreateCourse> createState() => _CreateCourseState();
}

class _CreateCourseState extends State<CreateCourse> {
  late final LoginInfo userInfo;
  final _key = GlobalKey<FormState>();
  String message = "";

  String _courseCode = "";
  String _courseName = "";

  final TextEditingController _courseCodeController = TextEditingController();
  final TextEditingController _courseNameController = TextEditingController();

  @override
  void dispose() {
    _courseCodeController.dispose();
    _courseNameController.dispose();
    super.dispose();
  }

  void _submit() async {
    FocusScope.of(context).unfocus();
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      // create course in firebase
      try {
        await FirebaseFirestore.instance
            .collection('cours')
            .doc(_courseCode)
            .set({
          'course_code': _courseCode.trim(),
          'course_name': _courseName.trim(),
        });

        _courseCodeController.clear();
        _courseNameController.clear();

        setState(() {
          message = "Le cours $_courseName a été créé avec succès";
        });
      } on FirebaseException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message.toString())));
        print(e.toString());
      }
    }
  }

  void initState() {
    super.initState();
    userInfo = Provider.of<LoginInfo>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const HeadBar('Créer un cours'),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Form(
                key: _key,
                child: Column(
                  children: [
                    TextFormField(
                      key: ValueKey("courseCode"),
                      controller: _courseCodeController,
                      decoration:
                          const InputDecoration(labelText: 'Code du cours'),
                      onChanged: (_) => {message = ""},
                      onSaved: (value) {
                        _courseCode = value!;
                      },
                    ),
                    TextFormField(
                      key: ValueKey("courseName"),
                      controller: _courseNameController,
                      decoration:
                          const InputDecoration(labelText: 'Nom du cours'),
                      onChanged: (value) {
                        _courseName = value;
                      },
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Créer'),
                    ),
                  ],
                )),
            if (message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  message,
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Annuler'))
          ],
        ),
      )),
    );
  }
}
