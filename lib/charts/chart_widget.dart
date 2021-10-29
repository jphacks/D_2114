import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import 'data_class.dart';

Widget chartBody(List actualData, List predictedData) {
  List<DataPoint> actualDataPointList =
      actualData.map((element) => DataPoint.fromMap(element)).toList();
  List<DataPoint> predictedDataPointList =
      predictedData.map((element) => DataPoint.fromMap(element)).toList();

  List<charts.Series<DataPoint, DateTime>> seriesList = [
    charts.Series<DataPoint, DateTime>(
      id: 'actualData',
      colorFn: (_, __) => charts.ColorUtil.fromDartColor((Colors.orange[300])!),
      domainFn: (DataPoint datapoint, _) => datapoint.time,
      measureFn: (DataPoint datapoint, _) => datapoint.value,
      data: actualDataPointList,
    ),
    charts.Series<DataPoint, DateTime>(
      id: 'predictedData',
      colorFn: (_, __) => charts.ColorUtil.fromDartColor((Colors.white)),
      domainFn: (DataPoint datapoint, _) => datapoint.time,
      measureFn: (DataPoint datapoint, _) => datapoint.value,
      data: predictedDataPointList,
    ),
  ];

  return charts.TimeSeriesChart(
    seriesList,
    animate: true,
    // Optionally pass in a [DateTimeFactory] used by the chart. The factory
    // should create the same type of [DateTime] as the data provided. If none
    // specified, the default creates local date time.
    dateTimeFactory: const charts.LocalDateTimeFactory(),

    /// This is an OrdinalAxisSpec to match up with BarChart's default
    /// ordinal domain axis (use NumericAxisSpec or DateTimeAxisSpec for
    /// other charts).
    domainAxis: charts.DateTimeAxisSpec(
      renderSpec: charts.SmallTickRendererSpec(
        // Tick and Label styling here.
        labelStyle: charts.TextStyleSpec(
          fontSize: 14, // size in Pts.
          color: charts.ColorUtil.fromDartColor((Colors.grey[400])!),
        ),

        // Change the line colors to match text color.
        lineStyle: charts.LineStyleSpec(
          color: charts.ColorUtil.fromDartColor((Colors.grey[200])!),
        ),
      ),
    ),

    /// Assign a custom style for the measure axis.
    primaryMeasureAxis: charts.NumericAxisSpec(
      renderSpec: charts.GridlineRendererSpec(
        // Tick and Label styling here.
        labelStyle: charts.TextStyleSpec(
          fontSize: 14, // size in Pts.
          color: charts.ColorUtil.fromDartColor((Colors.grey[400])!),
        ),

        // Change the line colors to match text color.
        lineStyle: charts.LineStyleSpec(
          color: charts.ColorUtil.fromDartColor((Colors.grey[200])!),
        ),
      ),
    ),
  );
}
