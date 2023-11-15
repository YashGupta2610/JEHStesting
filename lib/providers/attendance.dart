// ignore_for_file: non_constant_identifier_names, duplicate_ignore

import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as https;

import 'package:SchoolBot/models/http_exception.dart';

class AttanDanceData {
  // ignore: non_constant_identifier_names
  String class_id;
  String section_id;
  String class_routine_id;
  String academicYear;
  String year;
  String month;
  DateTime datetime;
  int status;
  String comment;
  String studentName;
  String student_id;

  AttanDanceData({
    required this.class_id,
    required this.section_id,
    required this.class_routine_id,
    required this.academicYear,
    required this.year,
    required this.comment,
    required this.status,
    required this.datetime,
    required this.month,
    this.studentName = "",
    required this.student_id,
  });
}

Map<int, String> attendanceStatus = {
  0: "Attendance not taken",
  1: "Present",
  2: "Absent",
  3: "Holiday",
  4: "Sunday",
  5: "Halfday",
};

class Attandance with ChangeNotifier {
  final String authenticationKey;

  Attandance({this.authenticationKey = ""});

  List<AttanDanceData> _attendanceData = [];

  List<AttanDanceData> get attendanceData {
    return [..._attendanceData];
  }

  Future<void> getAttendance(String studentId) async {
    final url =
        'https://schoolbot.in/jehs/index.php/mobile/get_child_attendance?authenticate=$authenticationKey&user_type=parent&student_id=$studentId&date=1&month=1&year=2021';

    try {
      // print("checking");
      final response = await https.get(Uri.parse(url));
      // print("checking");
      final responseData = json.decode(response.body);
      // print(responseData);

      List _attendance = responseData;
      _attendanceData.clear();
      _attendance.forEach((singleDay) {
        var attendance = AttanDanceData(
            academicYear: singleDay["Year"],
            class_id: singleDay["class_id"],
            class_routine_id: singleDay["class_routine_id"],
            comment: (singleDay["status"] != null &&
                    attendanceStatus
                        .containsKey(int.tryParse(singleDay["status"])))
                ? attendanceStatus[int.tryParse(singleDay["status"])]!
                : "",
            datetime: DateTime.parse(singleDay["datetime"]),
            month: singleDay["MonthVal"],
            section_id: singleDay["section_id"].toString(),
            status: (singleDay["status"] != null)
                ? int.tryParse(singleDay["status"])!
                : 0,
            student_id: singleDay["student_id"].toString(),
            year: singleDay["YearVal"].toString());
        // print("attendance.datetime ${attendance.datetime}");
        // print(singleDay["datetime"]);

        _attendanceData.add(attendance);
      });
      notifyListeners();
    } on SocketException catch (error) {
      if (error.toString().contains("Connection failed")) {
        throw HttpException("Check Internet Connectivity");
      }
      if (error.toString().contains("Connection refused")) {
        throw HttpException("Please try again later");
      }
      throw HttpException("Check Internet Connectivity\nor\nTry again later");
    } catch (error) {
      // print(error);
      throw error;
    }
  }
}

// {"datetime":"2020-05-27 18:30:00","MonthVal":"May","YearVal":"2020","Year":"2020-2021","class_id":"4","section_id":"4","class_routine_id":null,"status":null,"name":"AARUSH DAVID.A","student_id":"119"}
