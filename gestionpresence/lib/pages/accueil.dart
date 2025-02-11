import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestionpresence/pages/create_class.dart';
import 'package:gestionpresence/pages/create_course.dart';
import 'package:gestionpresence/pages/modify_class.dart';
import 'package:gestionpresence/pages/presences.dart';
import 'package:gestionpresence/pages/search_page.dart';
import 'package:gestionpresence/widgets/foot_bar.dart';
import 'package:gestionpresence/widgets/head_bar.dart';
import 'package:provider/provider.dart';

import '../providers/admin_prof.dart';
import '../providers/calendrier_provider.dart';
import '../providers/login_info.dart';
import '../widgets/calendrier.dart';
import 'my_classes.dart';

class PageAcceuil extends StatelessWidget {
  const PageAcceuil({super.key});

  static String routeName = "acceuil";

  @override
  Widget build(BuildContext context) {
    final loginInfo = Provider.of<LoginInfo>(context, listen: false);
    final calendar = Provider.of<CalendrierProvider>(context, listen: false);
    final adminProfService =
        Provider.of<AdminProfProvider>(context, listen: false);
    return Scaffold(
        appBar: const HeadBar('Gestion de présence'),
        body: FutureBuilder(
            future: calendar.fetchCalendrier(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Center(
                  child: loginInfo.getUserRole == 'admin'
                      ? Center(
                          child: Column(
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  await adminProfService.getCourses();
                                  await adminProfService.getProfs();
                                  await adminProfService.getStudents();
                                  Navigator.of(context)
                                      .pushNamed(CreateCourse.routeName);
                                },
                                child: const Text('Créer un cours'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(CreateClasses.routeName);
                                },
                                child: const Text('Créer un classe'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      ModifyClass.routeName,
                                      arguments: {
                                        'classId': '201-423-AL-24h-gr1'
                                      });
                                },
                                child: const Text('Modifier une classe'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // TODO: cherche un cours
                                },
                                child: const Text('Rechercher un cours'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(SearchPage.routeName);
                                },
                                child: const Text('Rechercher un étudiant(e)'),
                              ),
                            ],
                          ),
                        )
                      : loginInfo.getUserRole == 'prof'
                          ? Center(
                              child: Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // TODO: voir les classes
                                      Navigator.of(context)
                                          .pushNamed(MesCoursClasses.routeName);
                                    },
                                    child: const Text('Consulter mes classes'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                          ModifyClass.routeName,
                                          arguments: {
                                            'classId': '201-423-AL-24h-gr1'
                                          });
                                    },
                                    child: const Text('Modifier une classe'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await adminProfService
                                          .getMesClasses(loginInfo.user_uid);
                                      Navigator.of(context).pushNamed(
                                          PresencesManagement.routeName);
                                    },
                                    child: const Text('gestion des absences'),
                                  ),
                                ],
                              ),
                            )
                          : CalendrierScolaire());
            }),
        bottomNavigationBar: FootBar());
  }
}
