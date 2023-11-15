import 'package:SchoolBot/providers/timetable.dart';
import 'package:SchoolBot/widgets/student_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SchoolBot/providers/auth.dart';
import 'package:SchoolBot/models/http_exception.dart';

class TimeTableScreen extends StatefulWidget {
  static const routeName = '/timeTableScreen';

  @override
  _TimeTableScreenState createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  bool _isInit = true;
  bool _isloading = true;
  late String _studentId;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      _studentId = ModalRoute.of(context)?.settings.arguments as String;
      await _fetchTimeTable();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Map<String, List<Color>> dayColors = {
    "Monday": [
      Colors.amber[100]!,
      Colors.amberAccent[400]!,
    ],
    "Tuesday": [
      Colors.lightGreen[100]!,
      Colors.lightGreen[300]!,
    ],
    "Wednesday": [
      Colors.red[100]!,
      Colors.redAccent[100]!,
    ],
    "Thursday": [
      Colors.purple[100]!,
      Colors.purple[200]!,
    ],
    "Friday": [
      Colors.yellow[200]!,
      Colors.yellow,
    ],
    "Saturday": [
      Colors.cyan[100]!,
      Colors.cyan,
    ]
  };
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
              _fetchTimeTable();
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _fetchTimeTable() async {
    setState(() {
      _isloading = true;
    });
    try {
      await Provider.of<TimeTable>(context, listen: false)
          .getTimeTable(_studentId);
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

  Widget build(BuildContext context) {
    StudentData _studentData =
        Provider.of<Auth>(context, listen: false).findStudentById(_studentId);
    List<TimeTableData> _mondayTableData =
        Provider.of<TimeTable>(context).mondayTableData;
    List<TimeTableData> _tuesdayTableData =
        Provider.of<TimeTable>(context).tuesdayTableData;
    List<TimeTableData> _wednesdayTableData =
        Provider.of<TimeTable>(context).wednesdayTableData;
    List<TimeTableData> _thursdayTableData =
        Provider.of<TimeTable>(context).thursdayTableData;
    List<TimeTableData> _fridayTableData =
        Provider.of<TimeTable>(context).fridayTableData;
    List<TimeTableData> _saturdayTableData =
        Provider.of<TimeTable>(context).saturdayTableData;
    List<TimeTableData> _maxClassesTableData =
        Provider.of<TimeTable>(context).dayWithMaxClasses();

    Map<String, List<TimeTableData>> weekMap = {
      "Monday": _mondayTableData,
      "Tuesday": _tuesdayTableData,
      "Wednesday": _wednesdayTableData,
      "Thursday": _thursdayTableData,
      "Friday": _fridayTableData,
      "Saturday": _saturdayTableData
    };
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              "Time table",
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(color: Colors.red),
            )),
        backgroundColor: Colors.white,
        body: _isloading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColorDark,
                ),
              )
            : Column(
                children: [
                  StudentHeader(_studentData),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          ...weekMap.keys.map(
                            (key) => Container(
                              padding: EdgeInsets.only(left: 8, bottom: 8),
                              margin: EdgeInsets.symmetric(vertical: 2),
                              color: dayColors[key]?[0],
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    key,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.symmetric(
                                        vertical: BorderSide(
                                            color: Colors.white, width: 1),
                                        horizontal: BorderSide(
                                            color: Colors.white, width: 2),
                                      )),
                                      child: Row(
                                        children: [
                                          ...?weekMap[key]?.map(
                                            (period) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                    border: Border.symmetric(
                                                  vertical: BorderSide(
                                                      color: Colors.white,
                                                      width: 1),
                                                )),
                                                alignment: Alignment.center,
                                                width: 100,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    Text(
                                                      "${period.timeStart}\n-\n${period.timeEnd}",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        height: 1,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    // Divider(
                                                    //   color: dayColors[key][1],
                                                    //   height: 4,
                                                    //   thickness: 2,
                                                    //   endIndent: 4,
                                                    //   indent: 4,
                                                    // ),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 100,
                                                      height: 55,
                                                      padding:
                                                          EdgeInsets.all(4),
                                                      decoration: BoxDecoration(
                                                          color: dayColors[key]
                                                              ?[1],
                                                          border: Border(
                                                              top: BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 2))),
                                                      child: Text(
                                                        "${period.subject}",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            height: 1,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ));
  }
}
