import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/calendrier.dart';

class JourScolaireWidget extends StatelessWidget {
  const JourScolaireWidget(this.date, this.jourScolaire, {super.key});
  final DateTime date;
  final JourScolaire? jourScolaire;

  @override
  Widget build(BuildContext context) {
    // marquer aujourd'hui
    final Color color = (date.day == DateTime.now().day &&
            date.month == DateTime.now().month &&
            date.year == DateTime.now().year)
        ? Colors.amber
        : Colors.white;
    String semaine = (jourScolaire != null && jourScolaire!.semaine != null)
        ? jourScolaire!.semaine.toString()!
        : "";
    return Container(
        decoration: BoxDecoration(
          color: color,
        ),
        child: Column(
          children: [
            SizedBox(
                child: Text(
              semaine,
              style: TextStyle(fontSize: 10),
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Text(date.day.toString(),
                            style: TextStyle(fontSize: 30))),
                    // if (jourScolaire != null)
                    //   if (jourScolaire!.semaine != null)
                    //     SizedBox(
                    //         child: Text(
                    //       jourScolaire!.semaine.toString()!,
                    //       style: TextStyle(fontSize: 10),
                    //     ))
                  ],
                ),
                if (jourScolaire != null)
                  SizedBox(
                      child: Text(jourScolaire!.jourSpecial,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.red,
                              fontWeight: FontWeight.bold)))
              ],
            ),
          ],
        ));
  }
}
