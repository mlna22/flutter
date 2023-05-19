

import 'package:college/components/editdialogs/endsemester.dart';
import 'package:college/components/editdialogs/startsemester.dart';
import 'package:college/screens/dashboard.dart';
import 'package:college/components/text.dart';
import 'package:college/components/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({super.key});

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Dashboard(
      selectedRoute: '/',
      title: "اعدادات النظام",
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sizedBox(height: 30.0),
              Row(
                children: [
                  mainSurface(context, "تعديل معلومات النظام و المستخدمين"),
                  const Spacer(),
                  sizedBox(width: 40.0)
                ],
              ),
              sizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buttonCard(context, width / 3, height / 7,
                      const FaIcon(FontAwesomeIcons.users), "المستخدمين", () {
                    Navigator.pushNamed(context, "/usertable");
                  }),
                  buttonCard(
                      context,
                      width / 3,
                      height / 7,
                      const FaIcon(FontAwesomeIcons.calendar),
                      "انهاء السنة الدراسية", () {
                    showDialog(
                        context: context,
                        builder: (context) =>  const EndSemester(year:'',));
                  }),
                ],
              ),
              sizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buttonCard(
                      context,
                      width / 3,
                      height / 7,
                      const FaIcon(FontAwesomeIcons.users),
                      "بدء فصل دراسي جديد",
                      () {
                    showDialog(
                        context: context,
                        builder: (context) =>  const StartSemester(year:'',));
                  
                      }),
                  buttonCard(
                      context,
                      width / 3,
                      height / 7,
                      const FaIcon(FontAwesomeIcons.calendar),
                      "عبور الطلبة",
                      () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
