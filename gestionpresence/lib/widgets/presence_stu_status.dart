import 'package:flutter/material.dart';
import 'package:gestionpresence/providers/admin_prof.dart';
import 'package:provider/provider.dart';

class PresenceStudentStatusWidget extends StatefulWidget {
  const PresenceStudentStatusWidget(
      this.studentId, this.index, this.isPresent, this.updatePresence,
      {super.key});
  final String studentId;
  final int index;
  final bool isPresent;
  final void Function(int, bool) updatePresence;

  @override
  State<PresenceStudentStatusWidget> createState() =>
      _PresenceStudentStatusWidgetState();
}

class _PresenceStudentStatusWidgetState
    extends State<PresenceStudentStatusWidget> {
  late final AdminProfProvider adminProfService;
  late bool _isPresent;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    adminProfService = Provider.of<AdminProfProvider>(context, listen: false);
    _isPresent = widget.isPresent;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FutureBuilder(
            future: adminProfService.getUserInfo(widget.studentId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return Text(snapshot.data!.userName +
                  ' ' +
                  snapshot.data!.userFamilyName);
            }),
        Switch(
          value: _isPresent,
          onChanged: (value) {
            setState(() {
              _isPresent = value;
              widget.updatePresence(widget.index, value);
            });
          },
        )
      ],
    );
  }
}
