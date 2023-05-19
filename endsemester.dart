
import 'package:college/API/queries.dart';
import 'package:college/components/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EndSemester extends StatefulWidget {
  final dynamic data;
  const EndSemester({super.key, this.data, required String year});

  @override
  State<EndSemester> createState() => _EndSemesterState();
}

class _EndSemesterState extends State<EndSemester> {
  late bool logged = false;
  void _loadSharedPreferences() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      logged = localStorage.getString("token") == null;
    });
  }
Future endSemesters() async {
  const url = 'http://localhost:8000/api/semesters/end';

  try {
    final response = await http.post(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      print('Semesters ended successfully');
    } else {
      print('Failed to end semesters: ${response.statusCode}');
    }
  } catch (error) {
    print('An error occurred: $error');
  }
}

@override
void initState() {
  _loadSharedPreferences();
  super.initState();
}


  @override
  Widget build(BuildContext context) {
    String? selYear;
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
          title: const Text("الرجاء اختيار السنة الدراسية لانهائها"),
          content: SingleChildScrollView(
            child: Form(
              child: Column(children: [
                FutureBuilder(
                  future: ApiPosts().getYears(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<String> dataList = snapshot.data
                          .map((item) => item['year'].toString())
                          .toList()
                          .cast<String>(); // Cast the list to List<String>
                      return StatefulBuilder(
                        builder: (BuildContext context, setState) {
                          return DropdownButtonFormField<String>(
                            isExpanded: true,
                            validator: (value) {
                              if (value == null) {
                                return "الرجاء اختيار السنة الدراسية لانهائها";
                              }
                              return null;
                            },
                            hint: const Text('اختيار السنة الدراسية'),
                            value: selYear,
                            onChanged: (newValue) {
                              setState(() {
                                selYear = newValue.toString();
                              });
                            },
                            items: dataList.map((ins) {
                              return DropdownMenuItem(
                                value: ins,
                                child: Text(ins),
                              );
                            }).toList(),
                          );
                        },
                      );
                    }
                    return progressIndicator(context);
                  },
                ),
              ]),
            ),
          ),
         actions: [
  iconLabelButton(
    () {
      Navigator.pop(context);
    },
    'الغاء',
    FontAwesomeIcons.x,
  ),
  iconLabelButton(
    () async {
      String? year = selYear;// Get the year value from your desired source
      await ApiPosts().endSemesters(selYear!, showSnackBar);
    },
    "حفظ التغييرات",
    FontAwesomeIcons.floppyDisk,
  ),
],
        //  actions: [
        //     iconLabelButton(() {
        //       Navigator.pop(context);
        //     }, 'الغاء', FontAwesomeIcons.x),
        //     iconLabelButton(() async {
        //       ApiPosts().endSemester(showSnackBar);
        //     }, "حفظ التغييرات", FontAwesomeIcons.floppyDisk)
        //   ],
        );
        },
    );
  }
}
      

//     return StatefulBuilder(
//       builder: (context, setState) {
//         return AlertDialog(
//           insetPadding: const EdgeInsets.all(20.0),
//           title: const Text("انهاء الفصل الدراسي"),
//           content: Builder(
//             builder: (context) {
//               return const SingleChildScrollView(
//                 child:
//                     Text('هل انت متأكد؟ لن تستطيع عكس العملية في حال المتابعة'),
//               );
//             },
//           ),
//           actions: [
//             iconLabelButton(() {
//               Navigator.pop(context);
//             }, 'الغاء', FontAwesomeIcons.x),
//             iconLabelButton(() async {
//               ApiPosts().endSemester(showSnackBar);
//             }, "حفظ التغييرات", FontAwesomeIcons.floppyDisk)
//           ],
//         );
//       },
//     );
//   }
// }
