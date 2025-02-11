import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestionpresence/models/user.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/admin_prof.dart';
import 'add_student_class.dart';
import 'create_period.dart';

class CreateClassesWidget extends StatefulWidget {
  const CreateClassesWidget(this.createClass, {super.key});
  final void Function(CourseClass classToCreate) createClass;

  @override
  State<CreateClassesWidget> createState() => _CreateClassesWidgetState();
}

class _CreateClassesWidgetState extends State<CreateClassesWidget> {
  late final AdminProfProvider adminProfService;

  final _key = GlobalKey<FormState>();
  String message = "";

  String? _courseId;
  String _groupNo = "";
  String _session = "";
  String? _profId;
  List<String> _locations = [];
  List<String> _students = [];
  List<Period> _periods = [];

  String _message = '';

  TextEditingController _sessionController = TextEditingController();
  TextEditingController _groupNoController = TextEditingController();
  TextEditingController _locationsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    adminProfService = Provider.of<AdminProfProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    _sessionController.dispose();
    _groupNoController.dispose();
    _locationsController.dispose();
  }

  // void addPeriod(int weekDay, String startTime, String endTime) {
  //   setState(() {
  //     _periods.add(
  //         Period(weekDay: weekDay, startTime: startTime, endTime: endTime));
  //   });
  // }

  void _submit() {
    // if (_periods.length == 0 || _students.isEmpty) {
    //   _message = 'Veuillez ajouter au moins une période, et étudiant';
    //   print('Veuillez ajouter au moins une période, étudiant');
    //   return;
    // }
    FocusScope.of(context).unfocus();
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      print(_courseId);
      print(_groupNo);
      print(_session);
      print(_profId);
      print(_locations);
      print(_students);
      print(_periods);

      final classToCreate = CourseClass(
          courseId: _courseId!.trim(),
          groupNo: _groupNo.trim(),
          session: _session.trim(),
          profId: _profId!.trim(),
          locaux: _locations,
          students: _students,
          periods: _periods);
      try {
        widget.createClass(classToCreate);

        setState(() {
          _message = 'Classe créée avec succès';
          _courseId = null;
          _groupNo = '';
          _session = '';
          _profId = null;
          _locations = [];
          _students = [];
          _periods = [];
          _key.currentState!.reset();
        });
      } catch (e) {
        setState(() {
          _message = 'Erreur lors de la création de la classe';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Course> courses = adminProfService.courses;
    final List<Prof> profs = adminProfService.profs;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Cours',
                textAlign: TextAlign.left,
              ),
              DropdownMenu(
                initialSelection: _courseId,
                dropdownMenuEntries: courses.map((e) {
                  return DropdownMenuEntry(
                    value: e.courseCode,
                    label: e.courseName,
                  );
                }).toList(),
                onSelected: (value) {
                  setState(() {
                    _courseId = value!;
                    _message = '';
                  });
                },
                // validator: (value) {
                //   if (value == null) {
                //     return 'Veuillez choisir un cours';
                //   }
                //   return null;
                // },
                // onSaved: (value) {
                //   _courseId = value!;
                // },
              ),
              // TextFormField for session
              SizedBox(height: 12),
              TextFormField(
                controller: _sessionController,
                decoration: const InputDecoration(
                  labelText: 'Session',
                  //border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer la session';
                  }
                  return null;
                },
                onSaved: (value) {
                  _session = value!;
                },
              ),
              // TextFormField for group number
              SizedBox(height: 12),
              TextFormField(
                controller: _groupNoController,
                decoration: const InputDecoration(
                  labelText: 'Numéro de groupe',
                  //border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer le numéro de groupe';
                  }
                  return null;
                },
                onSaved: (value) {
                  _groupNo = value!;
                },
              ),
              // DropdownButtonFormField for selecting professor
              SizedBox(height: 12),
              Text('Professeur'),
              DropdownButtonFormField(
                  value: _profId,
                  items: profs.map((e) {
                    return DropdownMenuItem(
                      value: e.profId,
                      child: Text(e.profName + ' ' + e.profFamilyName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _profId = value!;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Veuillez choisir un prof' : null,
                  onSaved: (value) {
                    _profId = value!;
                  }),
              // TextFormField for locations
              SizedBox(height: 12),
              TextFormField(
                controller: _locationsController,
                decoration: const InputDecoration(
                  labelText: 'Locaux',
                  //border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer les locaux';
                  }
                  return null;
                },
                onSaved: (value) {
                  _locations = value!.split(',');
                },
              ),

              SizedBox(height: 12),
              CreatePeriod(_periods),
              SizedBox(height: 12),
              Text('Liste d\'étudiants'),
              AddStudents(_students),

              // if (_studentsNames.isNotEmpty)
              //   Column(
              //     children: [
              //       Text('Étudiants'),
              //       ..._studentsNames.map((e) {
              //         return ListTile(
              //           title: Text(e),
              //         );
              //       }).toList(),
              //     ],
              //   ),

              // DropdownButtonFormField(
              //   decoration: InputDecoration(
              //     labelText: 'Sélectionner Student',
              //     border: OutlineInputBorder(),
              //   ),
              //   validator: (value) =>
              //       value == null ? 'Sélectionner un étudiant' : null,
              //   items: studentsServer.map((e) {
              //     return DropdownMenuItem(
              //       value: e.etudiantId,
              //       child: Text(e.etudiantName + ' ' + e.etudiantFamilyName),
              //     );
              //   }).toList(),
              //   onChanged: (value) {
              //     _studentId = value!;
              //   },
              // ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[100],
                ),
                onPressed: () {
                  _submit();
                },
                child: const Text('Créer la classe'),
              ),

              if (_message.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _message,
                    style: const TextStyle(color: Colors.green),
                  ),
                ),

              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Annuler')),
            ],
          ),
        ),
      ),
    );
  }
}
