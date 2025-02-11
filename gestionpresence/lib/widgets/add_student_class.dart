import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/admin_prof.dart';

class AddStudents extends StatefulWidget {
  const AddStudents(this.selectedStudents, {super.key});
  final List<String> selectedStudents;

  @override
  State<AddStudents> createState() => _AddStudentsState();
}

class _AddStudentsState extends State<AddStudents> {
  late final AdminProfProvider adminProfService;

  @override
  void initState() {
    super.initState();
    adminProfService = Provider.of<AdminProfProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final students = adminProfService.students;
    return ListView.builder(
        shrinkWrap: true,
        itemCount: students.length,
        itemBuilder: (context, index) {
          final aStu = students[index];
          return CheckboxListTile(
              title: Text(students[index].etudiantName +
                  ' ' +
                  students[index].etudiantFamilyName),
              value:
                  widget.selectedStudents.contains(students[index].etudiantId),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    widget.selectedStudents.add(students[index].etudiantId);
                  } else {
                    widget.selectedStudents.remove(students[index].etudiantId);
                  }
                });
              });
        });
  }
}
