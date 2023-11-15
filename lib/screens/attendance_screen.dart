import 'package:SchoolBot/models/http_exception.dart';
import 'package:SchoolBot/providers/attendance.dart';
import 'package:SchoolBot/widgets/student_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SchoolBot/providers/auth.dart';
import 'package:SchoolBot/widgets/attendance_calendar.dart';

class AttendanceScreen extends StatefulWidget {
  static const routeName = '/AttendanceScreen';

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool _isloading = false;
  bool _isInit = true;
  late StudentData studentData;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      _isInit = false;
      String _studentId = ModalRoute.of(context)?.settings.arguments as String;

      studentData =
          Provider.of<Auth>(context, listen: false).findStudentById(_studentId);

      await _getAttendance();
    }

    // ignore: todo
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error!'),
        content: Text(message, textAlign: TextAlign.center),
        actions: <Widget>[
          TextButton(
            child: Text('Retry'),
            onPressed: () {
              _getAttendance();
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _getAttendance() async {
    setState(() {
      _isloading = true;
    });
    try {
      await Provider.of<Attandance>(context)
          .getAttendance(studentData.studentId);
    } on HttpException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      const errorMessage = 'Sorry something went wrong';
      _showErrorDialog(errorMessage);
    } finally {
      setState(() {
        _isloading = false;
      });
    }
  }

  Widget colorMark(String title, Color color) {
    return FittedBox(
      child: Container(
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(50)),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              radius: 15,
            ),
            SizedBox(
              width: 4,
            ),
            Text(title),
            SizedBox(
              width: 4,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.only(
            //     bottomLeft: Radius.circular(10),
            //     bottomRight: Radius.circular(10),
            //   ),
            // ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              "Attendance",
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(color: Colors.teal[300]),
            )),
        backgroundColor: Colors.white,
        body: (_isloading)
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColorDark,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    StudentHeader(studentData),
                    SizedBox(
                      height: 20,
                    ),
                    Card(
                      child: AttendanceCalendar(),
                      margin:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      elevation: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      children: [
                        colorMark("Present", Colors.green),
                        colorMark("Absent", Colors.red),
                        colorMark("Holiday", Colors.blue[300]!),
                        colorMark("Sunday", Colors.yellow),
                        colorMark("Attendance not taken", Colors.grey),
                        colorMark("Halfday", Colors.pink),
                      ],
                    )
                  ],
                ),
              ));
  }
}
