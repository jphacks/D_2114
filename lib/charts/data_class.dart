class DataPoint {
  late double value;
  late DateTime time;
  DataPoint(this.value, this.time);

  DataPoint.fromMap(Map map) {
    time = map['timestamp'].toDate();
    if (map['value'] is double) {
      value = map['value'];
    } else {
      value = (map['value'] as int).toDouble();
    }
  }

  @override
  String toString() => "Record<$time:$value>";
}
