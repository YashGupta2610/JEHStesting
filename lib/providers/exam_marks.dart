// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as https;

import 'package:SchoolBot/models/http_exception.dart';

class MarksData {
  String exam_name;
  String class_name;
  String section_name;
  String subject_name;
  String student_name;
  String student_roll;
  String mark_total;
  String mark_obtained;
  String comment;
  String grade;

  MarksData(
      {required this.exam_name,
      required this.class_name,
      required this.section_name,
      required this.comment,
      required this.mark_obtained,
      required this.mark_total,
      required this.student_name,
      required this.student_roll,
      required this.subject_name,
      required this.grade});
}

class ExamTotal {
  String exam_name;
  double total;
  double percentage;
  String grade;
  double obtained;
  ExamTotal(
      {required this.exam_name,
      required this.total,
      required this.percentage,
      required this.grade,
      required this.obtained});
}

class Grade {
  double max;
  double min;
  String grade;
  Grade({
    required this.grade,
    required this.max,
    required this.min,
  });
}

class Result {
  String exam_id;
  String class_id;
  String grade;
  String exam_name;

  Result(
      {this.class_id = "",
      this.exam_id = "",
      this.grade = "",
      this.exam_name = ""});
}

List<Grade> grades = [
  Grade(grade: "A+", max: 100, min: 90),
  Grade(grade: "A", max: 90, min: 80),
  Grade(grade: "B+", max: 80, min: 70),
  Grade(grade: "B", max: 70, min: 60),
  Grade(grade: "C+", max: 60, min: 50),
  Grade(grade: "C", max: 50, min: 40),
  Grade(grade: "D", max: 40, min: 0),
];

class ExamMarks with ChangeNotifier {
  final String authenticationKey;

  ExamMarks({this.authenticationKey = ""});

  List<MarksData> _studentMarksData = [];
  List<String> examIdList = [];
  List<Result> examAttendance = [];
  List<Result> examResults = [];
  List<MarksData> get studentMarksData {
    return [..._studentMarksData];
  }

  List<List<MarksData>> examMarks() {
    List<List<MarksData>> exams = [];
    examIdList.reversed.forEach((id) {
      List<MarksData> markList =
          studentMarksData.where((marks) => marks.exam_name == id).toList();
      exams.add(markList);
    });
    return exams;
  }

  String getExamAttendance(String examName) {
    var examAtt = examAttendance
        .firstWhere((element) => element.exam_name == examName, orElse: () {
      return Result();
    });
    if (examAtt != null) {
      return examAtt.grade;
    } else {
      return "";
    }
  }

  String getExamResult(String examName) {
    var examRes = examResults
        .firstWhere((element) => element.exam_name == examName, orElse: () {
      return Result();
    });
    if (examRes != null) {
      return examRes.grade;
    } else {
      return "";
    }
  }

  List<ExamTotal> examTotal() {
    List<ExamTotal> examPer = [];
    examIdList.forEach((id) {
      double totalMarks = 0;
      double totalObtained = 0;

      List<MarksData> markList =
          studentMarksData.where((marks) => marks.exam_name == id).toList();

      markList.forEach((exam) {
        if (exam.subject_name.toLowerCase() != "attendance") {
          totalObtained += double.tryParse(exam.mark_obtained) ?? 0;
          totalMarks += double.tryParse(exam.mark_total) ?? 0;
        }
      });
      examPer.add(ExamTotal(
          exam_name: id,
          percentage: (totalObtained / totalMarks) * 100,
          total: totalMarks,
          obtained: totalObtained,
          grade: grades
              .firstWhere((grade) =>
                  (grade.max >= (totalObtained / totalMarks) * 100 &&
                      (totalObtained / totalMarks) * 100 >= grade.min))
              .grade));
    });
    return examPer;
  }

  Future<void> getStudentExamResults(String studentId) async {
    final url =
        "https://schoolbot.in/jehs/index.php/mobile/get_student_exam_marks?authenticate=$authenticationKey&student_id=$studentId&user_type=parent";
    // "https://schoolbot.in/jehs/index.php/mobile/get_child_exam_marks?authenticate=$authenticationKey&student_id=97&user_type=parent";

    try {
      final response = await https.get(Uri.parse(url));
      final responseData = json.decode(response.body);
      // print("responseData $responseData");

      List _responseExamMarks = responseData["marksData"];
      List _responseAttendanceData = responseData["attendanceData"];
      List _responseResultData = responseData["resultData"];
      _studentMarksData.clear();
      examIdList.clear();
      examAttendance.clear();
      examResults.clear();

      _responseExamMarks.forEach((marks) {
        if (marks["subject_name"].toString().toLowerCase() != "attendance") {
          // print(marks);
          double percentage = (double.tryParse(marks["mark_obtained"])! /
                  double.tryParse(marks["mark_total"])!) *
              100;

          var mark = MarksData(
              class_name: marks["class_name"],
              comment: marks["comment"],
              exam_name: marks["exam_name"],
              mark_obtained: marks["mark_obtained"],
              mark_total: marks["mark_total"],
              section_name: marks["section_name"],
              student_name: marks["student_name"],
              student_roll: marks["student_roll"],
              subject_name: marks["subject_name"],
              grade: grades
                  .firstWhere((grade) =>
                      (grade.max >= percentage && percentage >= grade.min))
                  .grade);
          _studentMarksData.add(mark);
          if (!examIdList.contains(mark.exam_name)) {
            examIdList.add(mark.exam_name);
          }
        }
      });
      _responseResultData.forEach((results) {
        var result = Result(
            class_id: results["class_id"],
            exam_id: results["exam_id"],
            exam_name: results["exam_name"],
            grade: results["grade"]);
        examResults.add(result);
      });
          _responseAttendanceData.forEach((attendance) {
        var att = Result(
            class_id: attendance["class_id"],
            exam_id: attendance["exam_id"],
            exam_name: attendance["exam_name"],
            grade: attendance["grade"]);
        examAttendance.add(att);
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

  Future<String> getExamResultsHtml(String studentId) async {
    final url =
        "https://schoolbot.in/jehs/index.php/admin/overall_marksheet_print_view/$studentId/1";
    // "https://schoolbot.in/jehs/index.php/mobile/get_child_exam_marks?authenticate=$authenticationKey&student_id=97&user_type=parent";

    try {
      final response = await https.get(Uri.parse(url));
      if (response.statusCode == 200) {
        String htmlToParse = """${response.body}""";
        return htmlToParse;
      }
      throw HttpException("Unable to download\nTry again later");
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
