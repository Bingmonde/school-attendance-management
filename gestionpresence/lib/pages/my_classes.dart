import 'package:flutter/material.dart';
import 'package:gestionpresence/models/course.dart';
import 'package:gestionpresence/providers/admin_prof.dart';
import 'package:gestionpresence/providers/login_info.dart';
import 'package:gestionpresence/widgets/head_bar.dart';
import 'package:provider/provider.dart';

class MesCoursClasses extends StatelessWidget {
  const MesCoursClasses({super.key});
  static String routeName = "mes_classes";
  

  @override
  Widget build(BuildContext context) {
    final AdminProfProvider adminProfService =
        Provider.of<AdminProfProvider>(context, listen: false);
    final LoginInfo userInfo = Provider.of<LoginInfo>(context, listen: false);
    return Scaffold(
        appBar: const HeadBar("Mes classes"),
        body: FutureBuilder(
            future: adminProfService.getMesClasses(userInfo.user_uid),
            builder: (ctx, snapshot) {
              print('cours for : ${userInfo.user_uid}');
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              List<CourseClass> myClasses = adminProfService.classes;
              //print(myClasses.length);
              if (myClasses.isNotEmpty) {
                return ListView.builder(
                  itemCount: myClasses.length,
                  itemBuilder: (ctx, index) {
                    return ListTile(
                      title: Text(myClasses[index].courseId),
                      subtitle: Text(myClasses[index].groupNo),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                          
                      },
                    );
                  },
                );
              }
              return const Center(child: Text('Aucune classe'));
            }));
  }
}
