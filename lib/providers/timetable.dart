import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as https;

import 'package:SchoolBot/models/http_exception.dart';

class TimeTableData {
  String classId;
  String subject;
  String timeStart;
  String timeEnd;
  String day;

  TimeTableData(
      {required this.classId,
      required this.day,
      required this.subject,
      required this.timeEnd,
      required this.timeStart});
}

class TimeTable with ChangeNotifier {
  final String authenticationKey;

  TimeTable({this.authenticationKey = ""});

  List<TimeTableData> _mondayTableData = [];
  List<TimeTableData> _tuesdayTableData = [];
  List<TimeTableData> _wednesdayTableData = [];
  List<TimeTableData> _thursdayTableData = [];
  List<TimeTableData> _fridayTableData = [];
  List<TimeTableData> _saturdayTableData = [];

  int maxClassesPerDay = 0;

  List<TimeTableData> dayWithMaxClasses() {
    var maxday = [
      _mondayTableData,
      _tuesdayTableData,
      _wednesdayTableData,
      _thursdayTableData,
      _fridayTableData,
      _saturdayTableData
    ].firstWhere((day) => day.length == maxClassesPerDay);
    return maxday;
  }

  List<TimeTableData> get mondayTableData {
    return [..._mondayTableData];
  }

  List<TimeTableData> get tuesdayTableData {
    return [..._tuesdayTableData];
  }

  List<TimeTableData> get wednesdayTableData {
    return [..._wednesdayTableData];
  }

  List<TimeTableData> get thursdayTableData {
    return [..._thursdayTableData];
  }

  List<TimeTableData> get fridayTableData {
    return [..._fridayTableData];
  }

  List<TimeTableData> get saturdayTableData {
    return [..._saturdayTableData];
  }

  Future<void> getTimeTable(String studentId) async {
    // print("studentId $studentId");
    final url =
        "https://schoolbot.in/jehs/index.php/mobile/get_student_class_routine?authenticate=$authenticationKey&user_type=parent&student_id=$studentId";
    try {
      // print("checking");
      final response = await https.get(Uri.parse(url));
      // print("checking");
      final responseData = json.decode(response.body);
      // print(responseData);

      List _timeTable = responseData;

      _mondayTableData.clear();
      _tuesdayTableData.clear();
      _wednesdayTableData.clear();
      _thursdayTableData.clear();
      _fridayTableData.clear();
      _saturdayTableData.clear();

      _timeTable.forEach((singlePeriod) {
        // print(singlePeriod);
        var _period = TimeTableData(
          classId: singlePeriod["class_id"],
          day: singlePeriod["day"],
          subject: singlePeriod["subject"],
          timeStart:
              "${singlePeriod["time_start"]}:${singlePeriod["time_start_min"]}",
          timeEnd:
              "${singlePeriod["time_end"]}:${singlePeriod["time_end_min"]}",
        );
        // print("${_period.timeStart} - ${_period.timeStart}");
        if (_period.day == "monday") {
          _mondayTableData.add(_period);
        } else if (_period.day == "tuesday") {
          _tuesdayTableData.add(_period);
        } else if (_period.day == "wednesday") {
          _wednesdayTableData.add(_period);
        } else if (_period.day == "thursday") {
          _thursdayTableData.add(_period);
        } else if (_period.day == "friday") {
          _fridayTableData.add(_period);
        } else if (_period.day == "saturday") {
          _saturdayTableData.add(_period);
        }
      });
      maxClassesPerDay = [
        _mondayTableData.length,
        _tuesdayTableData.length,
        _wednesdayTableData.length,
        _thursdayTableData.length,
        _fridayTableData.length,
        _saturdayTableData.length
      ].reduce(max);

      // ignore: unused_local_variable
      List<List<TimeTableData>> weekDays = [
        _mondayTableData,
        _tuesdayTableData,
        _wednesdayTableData,
        _thursdayTableData,
        _fridayTableData,
        _saturdayTableData
      ];

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
