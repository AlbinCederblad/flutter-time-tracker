import 'dart:async';

import 'package:flutter/material.dart';
import 'package:time_tracker_app/models/entry.dart';
import 'package:time_tracker_app/database/database_helper.dart';

class TimerService extends ChangeNotifier {
  Stopwatch _watch;
  Timer _timer;
  var db = DatabaseHelper();

  Duration get currentDuration => _currentDuration;
  Duration _currentDuration = Duration.zero;

  DateTime _startDateTime;
  DateTime _endDateTime;

  Entry _logEntry;

  bool get isRunning => _timer != null;

  TimerService() {
    _watch = Stopwatch();
  }

  void _onTick(Timer timer) {
    _currentDuration = _watch.elapsed;

    // notify all listening widgets
    notifyListeners();
  }

  void start() {
    if (_timer != null) return;

    _timer = Timer.periodic(Duration(seconds: 1), _onTick);
    _watch.start();
    _startDateTime = DateTime.now();

    notifyListeners();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _watch.stop();
    _currentDuration = _watch.elapsed;

    notifyListeners();
  }

  void reset() async {
    stop();
    _watch.reset();

    _endDateTime = DateTime.now();
    _logEntry = new Entry(
        getDayMonthYear(_endDateTime),
        _startDateTime.millisecondsSinceEpoch,
        _endDateTime.millisecondsSinceEpoch,
        _currentDuration.inMinutes);
    await db.saveEntry(_logEntry);

    _currentDuration = Duration.zero;

    notifyListeners();
  }

  String getDayMonthYear(DateTime date) {
    return date.day.toString() + date.month.toString() + date.year.toString();
  }

  static TimerService of(BuildContext context) {
    var provider = context.inheritFromWidgetOfExactType(TimerServiceProvider)
        as TimerServiceProvider;
    return provider.service;
  }
}

class TimerServiceProvider extends InheritedWidget {
  const TimerServiceProvider({Key key, this.service, Widget child})
      : super(key: key, child: child);

  final TimerService service;

  @override
  bool updateShouldNotify(TimerServiceProvider old) => service != old.service;
}
