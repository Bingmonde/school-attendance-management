import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import '../models/calendrier.dart';

class CalendrierProvider with ChangeNotifier {
  Map<String, JourScolaire> calendrier = {};
  //Map<DateTime, JourScolaire> calendrier = {};
  DateTime currentDate = DateTime.now();

  Future<void> fetchCalendrier() async {
    if (calendrier.isNotEmpty) return;
    //print("fetchCalendrier ");
    final response = await http.get(Uri.parse(Config.baseURL));
    //print(json.decode(response.body) as Map<String, dynamic>);
    //print(response.body as Map<String, dynamic>);
    calendrier = Calendrier.fromJson(json.decode(response.body)).calendrier;
    //print(calendrier);
    notifyListeners();
  }

  loadNextMonth() {
    currentDate = DateTime(currentDate.year, currentDate.month + 1);
    notifyListeners();
  }

  loadLastMonth() {
    currentDate = DateTime(currentDate.year, currentDate.month - 1);
    notifyListeners();
  }

  int get lastDayInMonth {
    return DateTime(currentDate.year, currentDate.month + 1, 0).day;
  }

  int getVacantDaysofBeginning() {
    DateTime firstDay = DateTime(currentDate.year, currentDate.month, 1);
    if (firstDay.weekday == 7) {
      return 0;
    } else {
      return firstDay.weekday;
    }
  }

  JourScolaire? getJourScolaire(int day) {
    DateTime date = DateTime(currentDate.year, currentDate.month, day);
    String dateStr = convertDateToString(date);
    return calendrier[dateStr];
  }

  String getCurrentMonth() {
    switch (currentDate.month) {
      case 1:
        return 'Janvier';
      case 2:
        return 'Février';
      case 3:
        return 'Mars';
      case 4:
        return 'Avril';
      case 5:
        return 'Mai';
      case 6:
        return 'Juin';
      case 7:
        return 'Juillet';
      case 8:
        return 'Août';
      case 9:
        return 'Septembre';
      case 10:
        return 'Octobre';
      case 11:
        return 'Novembre';
      case 12:
        return 'Décembre';
      default:
        return '';
    }
  }

  String findNearestSchoolDate(int weekDay1, {int? weekDay2}) {
    int todayWeekDay = convertWeekDayToCegepWeekDay(DateTime.now());
    String todayStr = convertDateToString(DateTime.now());
    String nearestDate = '';

    if (weekDay2 != null) {
      if (weekDay1 == todayWeekDay || weekDay2 == todayWeekDay) {
        nearestDate = todayStr;
      } else {
        for (int i = 1; i < 8; i++) {
          DateTime date = DateTime.now().add(Duration(days: i));
          String dateStr = convertDateToString(date);
          if (weekDay1 == calendrier[dateStr]!.jourSemaine ||
              weekDay2 == calendrier[dateStr]!.jourSemaine) {
            nearestDate = dateStr;
            break;
          }
        }
      }
    } else {
      if (weekDay1 == todayWeekDay) {
        nearestDate = todayStr;
      } else {
        for (int i = 1; i < 8; i++) {
          DateTime date = DateTime.now().add(Duration(days: i));
          String dateStr = convertDateToString(date);
          if (weekDay1 == calendrier[dateStr]!.jourSemaine) {
            nearestDate = dateStr;
            break;
          }
        }
      }
    }
    return nearestDate;
  }

  // fonction utilitaire
  String convertDateToString(DateTime date) {
    String year = date.year.toString();
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  int convertWeekDayToCegepWeekDay(DateTime date) {
    int weekDay = date.weekday;
    return weekDay % 7 + 1;
  }

  List<String> getSemaines() {
    //return ['Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'];
    return ['D', 'L', 'MA', 'ME', 'J', 'V', 'S'];
  }
}
