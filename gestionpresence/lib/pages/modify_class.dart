import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestionpresence/others/my_modal_route.dart';
import 'package:gestionpresence/providers/admin_prof.dart';
import 'package:gestionpresence/widgets/head_bar.dart';
import 'package:gestionpresence/widgets/modify_class.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';

class ModifyClass extends StatelessWidget {
  const ModifyClass({super.key});
  static String routeName = "modify_class";

  Future<void> modifyAClass(
      String classId, List<Period> periods, List<String> students) async {
    try {
      print('classId: $classId');
      print('periods: $periods');
      print('students: $students');
      await FirebaseFirestore.instance
          .collection('classes')
          .doc(classId)
          .update({
        'students': students,
        'periods': periods.map((e) => e.tojson()).toList()
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AdminProfService =
        Provider.of<AdminProfProvider>(context, listen: false);
    // final String classId = (ModalRoute.of(context)?.settings.arguments
    //     as Map<String, String>)['classId'] as String;
    final String classId = (MyModalRoute.of(context)?.settings.arguments
        as Map<String, String>)['classId'] as String;

    return Scaffold(
      appBar: const HeadBar(
        'Modifier une classe',
      ),
      body: Center(
          child: FutureBuilder(
              future: AdminProfService.findClass(classId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return ModifyClassWidget(
                  snapshot.data!,
                  modifyAClass,
                  classId,
                );
              })),
    );
  }
}
