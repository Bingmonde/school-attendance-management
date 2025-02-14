import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestionpresence/firebase_options.dart';
import 'package:gestionpresence/pages/accueil.dart';
import 'package:gestionpresence/pages/calendrier.dart';
import 'package:gestionpresence/pages/create_class.dart';
import 'package:gestionpresence/pages/create_course.dart';
import 'package:gestionpresence/pages/modify_class.dart';
import 'package:gestionpresence/pages/my_classes.dart';
import 'package:gestionpresence/pages/presences.dart';
import 'package:gestionpresence/pages/profile.dart';
import 'package:gestionpresence/providers/admin_prof.dart';
import 'package:gestionpresence/widgets/edit_profile.dart';
import 'package:provider/provider.dart';
import 'pages/auth_screen.dart';
import 'pages/search_page.dart';
import 'providers/calendrier_provider.dart';
import 'providers/login_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalendrierProvider()),
        ChangeNotifierProvider(create: (_) => LoginInfo()),
        ChangeNotifierProvider(create: (_) => AdminProfProvider())
      ],
      child: MaterialApp(
        title: 'Gestion de présence ',
        routes: {
          PageAcceuil.routeName: (context) => const PageAcceuil(),
          PageCalendrier.routeName: (context) => const PageCalendrier(),
          MyProfile.routeName: (context) => const MyProfile(),
          EditProfile.routeName: (context) => const EditProfile(),
          CreateCourse.routeName: (context) => const CreateCourse(),
          SearchPage.routeName: (context) => const SearchPage(),
          CreateClasses.routeName: (context) => const CreateClasses(),
          ModifyClass.routeName: (context) => const ModifyClass(),
          MesCoursClasses.routeName: (context) => const MesCoursClasses(),
          PresencesManagement.routeName: (context) =>
              const PresencesManagement(),
        },
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            final loginInfo = Provider.of<LoginInfo>(context, listen: false);
            if (snapshot.hasData) {
              return FutureBuilder(
                  future: loginInfo.setUser(snapshot.data!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    return PageAcceuil();
                  });
            }
            return AuthScreen();
          },
        ),
      ),
    );
  }
}
