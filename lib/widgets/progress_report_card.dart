import 'package:SchoolBot/providers/exam_marks.dart';
import 'package:SchoolBot/widgets/bar_chart_graph.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProgressReportCard extends StatelessWidget {
  final List<MarksData> markList;
  final ExamTotal _examTotal;
  ProgressReportCard(this.markList, this._examTotal);

  Widget marksRow(
      // ignore: non_constant_identifier_names
      String subject,
      String mark_total,
      String mark_obtained,
      String grade) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 1),
      padding: EdgeInsets.all(2),
      color: Colors.grey[200],
      child: Row(
        children: [
          Expanded(
              child: Text(
            subject,
            style: TextStyle(height: 1.1),
          )),
          Container(
              width: 70,
              alignment: Alignment.center,
              child: Text(
                "${(double.tryParse(mark_total))?.ceil()}",
                textAlign: TextAlign.center,
              )),
          Container(
              width: 75,
              alignment: Alignment.center,
              child: Text(
                mark_obtained,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: ((double.tryParse(mark_total))?.ceil() == 100 &&
                            (double.tryParse(mark_obtained))!.ceil() < 33)
                        ? Colors.red
                        : Colors.black),
              )),
          Container(
              width: 60,
              alignment: Alignment.center,
              child: Text(
                grade,
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String examAttendance = Provider.of<ExamMarks>(context)
        .getExamAttendance(markList.first.exam_name);
    String examResult =
        Provider.of<ExamMarks>(context).getExamResult(markList.first.exam_name);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [Colors.yellow[400]!, Colors.teal[400]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 1],
            )),
        child: Column(
          children: [
            Text(
              markList.first.exam_name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            if (examAttendance.isNotEmpty || examResult.isNotEmpty)
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: Colors.yellowAccent[700]!, width: 2),
                    color: Colors.grey[100]),
                child: Column(
                  children: [
                    if (examAttendance.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Attendance",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            examAttendance,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    if (examAttendance.isNotEmpty && examResult.isNotEmpty)
                      Divider(
                        height: 12,
                        thickness: 1,
                      ),
                    if (examResult.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Result",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: Text(
                              examResult,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  height: 1),
                            ),
                          ),
                        ],
                      )
                  ],
                ),
              ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: Colors.yellowAccent[700]!, width: 2),
                  color: Colors.grey[100]),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Subject",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              height: 1),
                        ),
                      ),
                      Container(
                        width: 70,
                        alignment: Alignment.center,
                        child: Text(
                          "Max\nmarks",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              height: 1),
                        ),
                      ),
                      Container(
                        width: 75,
                        alignment: Alignment.center,
                        child: Text(
                          "Marks\nobtained",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              height: 1),
                        ),
                      ),
                      Container(
                        width: 60,
                        alignment: Alignment.center,
                        child: Text(
                          "Grade",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              height: 1),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                      height: 4, thickness: 1, color: Colors.yellowAccent[700]),
                  ...markList.map((subject) => marksRow(
                      subject.subject_name,
                      subject.mark_total,
                      subject.mark_obtained,
                      subject.grade)),
                  Divider(
                      height: 4, thickness: 1, color: Colors.yellowAccent[700]),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Total",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              height: 1),
                        ),
                      ),
                      Container(
                        width: 70,
                        alignment: Alignment.center,
                        child: Text(
                          "${_examTotal.total.ceil()}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              height: 1),
                        ),
                      ),
                      Container(
                        width: 75,
                        alignment: Alignment.center,
                        child: Text(
                          "${_examTotal.obtained}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              height: 1),
                        ),
                      ),
                      Container(
                        width: 60,
                        alignment: Alignment.center,
                        child: Text(
                          "${_examTotal.grade}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              height: 1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: Colors.yellowAccent[700]!, width: 2),
                    color: Colors.grey[100]),
                child: Column(
                  children: [
                    Text(
                      markList.first.exam_name,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height / 2.3,
                        child: MarksBarChart(markList)),
                  ],
                )),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
