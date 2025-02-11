import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gestionpresence/models/course.dart';
import 'package:gestionpresence/providers/admin_prof.dart';
import 'package:gestionpresence/widgets/create_period.dart';
import 'package:gestionpresence/widgets/head_bar.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/login_info.dart';
import '../widgets/create_class_form.dart';

class CreateClasses extends StatefulWidget {
  const CreateClasses({super.key});

  static const routeName = 'create_class';
  @override
  State<CreateClasses> createState() => _CreateClassesState();
}

class _CreateClassesState extends State<CreateClasses> {
  //late final LoginInfo userInfo;
  late final AdminProfProvider adminProfService;

  late final List<Course> courses;
  late final List<Prof> profs;

  @override
  void initState() {
    super.initState();
    //userInfo = Provider.of<LoginInfo>(context, listen: false);
    adminProfService = Provider.of<AdminProfProvider>(context, listen: false);
  }

  Future<void> createClass(CourseClass classToCreate) async {
    String documentId =
        '${classToCreate.courseId}-${classToCreate.session}-${classToCreate.groupNo}';
    await FirebaseFirestore.instance
        .collection('classes')
        .doc(documentId)
        .set(classToCreate.tojson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeadBar('Créer une classe'),
      body: FutureBuilder(
          future: adminProfService.fetchDataForCreatingClass(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            return CreateClassesWidget(createClass);
          }),
    );
  }
}
