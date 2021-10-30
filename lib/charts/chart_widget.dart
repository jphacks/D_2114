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
      colorFn: (_, __) =>
          charts.ColorUtil.fromDartColor((Colors.lightBlue[300])!),
      domainFn: (DataPoint datapoint, _) => datapoint.time,
      measureFn: (DataPoint datapoint, _) => datapoint.value,
      data: actualDataPointList,
    ),
    charts.Series<DataPoint, DateTime>(
      id: 'predictedData',
      colorFn: (_, __) => charts.ColorUtil.fromDartColor((Colors.red[300])!),
      domainFn: (DataPoint datapoint, _) => datapoint.time,
      measureFn: (DataPoint datapoint, _) => datapoint.value,
      data: predictedDataPointList,
    ),
  ];

  return charts.TimeSeriesChart(
    seriesList,
    animate: true,
    dateTimeFactory: const charts.LocalDateTimeFactory(),
    domainAxis: charts.DateTimeAxisSpec(
      renderSpec: charts.SmallTickRendererSpec(
        labelStyle: charts.TextStyleSpec(
          fontSize: 13,
          color: charts.ColorUtil.fromDartColor((Colors.blueGrey[200])!),
        ),
        lineStyle: charts.LineStyleSpec(
          color: charts.ColorUtil.fromDartColor((Colors.grey[800])!),
        ),
      ),
    ),
    primaryMeasureAxis: charts.NumericAxisSpec(
      renderSpec: charts.GridlineRendererSpec(
        labelStyle: charts.TextStyleSpec(
          fontSize: 13,
          color: charts.ColorUtil.fromDartColor((Colors.blueGrey[200])!),
        ),
        lineStyle: charts.LineStyleSpec(
          color: charts.ColorUtil.fromDartColor((Colors.grey[800])!),
        ),
      ),
    ),
  );
}
