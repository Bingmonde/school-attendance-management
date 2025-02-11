class Course {
  String courseCode;
  String courseName;

  Course({required this.courseCode, required this.courseName});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseCode: json['course_code'],
      courseName: json['course_name'],
    );
  }

  tojson() {
    return {
      'course_code': courseCode,
      'course_name': courseName,
    };
  }
}

class CourseClass {
  String courseId;
  String groupNo;
  String session;
  String profId;
  List<String> locaux;
  List<String> students;
  List<Period> periods;

  CourseClass(
      {required this.courseId,
      required this.groupNo,
      required this.session,
      required this.profId,
      required this.locaux,
      required this.students,
      required this.periods});

  tojson() {
    return {
      'course_id': courseId,
      'group_no': groupNo,
      'session': session,
      'prof_id': profId,
      'locaux': locaux,
      'students': students,
      'periods': periods.map((e) => e.tojson()).toList(),
    };
  }

  factory CourseClass.fromJson(Map<String, dynamic> json) {
    return CourseClass(
        courseId: json['course_id'],
        groupNo: json['group_no'],
        session: json['session'],
        profId: json['prof_id'],
        locaux: List<String>.from(json['locaux']),
        students: List<String>.from(json['students']),
        periods: List<Period>.from(
          json['periods'].map((e) => Period(
              weekDay: e['weekday'],
              startTime: e['start_time'],
              endTime: e['end_time'])),
        ));
  }
}

class Period {
  int weekDay;
  String startTime;
  String endTime;

  Period(
      {required this.weekDay, required this.startTime, required this.endTime});

  tojson() {
    return {
      'weekday': weekDay,
      'start_time': startTime,
      'end_time': endTime,
    };
  }
}

class Presence {
  String studentId;
  String classId;
  String date;
  bool isPresent;

  Presence(
      {required this.studentId,
      required this.classId,
      required this.date,
      required this.isPresent});
  tojson() {
    return {
      'student_id': studentId,
      'class_id': classId,
      'date': date,
      'is_present': isPresent,
    };
  }

  factory Presence.fromJson(Map<String, dynamic> json) {
    return Presence(
      studentId: json['student_id'],
      classId: json['class_id'],
      date: json['date'],
      isPresent: json['is_present'],
    );
  }

  // Map<String, dynamic> toJson2() {
  //   return {
  //     'class_id': {
  //       classId: {
  //         date: {
  //           'is_present': isPresent,
  //         }
  //       }
  //     }
  //   };
  // }

  // factory Presence.fromJson2(String studentId, String classId, String date,
  //     Map<String, dynamic> data) {
  //   return Presence(
  //     studentId: studentId,
  //     classId: classId,
  //     date: date,
  //     isPresent: data['is_present'],
  //   );
  // }
}
