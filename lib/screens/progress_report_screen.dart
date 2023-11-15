import 'dart:io';

import 'package:SchoolBot/models/http_exception.dart';
import 'package:SchoolBot/providers/exam_marks.dart';
import 'package:SchoolBot/widgets/point_graph_chart.dart';
import 'package:SchoolBot/widgets/progress_report_card.dart';
import 'package:flutter/material.dart';
import 'package:open_file_safe_plus/open_file_safe_plus.dart';
// import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:SchoolBot/providers/auth.dart';

class ProgressReportScreen extends StatefulWidget {
  static const routeName = '/ProgressReportScreen';

  @override
  _ProgressReportScreenState createState() => _ProgressReportScreenState();
}

class _ProgressReportScreenState extends State<ProgressReportScreen> {
  bool _isInit = true;
  bool _isloading = true;
  late String _studentId;
  late String _studentName;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _openResult = 'Unknown';
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      _isInit = false;
      _studentId = ModalRoute.of(context)?.settings.arguments as String;
      await _fetchExamMarks();
      _studentName = Provider.of<Auth>(context, listen: false)
          .findStudentById(_studentId)
          .name;
    }
    super.didChangeDependencies();
  }

  Future<void> openFile(String filePath) async {
    await OpenFilePlus.open(filePath);

    // setState(() {
    //   _openResult = "type=${result.type}  message=${result.message}";
    // });
  }

  void _showSnackBar(String message, String path) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),

      elevation: 5,
      content: Container(
        height: 50,
        child: Row(
          children: [
            Expanded(
              child: Text(
                message,
                textScaleFactor: 1.2,
              ),
            ),
            SnackBarAction(
              label: 'View',
              textColor: Colors.yellow,
              onPressed: () {
                openFile((path).substring(1));
                // Navigator.of(context).push(MaterialPageRoute(
                //   fullscreenDialog: true,
                //   builder: (ctx) => PdfViewerScreen((path).substring(1)),
                // ));
              },
            ),
            SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.yellow,
              onPressed: () {},
            ),
          ],
        ),
      ),
      duration: Duration(seconds: 60),
      // action: SnackBarAction(
      //   label: 'View',
      //   textColor: Colors.white,
      //   onPressed: () {
      //     Navigator.of(context).push(MaterialPageRoute(
      //       fullscreenDialog: true,
      //       builder: (ctx) => PdfViewerScreen((path).substring(1)),
      //     ));
      //   },
      // ),
    ));
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error!'),
        content: Text(message, textAlign: TextAlign.center),
        actions: <Widget>[
          TextButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _fetchExamMarks() async {
    setState(() {
      _isloading = true;
    });
    try {
      await Provider.of<ExamMarks>(context, listen: false)
          .getStudentExamResults(_studentId);
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

  Future<void> _fetchMarkHtml() async {
    setState(() {
      _isloading = true;
    });
    try {
      final htmlResponse = await Provider.of<ExamMarks>(context, listen: false)
          .getExamResultsHtml(_studentId);
      // print(htmlResponse);
      Directory? documentDirectory = await getExternalStorageDirectory();
      String? dowloadPath = documentDirectory?.path;

      // var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
      //     htmlResponse, dowloadPath!, "$_studentId-$_studentName");
      // _showSnackBar("Download Completed", generatedPdfFile.path);
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

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    String _studentId = ModalRoute.of(context)?.settings.arguments as String;
    StudentData _studentData =
        Provider.of<Auth>(context, listen: false).findStudentById(_studentId);
    List<List<MarksData>> examMarks =
        Provider.of<ExamMarks>(context, listen: false).examMarks();
    List<ExamTotal> _examTotal = Provider.of<ExamMarks>(context).examTotal();
    List<Result> _examAttendance =
        Provider.of<ExamMarks>(context).examAttendance;
    List<Result> _examResults = Provider.of<ExamMarks>(context).examResults;
    return Scaffold(
        key: _scaffoldKey,
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
              "Progress Report",
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(color: Colors.grey[700]),
            )),
        backgroundColor: Colors.white,
        body: _isloading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColorDark,
                ),
              )
            : SingleChildScrollView(
                child: examMarks.length == 0
                    ? SizedBox()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(12),
                            width: deviceSize.width * 0.90,
                            // color: Colors.white70
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${_studentData.name}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[800],
                                            height: 1.2),
                                      ),
                                      Text(
                                        "${_studentData.className}-${_studentData.sectionName}",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[800],
                                            height: 1.2),
                                      ),
                                      Text(
                                        "Roll No. ${examMarks.first.first.student_roll}",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[800],
                                            height: 1.2),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.grey, width: 1)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: FadeInImage(
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                        placeholder: AssetImage(
                                            "assets/images/profileO.png"),
                                        image: NetworkImage(
                                            "${_studentData.imageUrl}")),
                                  ),
                                )
                              ],
                            ),
                          ),
                          ElevatedButton.icon(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                elevation: 10,
                                backgroundColor: Colors.yellow,
                              ),
                              onPressed: () {
                                _fetchMarkHtml();
                              },
                              icon: Icon(Icons.file_download),
                              label: Text("Report Card Download")),
                          SizedBox(
                            height: 16,
                          ),
                          ExamPercentageChart(_examTotal),
                          ...examMarks.map((markList) => ProgressReportCard(
                                markList,
                                _examTotal.firstWhere((element) =>
                                    element.exam_name ==
                                    markList.first.exam_name),
                              ))
                        ],
                      ),
              ));
  }
}
