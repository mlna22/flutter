import 'package:college/API/queries.dart';
import 'package:college/components/formitems.dart';
import 'package:college/components/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StartSemester extends StatefulWidget {
  final dynamic data;
    const StartSemester({super.key, this.data, required String year});

  @override
  State<StartSemester> createState() => _StartSemesterState();
}

class _StartSemesterState extends State<StartSemester> {
  late bool logged = false;
  void _loadSharedPreferences() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      logged = localStorage.getString("token") == null;
    });
  }

  late TextEditingController year;
  @override
  void initState() {
    year = TextEditingController();
    _loadSharedPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
        String? selYear;

        TextEditingController year = TextEditingController();

     String? validateInput(String? input) {
      if (input == null || input.isEmpty) {
        return 'الرجاء ادخال السنة الدراسية';
      }
      return null;
    }
    final formkey = GlobalKey<FormState>();
    void showSnackBar(String message, {bool isError = false}) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
        ),
      );
    }

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(20.0),
          title: const Text("بدأ سنة دراسية جديدة"),
          content: Builder(
            builder: (context) {
              return SingleChildScrollView(
                child: Form(
                  key: formkey,
                  child: Column(children: [
                    input(context, "",
                        controller: year,
                        valiator: validateInput,
                        icon: const FaIcon(FontAwesomeIcons.userTie)),
                    sizedBox(
                      height: 20.0,
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                  ]),
                ),
              );
            },
          ),
          actions: [
            iconLabelButton(() {
              Navigator.pop(context);
            }, 'الغاء', FontAwesomeIcons.x),
            iconLabelButton(() async {
             String? year = selYear;// Get the year value from your desired source
      await ApiPosts().createSemester(selYear!, showSnackBar);
            }, "حفظ التغييرات", FontAwesomeIcons.floppyDisk)
          ],
        );
      },
    );
  }
}
