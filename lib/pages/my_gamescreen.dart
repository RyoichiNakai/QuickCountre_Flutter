import 'package:flutter/material.dart';
import 'package:quick_countre/spacebox/spacebox.dart' show SpaceBox;
import 'dart:async';
import 'package:quick_countre/soundplayer/sound_player.dart';


class MyGameScreen extends StatefulWidget {
  MyGameScreen({Key key, this.mode}) : super(key: key);
  final String mode; //遷移先のモードの設定

  @override
  _MyGameScreenState createState() => new _MyGameScreenState();
}

class _MyGameScreenState extends State<MyGameScreen> {
  int _time;
  int _maxLength;
  int _index;
  bool _gamePlayReadyFlag = true;
  bool _gameOverFlag = false;
  bool _gameEndFlag = false;
  List<String> _instructorList;
  List<String> _shuffledList;
  int _sec;
  int _milliSec;
  String _stopTimeToDisplay = '00:00';
  Stopwatch swatch = new Stopwatch();
  final dur = const Duration(milliseconds: 1);
  final SoundManager soundManager = SoundManager();

  //mode1
  List<String> _mode1List = List.generate(30, (i) => (i + 1).toString());

  //mode2
  List<String> _mode2List = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
    'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
    'U', 'V', 'W', 'X', 'Y', 'Z', ' ', ' ', ' ', ' ',
  ];

  //mode3
  List<String> _mode3List = [
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
    'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
    'u', 'v', 'w', 'x', 'y', 'z', ' ', ' ', ' ', ' ',
  ];

  void _selectMode() {
    switch (widget.mode) {
      case 'mode1':
        _setMaxLength(30);
        _setInstructorList(_mode1List);
        _setShuffledList(_mode1List);
        break;
      case 'mode2':
        _setMaxLength(26);
        _setInstructorList(_mode2List);
        _setShuffledList(_mode2List);
        break;
      case 'mode3':
        _setMaxLength(26);
        _setInstructorList(_mode3List);
        _setShuffledList(_mode3List);
        break;
    }
  }

  void _setInstructorList(List items) {
    _instructorList = List.generate(_maxLength, (i) => items[i]);
  }

  void _setShuffledList(List items) {
    _shuffledList = List.generate(30, (i) => items[i]);
    _shuffledList.shuffle();
  }

  void _setMaxLength(int length) {
    setState(() {
      _maxLength = length;
    });
  }

  void _updateIndex(){
    setState(() {
      _index++;
    });
  }

  void _popHomeScreen(int timer) {
    if (_gameEndFlag) {
      Navigator.of(context).pop(timer.toString());
    } else {
      Navigator.of(context).pop();
    }
  }

  void _startTimer() {
    Timer(dur, _keepRunning);
  }

  void _keepRunning() {
    if (swatch.isRunning) {
      _startTimer();
    }
    setState(() {
      _sec = swatch.elapsed.inSeconds;
      _milliSec = swatch.elapsed.inMilliseconds;
      _stopTimeToDisplay =
          _sec.toString().padLeft(2, '0') + '.' +
          ((_milliSec % 1000) / 10).floor().toString().padLeft(2, '0');
    });
  }

  void _startStopWatch() {
    setState(() {
      _stopTimeToDisplay = '00:00';
      _gamePlayReadyFlag = false;
    });
    swatch.start();
    _startTimer();
  }

  void _stopStopWatch() {
    swatch.stop();
  }

  @override
  Widget build(BuildContext context) {
    if (_gamePlayReadyFlag) {
      _index = 0;
      _startStopWatch();
      _selectMode();
    }

    Widget _backGroundImage = Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/space.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );

    Widget _topSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(child: _buildTimer()),
          _buildQuitButton()
        ],
      ),
    );

    Widget _mediumSection = Container(
        height: 100,
        padding: EdgeInsets.only(top: 10, bottom: 20),
        child: _buildText()
    );

    Widget _bottomSection = Container(
        height: 475,
        child: _buildCounterButtonList()
    );

    Widget _allSection = SafeArea(
      child: Column(
        children: <Widget>[
          SpaceBox.height(20),
          _topSection,
          _mediumSection,
          _bottomSection
        ],
      ),
    );

    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Stack(
            children: <Widget>[
              _backGroundImage,
              _allSection
            ],
          ),
        ),
      ),
    );
  }

  Text _buildTimer() {
    return Text(
      '$_stopTimeToDisplay',
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.white,
          fontFamily: 'jupiter',
          fontSize: 80,
          height: 0.6
      ),
    );
  }

  Container _buildQuitButton() {
    return Container(
      width: 175,
      height: 60,
      child: RaisedButton(
        //横の空白は何？？
        child: Text(
            'QUIT',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'jupiter',
              fontSize: 50,
            )
        ),
        color: Colors.red.withOpacity(0.1),
        shape: BeveledRectangleBorder(
          side: BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: () {
          _popHomeScreen(_time);
          _stopStopWatch();
        },
      ),
    );
  }

  Text _buildText(){
    if(_gameOverFlag){
      return _createText('Game Over!', 90);
    }else if(_gameEndFlag){
      return _createText('Congratulations!', 70);
    }else{
      return _createText('${_instructorList[_index]}', 90);
    }
  }

  Text _createText(String str, double size){
    return Text(
      str,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.white,
          fontFamily: 'jupiter',
          fontSize: size,
          height: 0.8
      ),
    );
  }

  Column _buildCounterButtonList() {
    return Column(
      children: <Widget>[
        _buildCounterButtonRow(0),
        SpaceBox.height(10),
        _buildCounterButtonRow(5),
        SpaceBox.height(10),
        _buildCounterButtonRow(10),
        SpaceBox.height(10),
        _buildCounterButtonRow(15),
        SpaceBox.height(10),
        _buildCounterButtonRow(20),
        SpaceBox.height(10),
        _buildCounterButtonRow(25),
      ],
    );
  }

  Row _buildCounterButtonRow(int i) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildCounterButton(i),
          _buildCounterButton(i + 1),
          _buildCounterButton(i + 2),
          _buildCounterButton(i + 3),
          _buildCounterButton(i + 4),
        ]
    );
  }

  Container _buildCounterButton(int i) {
    return Container(
      height: 70,
      width: 70,
      child: RaisedButton(
          padding: EdgeInsets.all(5),
          child: Text(
            '${_shuffledList[i]}',
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'jupiter',
              fontSize: 50,
            ),
          ),
          color: _gameOverFlag ?
                Colors.red[900].withOpacity(0) : Colors.red.withOpacity(0.1),
          shape: BeveledRectangleBorder(
            side: BorderSide(
                color: _gameOverFlag ?
                Colors.red[900].withOpacity(0.4) : Colors.red,
                width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          highlightElevation: 30.0,
          highlightColor: _gameOverFlag ?
            null : Colors.red.withOpacity(0.8),
          onHighlightChanged: (value) {},
          onPressed: _gameOverFlag ? null : () {
              if((_index + 2) > _maxLength){
                setState(() {
                  _gameEndFlag = true;
                  _time = _milliSec;
                  print('終わった時間:$_sec,$_milliSec, $_time');
                });
                _stopStopWatch();
              }
              if(_instructorList[_index] == _shuffledList[i]){
                _updateIndex();
              }else{
                setState(() {
                  _gameOverFlag = true;
                });
                _stopStopWatch();
                print(_time);
              }
          }
      ),
    );
  }
}
