import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestionpresence/models/user.dart';

import '../models/course.dart';

class AdminProfProvider with ChangeNotifier {
  Map<String, CegepUser> cegepUsers = {};
  // final Map<String, CegepUser> profs = {};
  // Map<String, CourseClass> classes = {};
  List<CourseClass> classes = [];

  List<Course> courses = [];
  List<Prof> profs = [];
  List<Etudiant> students = [];

  Future<void> changeRole(int matricule) async {
    final stu = await FirebaseFirestore.instance
        .collection('users')
        .where('matricule', isEqualTo: matricule)
        .get();
    print(stu.docs.first.id);
    if (stu.docs.isNotEmpty) {
      String uid = stu.docs.first.id;
      // ajouter dans la collection profs
      await FirebaseFirestore.instance.collection('profs').doc(uid).set({
        'modified': DateTime.now(),
      });
      CegepUser user = CegepUser.fromJson(stu.docs.first.data());
      user.role = 'prof';
      // mise a jour info user, role -> prof
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(user.toJson());
      print('role modified');
      notifyListeners();
    }
  }

  Future<void> getCourses() async {
    final coursesFromServer =
        await FirebaseFirestore.instance.collection('cours').get();
    courses =
        coursesFromServer.docs.map((e) => Course.fromJson(e.data())).toList();
    notifyListeners();
  }

  Future<void> createCourse(Course course) async {
    await FirebaseFirestore.instance
        .collection('cours')
        .doc(course.courseCode)
        .set(course.tojson());
  }

  // lister les profs dans la base de données
  Future<void> getProfs() async {
    final profsFromServer = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'prof')
        .get();
    final List<Prof> profsList = [];
    profsFromServer.docs.forEach((element) {
      profsList.add(Prof(
        profId: element.id,
        profName: element.data()['user_name'],
        profFamilyName: element.data()['user_familyname'],
      ));
    });
    profs = profsList;
    // print('prof length: ${profs.length}');
    notifyListeners();
  }

  // lister tous les etudiants dans la base de données
  Future<void> getStudents() async {
    final studentsFromServer = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'etudiant')
        .get();
    final List<Etudiant> etudiants = [];
    studentsFromServer.docs.forEach((element) {
      etudiants.add(Etudiant(
        etudiantId: element.id,
        etudiantName: element.data()['user_name'],
        etudiantFamilyName: element.data()['user_familyname'],
      ));
    });
    students = etudiants;
    // print('student length: ${students.length}');
    notifyListeners();
  }

  Future<void> fetchDataForCreatingClass() async {
    await getCourses();
    await fetchUsers();
    // await getProfs();
    // await getStudents();
  }

  Future<void> fetchUsers() async {
    final userData = await FirebaseFirestore.instance.collection('users').get();
    userData.docs.forEach((element) {
      cegepUsers[element.id] = CegepUser.fromJson(element.data());
    });
    // identifier les roles
    for (var user in cegepUsers.values) {
      if (user.role == 'prof') {
        profs.add(Prof(
          profId: user.email,
          profName: user.userName,
          profFamilyName: user.userFamilyName,
        ));
      } else if (user.role == 'etudiant') {
        students.add(Etudiant(
          etudiantId: user.email,
          etudiantName: user.userName,
          etudiantFamilyName: user.userFamilyName,
        ));
      }
    }
  }

  Future<CegepUser> getUserInfo(String userId) async {
    // chercher dans le private map
    if (cegepUsers.containsKey(userId)) {
      //print("found from map");
      return cegepUsers[userId]!;
    } else {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userData.data() != null) {
        cegepUsers[userId] = CegepUser.fromJson(userData.data()!);
        //print(
        //   "fetch from collect ${CegepUser.fromJson(userData.data()!).userName}");
        return CegepUser.fromJson(userData.data()!);
      }
    }
    //print("user not found");
    return CegepUser(
      email: '',
      imageUrl: '',
      matricule: 0,
      userFamilyName: '',
      userName: '',
      role: '',
    );
  }

  Future<CourseClass> findClass(String classId) async {
    final classData = await FirebaseFirestore.instance
        .collection('classes')
        .doc(classId)
        .get();
    print('class reload: ${classData.data()}');
    if (classData.data() != null) {
      return CourseClass.fromJson(classData.data()!);
    }
    return CourseClass(
      courseId: '',
      groupNo: '',
      session: '',
      profId: '',
      locaux: [],
      students: [],
      periods: [],
    );
  }

  // void findStudentsNotInClass(List<String> students) {
  //   final List<Etudiant> studentsNotInClass = [];
  //   for (var student in this.students) {
  //     if (!students.contains(student.etudiantId)) {
  //       studentsNotInClass.add(student);
  //     }
  //   }
  //   print(studentsNotInClass);
  // }

  Future<CegepUser> searchUserByMatricule(int matricule) async {
    final stu = await FirebaseFirestore.instance
        .collection('users')
        .where('matricule', isEqualTo: matricule)
        .get();
    if (stu.docs.isNotEmpty) {
      return CegepUser.fromJson(stu.docs.first.data());
    }
    return CegepUser(
      email: '',
      imageUrl: '',
      matricule: 0,
      userFamilyName: '',
      userName: '',
      role: '',
    );
  }

  Future<void> getMesClasses(String profId) async {
    classes = [];
    try {
      final myClasses = await FirebaseFirestore.instance
          .collection('classes')
          .where('prof_id', isEqualTo: profId)
          .get();
      print('my classes length: ${myClasses.docs.length}');
      myClasses.docs.forEach((element) {
        //classes[element.id] = CourseClass.fromJson(element.data());
        classes.add(CourseClass.fromJson(element.data()));
        //print('class: ${element.data()}');
      });
    } catch (e) {
      print('error: $e');
      notifyListeners();
    }
  }

  Future<List<Presence>> getPresenceByGroupAndDate(
      String classId, String date) async {
    return [];
    // final presences = await FirebaseFirestore.instance
    //     .collection('presences')
    //     .where('class_id', isEqualTo: classId)
    //     .where('date', isEqualTo: date)
    //     .get();
    // return presences.docs.map((e) => Presence.fromJson(e.data())).toList();
  }

  // Future<List<Presence>> getPresenceByGroupAndDate2(
  //     String classId, String date) async {
  //   final presences = await FirebaseFirestore.instance
  //       .collection('presences')
  //       .where('${classId}+${date}', isEqualTo: '${classId}+${date}')
  //       .get();
  //   return presences.docs
  //       .map((e) => Presence(
  //             studentId: e.data()['student_id'],
  //             classId: e.data()['class_id'],
  //             date: e.data()['date'],
  //             isPresent: e.data()['is_present'],
  //           ))
  //       .toList();
  // }
}
