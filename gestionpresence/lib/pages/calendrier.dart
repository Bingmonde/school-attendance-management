import 'package:flutter/material.dart';

import '../widgets/calendrier.dart';
import '../widgets/foot_bar.dart';
import '../widgets/head_bar.dart';

class PageCalendrier extends StatelessWidget {
  const PageCalendrier({super.key});

  static String routeName = "calendrier";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const HeadBar('Calendrier Scolaire'),
        body: Center(
          child: CalendrierScolaire(),
        ),
        bottomNavigationBar: FootBar());
  }
}
