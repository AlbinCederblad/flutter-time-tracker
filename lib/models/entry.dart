class Entry {
  String _dayMonthYear;
  int _startDateTime;
  int _endDateTime;
  int _durationInMinutes;

  Entry(this._dayMonthYear, this._startDateTime, this._endDateTime,
      this._durationInMinutes);

  String get dayMonthYear => _dayMonthYear;
  int get startDateTime => _startDateTime;
  int get endDateTime => _endDateTime;
  int get durationInMinutes => _durationInMinutes;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["dayMonthYear"] = _dayMonthYear;
    map["startDateTime"] = _startDateTime;
    map["endDateTime"] = _endDateTime;
    map["durationInMinutes"] = _durationInMinutes;

    return map;
  }

  Entry.fromMap(Map<String, dynamic> map) {
    this._dayMonthYear = map['dayMonthYear'];
    this._startDateTime = map['startDateTime'];
    this._endDateTime = map['endDateTime'];
    this._durationInMinutes = map['durationInMinutes'];
  }

  String hourMinutes() {
    int hoursNum = (_durationInMinutes ~/ 60);
    int minutesNum = (_durationInMinutes % 60);
    String hours = hoursNum.toString();
    String minutes = minutesNum.toString();
    if (hoursNum < 10) hours = "0" + hoursNum.toString();
    if (minutesNum < 10) minutes = "0" + minutesNum.toString();
    return hours + ":" + minutes;
  }

  String getDay() {
    List<String> weekdays = [
      "",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    var date = weekdays[
        DateTime.fromMillisecondsSinceEpoch(_endDateTime, isUtc: true).weekday];
    return date;
  }

  int getMonth() {
    return DateTime.fromMillisecondsSinceEpoch(_endDateTime).month;
  }

  String getDate() {
    DateTime dt =
        DateTime.fromMillisecondsSinceEpoch(_endDateTime, isUtc: true);

    return dt.day.toString() +
        "/" +
        dt.month.toString() +
        " - " +
        dt.year.toString();
  }
}
