import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestionpresence/models/calendrier.dart';
import 'package:gestionpresence/widgets/jour_scolaire.dart';
import 'package:provider/provider.dart';

import '../providers/calendrier_provider.dart';

class CalendrierScolaire extends StatefulWidget {
  const CalendrierScolaire({super.key});

  @override
  State<CalendrierScolaire> createState() => _CalendrierScolaireState();
}

class _CalendrierScolaireState extends State<CalendrierScolaire> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState");
    Provider.of<CalendrierProvider>(context, listen: false).fetchCalendrier();
  }

  @override
  Widget build(BuildContext context) {
    final calendrier = context.watch<CalendrierProvider>();
    return Column(children: [
      Flexible(
        flex: 2,
        child: Container(
          color: Colors.amber,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () => calendrier.loadLastMonth(),
                  icon: Icon(Icons.arrow_back_ios)),
              Text(
                calendrier.currentDate.year.toString(),
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(width: 40),
              Text(calendrier.getCurrentMonth(),
                  style: TextStyle(fontSize: 20)),
              IconButton(
                  onPressed: () => calendrier.loadNextMonth(),
                  icon: Icon(Icons.arrow_forward_ios)),
            ],
          ),
        ),
      ),
      Flexible(
        flex: 1,
        child: Container(
          decoration:
              BoxDecoration(border: Border(bottom: BorderSide(width: 1))),
          child: Align(
            alignment: Alignment.center,
            child: GridView.count(
              crossAxisCount: calendrier.getSemaines().length,
              children: List.generate(
                  calendrier.getSemaines().length,
                  (index) => Text(
                        calendrier.getSemaines()[index],
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      )),
            ),
          ),
        ),
      ),
      Expanded(
        flex: 5,
        child: GridView.count(
            crossAxisCount: calendrier.getSemaines().length,
            children: List.generate(
                calendrier.lastDayInMonth +
                    calendrier.getVacantDaysofBeginning(), (index) {
              if (index < calendrier.getVacantDaysofBeginning()) {
                return Container();
              }
              return JourScolaireWidget(
                DateTime(
                    calendrier.currentDate.year,
                    calendrier.currentDate.month,
                    index - calendrier.getVacantDaysofBeginning() + 1),
                calendrier.getJourScolaire(
                    index - calendrier.getVacantDaysofBeginning() + 1),
              );
            })),
      ),
      Flexible(
          flex: 1,
          child: ElevatedButton(
              onPressed: () {},
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.teal[100]),
              child: Text("Fermer")))
    ]);
  }
}
