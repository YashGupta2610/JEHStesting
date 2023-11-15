import 'package:SchoolBot/screens/attendance_screen.dart';
import 'package:SchoolBot/screens/fees_screen.dart';
import 'package:SchoolBot/screens/progress_report_screen.dart';
import 'package:SchoolBot/screens/timetable_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SchoolBot/providers/auth.dart';

class StudentDetailsScreen extends StatelessWidget {
  static const routeName = '/StudentDetailsScreen';
  Widget textData(String title, String data) {
    return Row(
      children: [
        Text(
          "$title",
          style: TextStyle(color: Colors.grey),
        ),
        Text(
          (!data.contains("null") && data.isNotEmpty) ? "$data" : "-",
          style: TextStyle(color: Colors.grey[700], fontSize: 20),
        ),
      ],
    );
  }

  Widget iconData(
      {required String title,
      required String iconPath,
      required Color color,
      required String navigation,
      required String studentId,
      required BuildContext context}) {
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).pushNamed(navigation, arguments: studentId),
      child: Card(
        color: color,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Container(
          width: 180,
          child: Row(
            children: [
              Image.asset(
                iconPath,
                height: 50,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: TextStyle(color: Colors.grey[800], fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final _studentid = ModalRoute.of(context)?.settings.arguments as String;
    StudentData _studentData =
        Provider.of<Auth>(context).findStudentById(_studentid);
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBody: true,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(alignment: Alignment.bottomCenter, children: <Widget>[
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  margin: EdgeInsets.only(
                      top: 30, bottom: 310, right: 10, left: 10),
                  child: Container(
                    height: 150,
                    padding: EdgeInsets.only(top: 10),
                    width: deviceSize.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [Colors.yellow[100]!, Colors.pink[300]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0, 1],
                        )),
                    child: Column(
                      children: <Widget>[
                        Card(
                          elevation: 24,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: FadeInImage(
                              height: 100,
                              image: NetworkImage(_studentData.imageUrl),
                              placeholder: AssetImage(
                                "assets/images/Account_Circle.png",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.only(bottom: 20),
                  elevation: 10,
                  color: Colors.white.withOpacity(0.95),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    width: deviceSize.width * 0.85,
                    // color: Colors.white70
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        textData("Student  ", "${_studentData.name}"),
                        textData(
                          "Class  ",
                          (_studentData.sectionName == _studentData.className)
                              ? "${_studentData.className}"
                              : "${_studentData.className}-${_studentData.sectionName}",
                        ),
                        textData("Admission No.  ",
                            "${_studentData.admissionNumber}"),
                        textData("Phone  ", "${_studentData.phone}"),
                        textData("Email  ", "${_studentData.email}"),
                        textData("Birthday  ", "${_studentData.birthday}"),
                        textData("Gender  ", "${_studentData.gender}"),
                        textData("Blood Group  ", "${_studentData.bloodGroup}"),
                        textData("Religion  ", "${_studentData.religion}"),
                      ],
                    ),
                  ),
                )
              ]),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  iconData(
                      studentId: _studentid,
                      context: context,
                      navigation: AttendanceScreen.routeName,
                      color: Colors.teal[100]!,
                      iconPath: "assets/images/Attendance.png",
                      title: "Attendance"),
                  iconData(
                    studentId: _studentid,
                    context: context,
                    navigation: TimeTableScreen.routeName,
                    color: Colors.red[200]!,
                    iconPath: "assets/images/timetable.png",
                    title: "Timetable",
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  iconData(
                      studentId: _studentid,
                      context: context,
                      navigation: ProgressReportScreen.routeName,
                      title: "Progress Card",
                      iconPath: "assets/images/ProgressCard.png",
                      color: Colors.grey[400]!),
                  iconData(
                      studentId: _studentid,
                      context: context,
                      navigation: FeesScreen.routeName,
                      title: "School Fees",
                      iconPath: "assets/images/fees.png",
                      color: Colors.amber[100]!),
                ],
              ),
            ],
          ),
        ));
  }
}
