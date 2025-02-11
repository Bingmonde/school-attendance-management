import 'package:flutter/material.dart';
import 'package:gestionpresence/models/course.dart';
import 'package:gestionpresence/models/user.dart';
import 'package:gestionpresence/pages/search_page.dart';
import 'package:gestionpresence/providers/admin_prof.dart';
import 'package:gestionpresence/widgets/create_period.dart';
import 'package:provider/provider.dart';

import 'add_student_class.dart';

class ModifyClassWidget extends StatefulWidget {
  const ModifyClassWidget(this.cegepClass, this.modifyAClass, this.classId,
      {super.key});
  final CourseClass cegepClass;
  final void Function(
      String classId, List<Period> periods, List<String> students) modifyAClass;
  final String classId;
  @override
  State<ModifyClassWidget> createState() => _ModifyClassWidgetState();
}

class _ModifyClassWidgetState extends State<ModifyClassWidget> {
  late final List<Period> _periods;
  late List<String> _students;

  @override
  void initState() {
    super.initState();
    _periods = [...widget.cegepClass.periods];
    _students = [...widget.cegepClass.students];
  }

  @override
  Widget build(BuildContext context) {
    final AdminProfProvider adminProfService =
        Provider.of<AdminProfProvider>(context, listen: false);

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text('Cours: ${widget.cegepClass.courseId}'),
        Text('Session: ${widget.cegepClass.session}'),
        Text('Groupe:  ${widget.cegepClass.groupNo}'),
        FutureBuilder(
            future: adminProfService.getUserInfo(widget.cegepClass.profId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return Text('Prof: ' +
                  snapshot.data!.userName +
                  ' ' +
                  snapshot.data!.userFamilyName);
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Local: '),
            for (var location in widget.cegepClass.locaux) Text(location + ' '),
          ],
        ),
        CreatePeriod(_periods),
        SizedBox(height: 12),
        Text('Liste d\'étudiants inscrits au cours:'),
        for (var e in _students)
          FutureBuilder(
              future: adminProfService.getUserInfo(e),
              builder: (context, snapshot) {
                //print(e);
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                //print("snapshot: ${snapshot.error}");
                return Text(snapshot.data!.userName +
                    ' ' +
                    snapshot.data!.userFamilyName);
              }),
        // ..._students.map((e) => FutureBuilder(
        //     future: adminProfService.getUserInfo(e),
        //     builder: (context, snapshot) {
        //       //print(e);
        //       if (snapshot.connectionState == ConnectionState.waiting) {
        //         return const CircularProgressIndicator();
        //       }
        //       //print("snapshot: ${snapshot.error}");
        //       return Text(snapshot.data!.userName +
        //           ' ' +
        //           snapshot.data!.userFamilyName);
        //     })),
        ElevatedButton(
          onPressed: () async {
            Etudiant? studentToAdd = await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SearchPage()),
            );
            if (studentToAdd != null) {
              print(studentToAdd.etudiantName);
              setState(() {
                print("add student" + studentToAdd.etudiantId);
                _students.add(studentToAdd.etudiantId);
              });
            }
          },
          child: Text("Ajouter etudiants"),
        ),
        ElevatedButton(
            onPressed: () {
              widget.modifyAClass(widget.classId, _periods, _students);
            },
            child: const Text('Modifier classe')),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Retour'),
        ),
      ]),
    );
  }
}
