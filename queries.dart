import 'package:college/API/apiconfig.dart';
import 'package:college/translate.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiPosts {
  Future login(context, email, password, Function showSnackBar) async {
    var data = {'email': email, 'password': password};

    try {
      final response = await Api().dio.post(
            'users/login',
            data: data,
          );

      if (response.statusCode == 200) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        await localStorage.setString('token', response.data['access_token']);
        await localStorage.setString('role', response.data['role']);
        Api().setToken(localStorage.getString('token')!);
        showSnackBar("تم تسجيل الدخول بنجاح");
        Navigator.pushNamed(context, '/home');
      } else if (response.statusCode == 401) {
        showSnackBar(
          'البريد الالكتروني او الرقم السري غير صحيح, يرجى اعادة المحاولة',
          isError: true,
        );
      }
    } catch (e) {
      showSnackBar("حدث خطأ ما, يرجى اعادة المحاولة", isError: true);
    }
  }

  Future createInstructor(
      String nameAr, String nameEn, Function showSnackBar) async {
    var data = {'name_ar': nameAr, "name_en": nameEn};
    try {
      final res = await Api().dio.post('instructors/create', data: data);
      if (res.statusCode == 200) {
        showSnackBar("تم اضافة التدريسي بنجاح");
      }
    } catch (e) {
      showSnackBar("حدث خطأ ما, يرجى اعادة المحاولة", isError: true);
    }
  }

  Future createDegree(context, String id, String fourty, String sixty1,
      String sixty2, String sixty3, Function showSnackBar) async {
    var data = {
      'id': id,
      'fourty': fourty,
      "sixty1": sixty1,
      "sixty2": sixty2,
      "sixty3": sixty3
    };
    try {
      final res = await Api().dio.post('degrees/create', data: data);
      if (res.statusCode == 200) {
        showSnackBar("تم اضافة الدرجات بنجاح");
      }
    } catch (e) {
      showSnackBar("حدث خطأ ما, يرجى اعادة المحاولة", isError: true);
    }
  }

  Future createCourse(
      context,
      String nameAr,
      String nameEn,
      String year,
      String success,
      String code,
      String ins,
      String semester,
      String unit,
      bool isCounts,
      Function showSnackBar) async {
    var data = {
      'name_ar': nameAr,
      'name_en': nameEn,
      "level": "bachaelor",
      "year": translateYearAE(year),
      "code": code,
      "unit": unit,
      "semester": translateNumAE(semester),
      "success": success,
      "isCounts": isCounts,
      "ins_name": ins,
    };
    try {
      final res = await Api().dio.post('courses/create/', data: data);
      if (res.statusCode == 200) {
        showSnackBar("تم اضافة الكورس بنجاح");
      } else {
        showSnackBar("حدث خطأ ما, يرجى اعادة المحاولة", isError: true);
      }
    } catch (e) {
      showSnackBar("حدث خطأ ما, يرجى اعادة المحاولة", isError: true);
    }
  }

  Future createStudent(String nameAr, String nameEn, String selYear,
      Function showSnackBar) async {
    var data = {
      "name_ar": nameAr,
      "name_en": nameEn,
      "year": translateYearAE(selYear),
      'level': 'bachaelor'
    };
    try {
      final res = await Api().dio.post('students/create/', data: data);
      if (res.statusCode == 200) {
        showSnackBar("تم اضافة الطالب بنجاح");
      } else {
        showSnackBar("حدث خطأ ما, يرجى اعادة المحاولة", isError: true);
      }
    } catch (e) {
      showSnackBar("حدث خطأ ما, يرجى اعادة المحاولة", isError: true);
    }
  }

  Future editInstructor(context, String id, String nameAr, String nameEn,
      Function showSnackBar) async {
    var data = {"id": id, "name_ar": nameAr, "name_en": nameEn};
    try {
      var res = await Api().dio.post('instructors/update', data: data);
      if (res.statusCode == 200) {
        Navigator.pushNamed(context, "/instructortable");
        showSnackBar("تم تحديث المعلومات بنجاح");
      } else {
        showSnackBar("حدث خطأ ما, يرجى اعادة المحاولة", isError: true);
      }
    } catch (e) {
      showSnackBar("حدث خطأ ما, يرجى اعادة المحاولة", isError: true);
    }
  }

  Future editStudent(context, String id, String nameAr, String nameEn,
      String year, Function showSnackBar) async {
    var data = {
      "id": id,
      "name_ar": nameAr,
      "name_en": nameEn,
      "year": year,
      "level": "bachaelor"
    };
    try {
      var res = await Api().dio.post('students/update', data: data);
      if (res.statusCode == 200) {
        Navigator.pushNamed(context, "/studenttable");
        showSnackBar("تم تحديث المعلومات بنجاح");
      } else {
        showSnackBar("حدث خطأ ما, يرجى اعادة المحاولة", isError: true);
      }
    } catch (e) {
      showSnackBar("حدث خطأ ما, يرجى اعادة المحاولة", isError: true);
    }
  }

  Future removeStudent(context, String id, Function showSnackBar) async {
    try {
      var res = await Api().dio.post("students/remove/$id");
      if (res.statusCode == 200) {
        showSnackBar('تم قطع العلاقة مع الطالب بنجاح');
        Navigator.pushNamed(context, "/studentstable");
      } else {
        showSnackBar("حدث خطأ ما يرجى اعادة المحاولة", isError: true);
      }
    } catch (e) {
      showSnackBar("حدث خطأ ما يرجى اعادة المحاولة", isError: true);
    }
  }

  Future getCurrentAverage(id) async {
    try {
      var res = await Api().dio.get('students/getCurAvg?id=$id');
      return (res.data);
    } catch (e) {
      return "";
    }
  }

  Future getHomeData() async {
    try {
      var res = await Api().dio.get("homepage");
      return res;
    } catch (e) {
      return 'error';
    }
  }

  Future createUser(context, String name, String email, String selRole,
      String password, Function showSnackBar) async {
    var data = {
      "email": email,
      "password": password,
      "role": selRole,
      'name': name
    };
    try {
      final res = await Api().dio.post('users/create/', data: data);
      if (res.statusCode == 200) {
        showSnackBar("تم اضافة المستخدم بنجاح");
        Navigator.pushNamed(context, "/usertable");
      } else if (res.statusCode == 409) {
        showSnackBar('البريد الالكتروني مأخوذ سابقاً', isError: true);
      } else if (res.statusCode == 403) {
        showSnackBar('لا تملك الصلاحية', isError: true);
      } else {
        showSnackBar("حدث خطأ ما, يرجى اعادة المحاولة", isError: true);
      }
    } catch (e) {
      showSnackBar("حدث خطأ ما, يرجى اعادة المحاولة", isError: true);
    }
  }

  Future destroy(context, String id, Function showSnackBar, String type,
      String nextroute) async {
    try {
      var res = await Api().dio.post('$type/destroy/$id');
      if (res.statusCode == 200) {
        Navigator.pushNamed(context, nextroute);
        showSnackBar("تم الحذف بنجاح");
      } else {
        showSnackBar("حدث خطأ ما, يرجى اعادة المحاولة", isError: true);
      }
    } catch (e) {
      showSnackBar("حدث خطأ ما, يرجى اعادة المحاولة", isError: true);
    }
  }

  Future editUser(context, String id, String name, String email,
      String password, String role, Function showSnackBar) async {
    var data = {
      "id": id,
      "name": name,
      "email": email,
      "password": password,
      "role": role
    };
    try {
      var res = await Api().dio.post('users/update', data: data);
      if (res.statusCode == 200) {
        Navigator.pushNamed(context, "/usertable");
        showSnackBar("تم تحديث المعلومات بنجاح");
      } else if (res.statusCode == 409) {
        showSnackBar("البريد الالكتروني مكرر. يرجى ادخال بريد جديد.",
            isError: true);
      } else {
        showSnackBar("حدث خطأ ما, يرجى اعادة المحاولة", isError: true);
      }
    } catch (e) {
      showSnackBar("حدث خطأ ما, يرجى اعادة المحاولة", isError: true);
    }
  }

  Future getInstructors() async {
    try {
      var res = await Api().dio.get("instructors/select");
      return res.data;
    } catch (e) {
      return e;
    }
  }

  Future getYears() async {
    try {
      var res = await Api().dio.get("semesters/get");
      return res.data;
    } catch (e) {
      return e;
    }
  }

  Future callPrintFourty(String path, id) async {
    try {
      Uri url =
          Uri.parse("http://localhost:8001/api/degrees/exfourty?course_id=$id");
      await launchUrl(url);
    } catch (e) {
      rethrow;
    }
  }

Future<void> endSemesters(String year, Function showSnackBar) async {
  var data = {'year': year};

  try {
    var res = await Api().dio.post('semesters/end', data: data);

    if (res.statusCode == 200) {
      showSnackBar('تمت العملية بنجاح');
    } else if (res.statusCode == 409) {
      showSnackBar("لا يوجد فصل دراسي حالي لانهاءه. الرجاء بدء فصل دراسي جديد", isError: true);
    } else {
      showSnackBar("حدث خطأ ما, يرجى التأكد من الاتصال بالشبكة.", isError: true);
    }
  } catch (error) {
    showSnackBar("حدث خطأ ما, يرجى التأكد من الاتصال بالشبكة.", isError: true);
  }
}
  // Future endSemester(String year,Function showSnackBar) async {
  //   var data = {'year': year};
  //   var res = await Api().dio.post('semesters/end',data: data);
  //   if (res.statusCode == 200) {
  //     showSnackBar('تمت العملية بنجاح');
  //   } else if (res.statusCode == 409) {
  //     showSnackBar("لا يوجد فصل دراسي حالي لانهاءه. الرجاء بدء فصل دراسي جديد",
  //         isError: true);
  //   } else {
  //     showSnackBar("حدث خطأ ما, يرجى التأكد من الاتصال بالشبكة.",
  //         isError: true);
  //   }
  // }

  Future createSemester(String year, showSnackBar) async {
    var data = {'year': year};
    var res = await Api().dio.post('semesters/create', data: data);
    if (res.statusCode == 200) {
      showSnackBar('تمت العملية بنجاح');
    } else if (res.statusCode == 410) {
      showSnackBar("السنة الدراسية الحالية غير منتهية", isError: true);
    } else {
      showSnackBar("حدث خطأ ما, يرجى التأكد من الاتصال بالشبكة.",
          isError: true);
    }
  }
}
