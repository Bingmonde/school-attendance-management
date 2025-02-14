// import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestionpresence/widgets/calendrier.dart';
import 'package:gestionpresence/widgets/head_bar.dart';
import 'package:gestionpresence/widgets/presence_list_stu.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/admin_prof.dart';
import '../providers/calendrier_provider.dart';
import '../providers/login_info.dart';

class PresencesManagement extends StatefulWidget {
  const PresencesManagement({super.key});
  static String routeName = "presences";

  @override
  State<PresencesManagement> createState() => _PresencesManagementState();
}

class _PresencesManagementState extends State<PresencesManagement> {
  late int _selectedClassIndex;

  late String _selectedClass;
  late DateTime _selectedDate;
  late List<String> _students;

  late final CalendrierProvider calendrier;
  List<DateTime> courseDates = [];
  late final AdminProfProvider adminProfService;
  late LoginInfo userInfo;

  @override
  void initState() {
    super.initState();
    calendrier = Provider.of<CalendrierProvider>(context, listen: false);
    adminProfService = Provider.of<AdminProfProvider>(context, listen: false);
    userInfo = Provider.of<LoginInfo>(context, listen: false);


    _selectedClassIndex = 2;
    _selectedClass = getClassId(adminProfService.classes[_selectedClassIndex]);
    courseDates = getClassDates(_selectedClass);
    _selectedDate = selectClassDateByDefault(courseDates);
    _students = [...adminProfService.classes[_selectedClassIndex].students];
    print(_students);
  }

// fonction utilitaire
  String convertDateToString(DateTime date) {
    String year = date.year.toString();
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  DateTime selectClassDateByDefault(List<DateTime> dates) {
    //print(dates);
    DateTime today = DateTime.now();
    DateTime defaultDate = DateTime.now();
    dates.forEach((element) {
      if (element.year == today.year &&
          element.month == today.month &&
          element.day == today.day) {
        defaultDate = element;
        return;
      } else if (element.isAfter(today)) {
        defaultDate = element;
        return;
      }
    });
    return defaultDate;

    // if (currentCourse.periods.length > 2 || currentCourse.periods.length < 0) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('La séquence de cours est invalide'),
    //     ),
    //   );
    //   return defaultDate;
    // }
    // if (currentCourse.periods.length == 1) {
    //   defaultDate =
    //       calendrier.findNearestSchoolDate(currentCourse.periods[0].weekDay);
    // }
    // if (currentCourse.periods.length == 2) {
    //   defaultDate = calendrier.findNearestSchoolDate(
    //       currentCourse.periods[0].weekDay,
    //       weekDay2: currentCourse.periods[1].weekDay);
    // }
  }

  List<DateTime> getClassDates(String classId) {
    late CourseClass course;

    adminProfService.classes.forEach((element) {
      if (getClassId(element) == classId) {
        course = element;
        return;
      }
    });

    List<DateTime> dates = [];
    // if (course.periods.length > 2 || course.periods.length < 0) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('La séquence de cours est invalide'),
    //     ),
    //   );
    //   return dates;
    // }
    int sequence = 15 * course.periods.length;

    calendrier.calendrier.forEach((key, value) {
      if (value.jourSemaine == course.periods[0].weekDay &&
          value.special.isEmpty &&
          dates.length < sequence) {
        dates.add(DateTime.parse(key));
        //print(key);
      }
      if (course.periods.length == 2 &&
          value.jourSemaine == course.periods[1].weekDay &&
          value.special.isEmpty &&
          dates.length < sequence) {
        dates.add(DateTime.parse(key));
        //print(key);
      }
    });
    return dates;
  }

  String getClassId(CourseClass course) {
    return course.courseId + '-' + course.session + '-' + course.groupNo;
  }

  Future<void> savePresencesStudents(List<Presence> presences) async {
    //print(presences);
    for (var presence in presences) {
      await FirebaseFirestore.instance
          .collection('presences')
          .doc(presence.studentId)
          .set(
            presence.tojson(),
          );

      // await FirebaseFirestore.instance
      //     .collection('presences')
      //     .doc(presence.studentId)
      //     .set(
      //   {'${presence.classId}+${presence.date}': presence.isPresent},
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    //final LoginInfo userInfo = Provider.of<LoginInfo>(context, listen: false);
    //final index = ModalRoute.of(context)!.settings.arguments as int;
    print("presence rebuilt");
    return Scaffold(
        appBar: const HeadBar('Gestion des présences'),
        body: FutureBuilder(
            key: UniqueKey(),
            future: adminProfService.getMesClasses(userInfo.user_uid),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              List<CourseClass> myClasses = adminProfService.classes;

              return Center(
                child: Column(
                  children: [
                    Text('Mes classes:'),
                    DropdownMenu(
                        key: UniqueKey(),
                        initialSelection: _selectedClass,
                        dropdownMenuEntries: myClasses.map((e) {
                          return DropdownMenuEntry(
                            value: getClassId(e),
                            label: getClassId(e),
                          );
                        }).toList(),
                        onSelected: ((value) {
                          print('selected class: $value');
                          setState(() {
                            _selectedClass = value!;
                            courseDates = getClassDates(_selectedClass);
                          });
                        })),
                    SizedBox(height: 12),
                    Text('Dates de cours:'),
                    DropdownMenu(
                        key: UniqueKey(),
                        initialSelection: _selectedDate.toString(),
                        dropdownMenuEntries: courseDates.map((e) {
                          return DropdownMenuEntry(
                            value: e.toString(),
                            label: convertDateToString(e),
                          );
                        }).toList(),
                        onSelected: ((value) {
                          setState(() {
                            _selectedDate = DateTime.parse(value!);
                          });
                        })),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.person),
                            label: Text('Présent')),
                        TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.person_2_outlined),
                            label: Text('Absent')),
                      ],
                    ),
                    SizedBox(height: 12),
                    Divider(),
                    Text('Liste des étudiants:'),
                    PresenceStudentsWidget(
                        _selectedClass,
                        convertDateToString(_selectedDate),
                        _students,
                        savePresencesStudents)
                  ],
                ),
              );
            }));

    // return const Center(child: Text('Aucune classe'));
  }
}
