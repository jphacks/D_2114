class DataPoint {
  late int value;
  late DateTime time;
  DataPoint(this.value, this.time);

  DataPoint.fromMap(Map map) {
    time = map['timestamp'].toDate();
    if (map['value'] is int) {
      value = map['value'];
    } else {
      value = (map['value'] as double).toInt();
    }
  }

  @override
  String toString() => "Record<$time:$value>";
}
