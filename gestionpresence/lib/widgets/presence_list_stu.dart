import 'package:flutter/material.dart';
import 'package:gestionpresence/providers/admin_prof.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import 'presence_stu_status.dart';

class PresenceStudentsWidget extends StatefulWidget {
  const PresenceStudentsWidget(
      this.classId, this.date, this.students, this.savePresencesStudents,
      {super.key});
  final String classId;
  final String date;
  final List<String> students;
  final void Function(List<Presence> preStu) savePresencesStudents;
  @override
  State<PresenceStudentsWidget> createState() => _PresenceStudentsWidgetState();
}

class _PresenceStudentsWidgetState extends State<PresenceStudentsWidget> {
  late final AdminProfProvider adminProfService;
  late final List<bool> _arePresent;

  @override
  void initState() {
    super.initState();
    _arePresent = List.filled(widget.students.length, true);
    adminProfService = Provider.of<AdminProfProvider>(context, listen: false);
    adminProfService.getPresenceByGroupAndDate(widget.classId, widget.date);
  }

  void updatePresence(int index, bool isPresent) {
    _arePresent[index] = isPresent;
  }

  void submit() {
    // generer les presences
    List<Presence> presencesToSave = [];
    for (int i = 0; i < widget.students.length; i++) {
      presencesToSave.add(Presence(
          studentId: widget.students[i],
          isPresent: _arePresent[i],
          date: widget.date,
          classId: widget.classId));
    }
    widget.savePresencesStudents(presencesToSave);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: FutureBuilder(
          future: adminProfService.getPresenceByGroupAndDate(
              widget.classId, widget.date),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Une erreur s\'est produite'),
              );
            }
            if (snapshot.data!.isNotEmpty)
              return Builder(builder: (context) {
                final List<Presence> presencesFromServer = snapshot.data!;
                return Column(
                  children: [
                    for (int i = 0; i < presencesFromServer.length; i++)
                      PresenceStudentStatusWidget(
                          presencesFromServer[i].studentId,
                          i,
                          presencesFromServer[i].isPresent,
                          updatePresence),
                    ElevatedButton(
                        onPressed: submit, child: const Text('Sauvegarder'))
                  ],
                );
              });

            if (snapshot.data!.isEmpty)
              return Column(
                children: [
                  Text("Nouvelle présence: tout présents par défaut"),
                  for (int i = 0; i < widget.students.length; i++)
                    PresenceStudentStatusWidget(
                        widget.students[i], i, _arePresent[i], updatePresence),
                  ElevatedButton(
                      onPressed: submit, child: const Text('Sauvegarder'))
                ],
              );
            return const Center(child: Text('Aucun étudiant'));
            // si les presences ne sont pas encore construites
          }),
    );
  }
}
