import 'dart:convert';
import 'package:flutter/material.dart';

class JourScolaire {
  late int? semaine;
  late int jourSemaine;
  late String special;

  JourScolaire({
    this.semaine,
    required this.jourSemaine,
    required this.special,
  });

  factory JourScolaire.fromJson(Map<String, dynamic> json) {
    // print("factory jour scolaire");
    // print(json['semaine'].runtimeType);
    // print(json['special'].runtimeType);
    if (json
        case {
          "semaine": int? semaine,
          "jour_semaine": int jourSemaine,
          "special": String special
        }) {
      //print("json format ok");
      return JourScolaire(
        semaine: semaine,
        jourSemaine: jourSemaine,
        special: special,
      );
    } else {
      throw Exception('Erreur de format');
    }
  }

  String get jourSpecial => special;
}

class Calendrier {
  Map<String, JourScolaire> calendrier = Map();
  // Map<DateTime, JourScolaire> calendrier = Map();
  DateTime debutSession = DateTime.now();
  DateTime finSession = DateTime.now();

  Calendrier(
      {required this.calendrier,
      required this.debutSession,
      required this.finSession});

  factory Calendrier.fromJson(Map<String, dynamic> json) {
    //print(json);
    DateTime debutSession = DateTime.now();
    DateTime finSession = DateTime.now();
    //Map<DateTime, JourScolaire> calendrier = {};
    Map<String, JourScolaire> calendrier = {};
    // trier les dates pour definir le debut et la fin de la session
    json.forEach((key, value) {
      DateTime date = DateTime.parse(key);
      if (date.isBefore(debutSession)) {
        debutSession = date;
      }
      if (date.isAfter(finSession)) {
        finSession = date;
      }
      //calendrier[date] = JourScolaire.fromJson(value as Map<String, dynamic>);
      calendrier[key] = JourScolaire.fromJson(value as Map<String, dynamic>);
    });

    return Calendrier(
      calendrier: calendrier,
      debutSession: debutSession,
      finSession: finSession,
    );
  }
}


// class Calendrier {
//   late Map<DateTime, JourScolaire> calendrier;
//   late DateTime debutSession;
//   late DateTime finSession;

//   Calendrier({
//     required this.calendrier,
//     required DateTime debutSession,
//     required DateTime finSession,
//   })   : this.debutSession = debutSession,
//         this.finSession = finSession;

//   factory Calendrier.fromJson(Map<String, dynamic> json) {
//     Map<DateTime, JourScolaire> calendrier = {};
//     DateTime debutSession = DateTime.now();
//     DateTime finSession = DateTime.now();

//     if (json.isNotEmpty) {
//       json.forEach((key, value) {
//         DateTime date = DateTime.parse(key);
//         if (date.isBefore(debutSession)) {
//           debutSession = date;
//         }
//         if (date.isAfter(finSession)) {
//           finSession = date;
//         }
//         calendrier[date] = JourScolaire.fromJson(value);
//       });
//     }

//     return Calendrier(
//       calendrier: calendrier,
//       debutSession: debutSession,
//       finSession: finSession,
//     );
//   }
// }

