import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TimerApp(),
    );
  }
}

class TimerApp extends StatefulWidget {
  @override
  _TimerAppState createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> {
  TextEditingController _textFieldController = TextEditingController();
  late Timer _timer;
  int _start = 0;
  int _pausedTime = 0;
  bool _isActive = false;
  bool _isTimeUp = false;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSecond = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSecond,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            _isActive = false;
            _isTimeUp = true;
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  void stopTimer() {
    _timer.cancel();
    _pausedTime = _start;
    setState(() {
      _isActive = false;
    });
  }

  void resetTimer() {
    _timer.cancel();
    setState(() {
      _start = 0;
      _isActive = false;
      _textFieldController.clear();
      _isTimeUp = false;
    });
  }

  void restartTimer() {
    setState(() {
      _start = int.parse(_textFieldController.text) * 60;
      _isActive = true;
      _isTimeUp = false;
    });
    startTimer();
  }

  String get timerString {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    String minutesStr = (minutes < 10) ? '0$minutes' : '$minutes';
    String secondsStr = (seconds < 10) ? '0$seconds' : '$seconds';
    return '$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer App'),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Set Timer (minutes):',
                style: TextStyle(fontSize: 18.0, color: Colors.indigo),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _textFieldController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter minutes',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 200, 
                    width: 200, 
                    child: CircularProgressIndicator(
                      value: _start / (_textFieldController.text.isNotEmpty ? int.parse(_textFieldController.text) * 60 : 1),
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
                      strokeWidth: 5, 
                    ),
                  ),
                  Text(
                    timerString,
                    style: TextStyle(fontSize: 24.0),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      resetTimer();
                    },
                    child: Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      restartTimer();
                    },
                    child: Text('Restart'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_isActive) {
                        stopTimer();
                      } else {
                        restartTimer();
                      }
                    },
                    child: _isActive ? Text('Stop') : Text('Start'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _isTimeUp
                  ? Text(
                      'Time\'s Up!',
                      style: TextStyle(fontSize: 24.0, color: Colors.red),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
