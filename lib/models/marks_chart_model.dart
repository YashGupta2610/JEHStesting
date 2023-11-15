import 'package:charts_flutter_new/flutter.dart' as charts;

class BarChartModel {
  String subject;
  int marks;
  final charts.Color color;

  BarChartModel({
    required this.subject,
    required this.marks,
    required this.color,
  });
}
