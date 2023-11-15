import 'package:SchoolBot/providers/exam_marks.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:flutter/material.dart';

class MarksBarChart extends StatelessWidget {
  final List<MarksData> markList;
  // final bool animate;

  MarksBarChart(this.markList);
  List<charts.Series<MarksData, String>> _createSampleData() {
    return [
      new charts.Series<MarksData, String>(
        id: 'Marks',
        colorFn: (MarksData barData, __) => charts.ColorUtil.fromDartColor(
            ((double.parse(barData.mark_total)).ceil() == 100 &&
                    (double.parse(barData.mark_obtained)).ceil() < 33)
                ? Colors.red
                : Colors.teal[400]!),
        domainFn: (MarksData barData, _) =>
            barData.subject_name.trim().replaceAll(" ", "\n"),
        measureFn: (MarksData barData, _) =>
            double.tryParse(barData.mark_obtained),
        data: markList,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    int barRange = (double.tryParse(markList.first.mark_total)!).ceil();

    return charts.BarChart(
      _createSampleData(),
      animate: true,
      // vertical: false,
      domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(
        labelRotation: 35, minimumPaddingBetweenLabelsPx: 4,
        // Tick and Label styling here.
        labelStyle: new charts.TextStyleSpec(
            lineHeight: 1.3, fontSize: 10, color: charts.MaterialPalette.black),
      )),

      /// Assign a custom style for the measure axis.
      primaryMeasureAxis: new charts.NumericAxisSpec(
          tickProviderSpec: new charts.StaticNumericTickProviderSpec(
            <charts.TickSpec<num>>[
              charts.TickSpec<num>(0),
              charts.TickSpec<num>(barRange / 4),
              charts.TickSpec<num>(barRange / 2),
              charts.TickSpec<num>(barRange / (4 / 3)),
              charts.TickSpec<num>(barRange),
            ],
          ),
          // showAxisLine: true,
          renderSpec: new charts.GridlineRendererSpec(
            // Tick and Label styling here.
            labelStyle: new charts.TextStyleSpec(
                fontSize: 16, // size in Pts.
                color: charts.MaterialPalette.black),
          )),
    );
  }

  /// Create one series with sample hard coded data.
}
