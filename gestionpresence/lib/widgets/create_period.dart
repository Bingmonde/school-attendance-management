import 'package:flutter/material.dart';

import '../models/course.dart';

class CreatePeriod extends StatefulWidget {
  const CreatePeriod(this.periods, {super.key});
  final List<Period> periods;

  @override
  State<CreatePeriod> createState() => _CreatePeriodState();
}

class _CreatePeriodState extends State<CreatePeriod> {
  int _weekDay = 2; // lundi par defaut
  TimeOfDay _startingTime = TimeOfDay(hour: 8, minute: 0); // 08:00 par defaut
  TimeOfDay _endingTime = TimeOfDay(hour: 8, minute: 0);
  String _message = '';

  int _timeOfDayToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  void addPeriod(int weekDay, String startTime, String endTime) {
    setState(() {
      widget.periods.add(
          Period(weekDay: weekDay, startTime: startTime, endTime: endTime));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.5),
        //     spreadRadius: 5,
        //     blurRadius: 7,
        //     offset: const Offset(0, 3), // changes position of shadow
        //   ),
        // ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.periods.isNotEmpty)
            Column(
              children: [
                Text('Périodes'),
                ...widget.periods.map((e) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(
                              'Jour: ${e.weekDay}, Début: ${e.startTime}, Fin: ${e.endTime}'),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              widget.periods.remove(e);
                            });
                          },
                          icon: Icon(Icons.delete))
                    ],
                  );
                }),
              ],
            ),
          DropdownMenu(
            initialSelection: _weekDay,
            dropdownMenuEntries: const [
              DropdownMenuEntry(
                value: 2,
                label: 'Lundi',
              ),
              DropdownMenuEntry(
                value: 3,
                label: 'Mardi',
              ),
              DropdownMenuEntry(
                value: 4,
                label: 'Mercredi',
              ),
              DropdownMenuEntry(
                value: 5,
                label: 'Jeudi',
              ),
              DropdownMenuEntry(
                value: 6,
                label: 'Vendredi',
              ),
            ],
            onSelected: (value) {
              print("weekday value changed" + value.toString());
              _weekDay = value!;
            },
          ),

          // DropdownButtonFormField(
          //   value: _weekDay,
          //   decoration: const InputDecoration(
          //     labelText: 'Jour de la semaine',
          //   ),
          //   items: [
          //     DropdownMenuItem(
          //       value: 2,
          //       child: const Text('Lundi'),
          //     ),
          //     DropdownMenuItem(
          //       value: 3,
          //       child: const Text('Mardi'),
          //     ),
          //     DropdownMenuItem(
          //       value: 4,
          //       child: const Text('Mercredi'),
          //     ),
          //     DropdownMenuItem(
          //       value: 5,
          //       child: const Text('Jeudi'),
          //     ),
          //     DropdownMenuItem(
          //       value: 6,
          //       child: const Text('Vendredi'),
          //     ),
          //   ],
          //   onChanged: (value) {
          //     print("weekday value changed" + value.toString());
          //     _weekDay = value!;
          //   },
          //   validator: (value) {
          //     if (value == null) {
          //       return 'Veuillez choisir un jour';
          //     }
          //     return null;
          //   },
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  'Début: ${_startingTime.hour.toString().padLeft(2, '0')}:${_startingTime.minute.toString().padLeft(2, '0')}'),
              IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: () async {
                  final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: _startingTime,
                      initialEntryMode: TimePickerEntryMode.input);
                  if (picked != null)
                    setState(() {
                      _message = '';
                      _startingTime = picked!;
                    });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  'Fin: ${_endingTime.hour.toString().padLeft(2, '0')}:${_endingTime.minute.toString().padLeft(2, '0')}'),
              IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: () async {
                  final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: _endingTime,
                      initialEntryMode: TimePickerEntryMode.input);
                  if (picked != null)
                    setState(() {
                      _message = '';
                      _endingTime = picked!;
                    });
                },
              ),
            ],
          ),
          Text(
              'Durée: ${_timeOfDayToMinutes(_endingTime) - _timeOfDayToMinutes(_startingTime)} minutes'),
          ElevatedButton(
            onPressed: () {
              // le cours doit durer au moins 1h
              if (_timeOfDayToMinutes(_endingTime) -
                      _timeOfDayToMinutes(_startingTime) <
                  60) {
                return;
              }
              addPeriod(
                  _weekDay,
                  '${_startingTime.hour.toString().padLeft(2, '0')}:${_startingTime.minute.toString().padLeft(2, '0')}',
                  '${_endingTime.hour.toString().padLeft(2, '0')}:${_endingTime.minute.toString().padLeft(2, '0')}');
              setState(() {
                _weekDay = 2;
                _startingTime = TimeOfDay(hour: 8, minute: 0);
                _endingTime = TimeOfDay(hour: 8, minute: 0);
                _message = 'Une prériode ajoutée';
              });
            },
            child: const Text('Ajouter une période'),
          ),
        ],
      ),
    ));
  }
}
