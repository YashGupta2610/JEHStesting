import 'package:SchoolBot/providers/exam_marks.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:flutter/material.dart';

class ExamPercentageChart extends StatelessWidget {
  final List<ExamTotal> examPercentage;

  ExamPercentageChart(
    this.examPercentage,
  );

  List<charts.Series<ExamTotal, int>> _createSampleData() {
    return [
      new charts.Series<ExamTotal, int>(
        id: 'Exam',
        domainFn: (ExamTotal exam, _) => examPercentage
            .indexWhere((element) => element.exam_name == exam.exam_name),
        measureFn: (ExamTotal exam, _) => exam.percentage,
        data: examPercentage,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final customTickFormatter =
        charts.BasicNumericTickFormatterSpec((num value) {
      return "${examPercentage[value.ceil()].exam_name}\n(${examPercentage[value.ceil()].percentage.toStringAsFixed(1)}%)";
    } as charts.MeasureFormatter?);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      height: deviceSize.height / 2,
      width: deviceSize.width,
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 8, top: 16, bottom: 16, right: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.yellowAccent[700]!, width: 2),
          color: Colors.grey[100]),
      child: new charts.LineChart(_createSampleData(),
          animate: true,
          primaryMeasureAxis: new charts.NumericAxisSpec(
            tickProviderSpec: new charts.StaticNumericTickProviderSpec(
              <charts.TickSpec<num>>[
                charts.TickSpec<num>(0),
                charts.TickSpec<num>(25),
                charts.TickSpec<num>(50),
                charts.TickSpec<num>(75),
                charts.TickSpec<num>(100),
              ],
            ),
          ),
          domainAxis: charts.NumericAxisSpec(
              tickProviderSpec: charts.BasicNumericTickProviderSpec(
                  desiredTickCount: examPercentage.length),
              tickFormatterSpec: customTickFormatter,
              renderSpec: new charts.SmallTickRendererSpec(
                labelRotation: 40, minimumPaddingBetweenLabelsPx: 4,
                // Tick and Label styling here.
                labelStyle: new charts.TextStyleSpec(
                    // lineHeight: ,
                    fontSize: 12,
                    color: charts.MaterialPalette.black),
              )),
          defaultRenderer: new charts.LineRendererConfig(includePoints: true)),
    );
  }
}
