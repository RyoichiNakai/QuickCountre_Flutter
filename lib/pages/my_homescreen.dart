import 'package:flutter/material.dart';
import 'package:quick_countre/spacebox/spacebox.dart' show SpaceBox;
import 'package:quick_countre/transition/transition.dart' show TransHall;
import 'package:quick_countre/pages/my_gamescreen.dart';
import 'package:quick_countre/databases/db_provider/db_provider_mode1.dart';
import 'package:quick_countre/databases/db_provider/db_provider_mode2.dart';
import 'package:quick_countre/databases/db_provider/db_provider_mode3.dart';
import 'package:quick_countre/databases/model/database_model.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomeScreen extends StatefulWidget {
  MyHomeScreen({Key key}) : super(key: key);

  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  bool _modeButtonFlag = false;
  bool _mode1 = false; //mode1:1-30
  bool _mode2 = false; //mode2:A-Z
  bool _mode3 = false; //mode3:a-z
  String _yourMode1DisplayTime = '---';
  String _yourMode2DisplayTime = '---';
  String _yourMode3DisplayTime = '---';
  int _yourMode1Time = 100000000000000;
  int _yourMode2Time = 100000000000000;
  int _yourMode3Time = 100000000000000;
  static int _id;
  static String _userName = '';
  static int _time;
  static String _format;

  DbProviderMode1 _providerMode1 = new DbProviderMode1();
  DbProviderMode2 _providerMode2 = new DbProviderMode2();
  DbProviderMode3 _providerMode3 = new DbProviderMode3();
  Random rnd = new Random();
  User u = new User(_id, _userName, _time ,_format);
  FocusNode _nameFocusNode = new FocusNode();
  final TextEditingController _nameController = new TextEditingController();
  var _exploreMode1List;
  var _exploreMode2List;
  var _exploreMode3List;


  _saveName(String name) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("myName", name);
  }

  _readName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      var data = pref.getString("myName");
      if(data != null){
      _nameController.text = data;
      _userName = data;
      }
    });
  }

  _saveUser(String mode1Format, String mode2Format, String mode3Format,
      int mode1Time, int mode2Time, int mode3Time,
      bool mode1Flag, bool mode2Flag, bool mode3Flag, bool modeButtonFlag) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("mode1Format", mode1Format);
    await pref.setString("mode2Format", mode2Format);
    await pref.setString("mode3Format", mode3Format);
    await pref.setInt("mode1Time", mode1Time);
    await pref.setInt("mode2Time", mode2Time);
    await pref.setInt("mode3Time", mode3Time);
    await pref.setBool("mode1Flag", mode1Flag);
    await pref.setBool("mode2Flag", mode2Flag);
    await pref.setBool("mode3Flag", mode3Flag);
    await pref.setBool("ModeButtonFlag", modeButtonFlag);
  }

  _readUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      var mode1Format = pref.getString("mode1Format");
      var mode2Format = pref.getString("mode2Format");
      var mode3Format = pref.getString("mode3Format");
      var mode1Time = pref.getInt("mode1Time");
      var mode2Time = pref.getInt("mode2Time");
      var mode3Time = pref.getInt("mode3Time");
      if(mode1Format != null && mode2Format != null && mode3Format != null){
        _yourMode1DisplayTime = mode1Format;
        _yourMode2DisplayTime = mode2Format;
        _yourMode3DisplayTime = mode3Format;
      }
      if(mode1Time != null && mode2Time != null && mode3Time != null){
        _yourMode1Time = mode1Time;
        _yourMode2Time = mode2Time;
        _yourMode3Time = mode3Time;
      }
      _mode1 = pref.getBool("mode1Flag") ?? false;
      _mode2 = pref.getBool("mode2Flag") ?? false;
      _mode3 = pref.getBool("mode3Flag") ?? false;
      _modeButtonFlag = pref.getBool("ModeButtonFlag") ?? false;
    });
  }

  void _updateName(String name){
    setState(() {
      _userName = name;
    });
  }

  void _updateUser(){
    setState(() {
      u = User(_id, _userName, _time, _format);
    });
  }

  void _setID(int id){
    setState(() {
      _id = id;
    });
  }

  void _updateID() {
    setState(() {
      _id = rnd.nextInt(10)
          + rnd.nextInt(10) * 10
          + rnd.nextInt(10) * 100
          + rnd.nextInt(10) * 1000
          + rnd.nextInt(10) * 10000
          + rnd.nextInt(10) * 100000;
    });
  }

  void _initMode(){
    if(!_mode1 && !_mode2 && !_mode3){
      setState(() {
        _mode1 = true;
      });
    }
  }

  void _reset(){
    setState(() {
      _mode1 = false;
      _mode2 = false;
      _mode3 = false;
      _modeButtonFlag = false;
      _yourMode1DisplayTime = '---';
      _yourMode2DisplayTime = '---';
      _yourMode3DisplayTime = '---';
    });
  }

  void _setButtons(){
    if(_exploreMode1List.length > 0 || _exploreMode2List.length > 0
        || _exploreMode3List.length > 0) {
      _setChangeName();
      _setModeButton();
      if(_exploreMode1List.length > 0) {
        _setID(_exploreMode1List[0]['id']);
        setState(() {
          _yourMode1DisplayTime = _exploreMode1List[0]['format'];
          _yourMode1Time = _exploreMode1List[0]['time'];
        });
      }
      if(_exploreMode2List.length > 0) {
        _setID(_exploreMode2List[0]['id']);
        setState(() {
          _yourMode2DisplayTime = _exploreMode2List[0]['format'];
          _yourMode2Time = _exploreMode2List[0]['time'];
        });
      }
      if(_exploreMode3List.length > 0) {
        _setID(_exploreMode3List[0]['id']);
        setState(() {
          _yourMode3DisplayTime = _exploreMode3List[0]['format'];
          _yourMode3Time = _exploreMode3List[0]['time'];
        });
      }
    }
    else if (_userName.length > 0) {
      _updateID();
      _setChangeName();
      _setModeButton();
    } else {
      _reset();
    }
  }

  void _setChangeName(){
    setState(() {
      _yourMode1DisplayTime = '---';
      _yourMode2DisplayTime = '---';
      _yourMode3DisplayTime = '---';
      _yourMode1Time = 100000000000000;
      _yourMode2Time = 100000000000000;
      _yourMode3Time = 100000000000000;
    });
  }

  void _setModeButton() {
    setState(() {
      _modeButtonFlag = true;
    });
  }

  void _setMode1(){
    setState(() {
      _mode1 = true;
      _mode2 = false;
      _mode3 = false;
    });
  }

  void _setMode2(){
    setState(() {
      _mode1 = false;
      _mode2 = true;
      _mode3 = false;
    });
  }

  void _setMode3(){
    setState(() {
      _mode1 = false;
      _mode2 = false;
      _mode3 = true;
    });
  }


  void _initDB(){
    _providerMode1.init();
    _providerMode2.init();
    _providerMode3.init();
  }

  Future<String> _contentRanking() async{
    //この行を追加したらLeaderBoardにランキングが表示されるようになった、awaitで待ったおかげ？？
    await new Future.delayed(new Duration(milliseconds: 500));
    String s = '';
    if (_mode1) {
      s = _createRanking(await _providerMode1.getScore());
    }else if (_mode2){
      s = _createRanking(await _providerMode2.getScore());
    }else if (_mode3){
      s = _createRanking(await _providerMode3.getScore());
    }
    return Future.value(s);
  }

  String _createRanking(var list) {
    int i = 0;
    String s = '';
    while(i < list.length || i > 9){
      if(i == 0){
        s += " ${i+1}.${list[i]['username']}:${list[i]['format']}";
      }else{
        s += "\n ${i+1}.${list[i]['username']}:${list[i]['format']}";
      }
      i+=1;
    }
    return s;
  }

  Future<void> _pushGameScreen(String mode, int yourTime) async {
    final result = await Navigator.push(
      context, TransHall.of(new MyGameScreen(mode: mode)).quick(),
    );
    //if文とメソッドを中に全部突っ込んだらいけたのなんで？？
    if (result != null && int.parse(result) < yourTime) {
      switch (mode) {
        case 'mode1':
          setState(() {
            _yourMode1Time = int.parse(result);
            _yourMode1DisplayTime = _formatTime(int.parse(result));
            _time = _yourMode1Time;
            _format = _yourMode1DisplayTime;
          });
          _updateUser();
          _providerMode1.insertScore(u);
          print('結果:$_yourMode1Time, $_yourMode1DisplayTime');
          break;
        case 'mode2':
          setState(() {
            _yourMode2Time = int.parse(result);
            _yourMode2DisplayTime = _formatTime(int.parse(result));
            _time = _yourMode2Time;
            _format = _yourMode2DisplayTime;
          });
          _updateUser();
          _providerMode2.insertScore(u);
          print('結果:$_yourMode2Time, $_yourMode2DisplayTime');
          break;
        case 'mode3':
          setState(() {
            _yourMode3Time = int.parse(result);
            _yourMode3DisplayTime = _formatTime(int.parse(result));
            _time = _yourMode3Time;
            _format = _yourMode3DisplayTime;
          });
          _updateUser();
          _providerMode3.insertScore(u);
          print('結果:$_yourMode3Time, $_yourMode3DisplayTime');
          break;
      }
    }
  }

  String _formatTime (int time){
    time = (time / 10).round();
    String s = '${(time / 100).floor()}.${_formatTime2(time % 100)}s';
    return s;
  }

  String _formatTime2(int timeNum) {
    return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
  }


  @override
  void initState() {
    _readName();
    _readUser();
    return super.initState();
  }


  @override
  Widget build(BuildContext context) {
    _initDB();
    _saveUser(
        _yourMode1DisplayTime,
        _yourMode2DisplayTime,
        _yourMode3DisplayTime,
        _yourMode1Time,
        _yourMode2Time,
        _yourMode3Time,
        _mode1,
        _mode2,
        _mode3,
        _modeButtonFlag
    );

    Widget _backGroundImage = Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/space.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );

    Widget _modeRecode = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
              child: _buildModeRecord('1-30', _yourMode1DisplayTime)
          ),
          Expanded(
              child: _buildModeRecord('A-Z', _yourMode2DisplayTime)
          ),
          Expanded(
            child: _buildModeRecord('a-z', _yourMode3DisplayTime),
          )
        ],
      ),
    );

    Widget _titleSection = Container(
      child: Center(
        child: Text(
          'Quick\nCountre',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'jupiter',
            height: 0.6,
            fontSize: 70,
            color: Colors.white,
          ),
        ),
      ),
    );

    Widget _nameSection = Container(
      padding: EdgeInsets.only(right:80, left:80),
      child: _buildTextForm(),
    );

    Widget _modeButtonSection = Container(
      height: 170, //ここなんか気持ち悪い
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildModeButton('1-30', _mode1),
            _buildModeButton('A-Z', _mode2),
            _buildModeButton('a-z', _mode3),
          ],
        ),
        SpaceBox.height(10),
        _buildPlayButton(),
      ]),
    );

    Widget _bottomSection = Row(
      children: <Widget>[
        SpaceBox(width: 10),
        Container(
          height: 200,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: _producer()
          ),
        ),
        SpaceBox(width: 20),
        Expanded(
          child: _buildLeaderBoard(),
        ),
        SpaceBox(width: 10)
      ],
    );

    Widget _allSection = SafeArea(
      child: SingleChildScrollView(
        //キーボード表示した時のエラーの対処
        child: Column(
          children: [
            _modeRecode,
            SpaceBox.height(20),
            _titleSection,
            SpaceBox.height(10),
            _nameSection,
            _modeButtonSection,
            SpaceBox.height(60),
            _bottomSection
          ],
        ),
      ),
    );

    return MaterialApp(
      home: Scaffold(
        //キーボード出力時にレイアウトが動かないようにする
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () async{
            _nameFocusNode.unfocus();
            _saveName(_userName);
            _exploreMode1List = await _providerMode1.getName(_userName);
            _exploreMode2List = await _providerMode2.getName(_userName);
            _exploreMode3List = await _providerMode3.getName(_userName);
            _initMode();
            _setButtons();
          },
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

  Column _buildModeRecord(String mode, String record) {
    return Column(
      //columnの中の文字を真ん中に表示する, start>左づめ, end>右づめ
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          //Containerにして上に余白入れたほうがいいかも
          mode,
          style: TextStyle(
            fontFamily: 'jupiter',
            fontSize: 26.0,
            color: Colors.yellow,
          ),
        ),
        Text(
          record,
          style: TextStyle(
              fontFamily: 'jupiter',
              fontSize: 26.0,
              color: Colors.white,
              height: 0.4
          ),
        ),
      ],
    );
  }

  TextFormField _buildTextForm() {
    return TextFormField(
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'jupiter',
        fontSize: 30,
      ),
      maxLength: 8,
      focusNode: _nameFocusNode,
      decoration: InputDecoration(
        hintText: 'Enter NickName...',
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 7.5),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      controller: _nameController,
      onChanged: (value) {
        _updateName(value);
      },
      onEditingComplete: () async{
        FocusScope.of(context).requestFocus(new FocusNode());
        _saveName(_userName);
        _exploreMode1List = await _providerMode1.getName(_userName);
        _exploreMode2List = await _providerMode2.getName(_userName);
        _exploreMode3List = await _providerMode3.getName(_userName);
        _initMode();
        _setButtons();
      },
    );
  }

  Container _buildModeButton(String name, bool mode) {
    if (_modeButtonFlag) {
      return Container(
        width: 125,
        height: 60,
        child: RaisedButton(
          padding: EdgeInsets.only(left:10, right:10),
          color: mode == true
              ? Colors.red.withOpacity(0.3)
              : Colors.red.withOpacity(0.1),
          child: Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'jupiter',
                fontSize: 40,
              ),
          ),
          shape: BeveledRectangleBorder(
            side: BorderSide(
                color: mode == true
                    ? Colors.red
                    : Colors.red.withOpacity(0.5),
                width: 1
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          onPressed: () {
            switch(name){
              case '1-30':
                _setMode1();
                break;
              case 'A-Z':
                _setMode2();
                break;
              case 'a-z':
                _setMode3();
                break;
            }
          },
        ),
      );
    } else {
      return Container();
    }
  }

  Container _buildPlayButton() {
    //引数多すぎた
    if (_modeButtonFlag) {
      return Container(
        //padding: const EdgeInsets.only(left:10, right:10),
        width: 385,
        child: RaisedButton(
          //横の空白は何？？
            color: Colors.red.withOpacity(0.3),
            child: Align(
              alignment: Alignment(0, 0),
              child: Text(
                'PLAY!',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'jupiter',
                  fontSize: 60,
                ),
              ),
            ),
            shape: BeveledRectangleBorder(
              side: BorderSide(color: Colors.red, width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: (){
              if(_mode1){
                _pushGameScreen('mode1', _yourMode1Time);
              }else if(_mode2){
                _pushGameScreen('mode2', _yourMode2Time);
              }else if(_mode3){
                _pushGameScreen('mode3', _yourMode3Time);
              }
            },
        ),
      );
    } else {
      return Container(
        width: 385,
      );
    }
  }

  Text _producer(){
    return Text(
      'FONT:\n'
          'Isurus Labs\n'
          'Grand Chaos Productions\n\n'
          'ICON:\n'
          'RyoichiNakai\n\n'
          'SPECIAL THANKS\n'
          'sinProject\n\n'
          'RyoichiNakai', //ここ変更
      style: TextStyle(
          fontFamily: 'jupiter',
          color: Colors.white,
          fontSize: 20,
          height: 0.8),
    );
  }

  Container _buildLeaderBoard(){
    return Container(
      height: 200,
      decoration: new BoxDecoration(
        border: Border.all(color: Colors.redAccent, width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child:Container(
          child:Column(
            children: <Widget>[
              Align(
                alignment: Alignment(-0.8, 0),
                child: Text(
                  'LeaderBoard',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'jupiter',
                    fontSize: 26,
                  ),
                ),
              ),
              _showTimeRanking()
            ],
          ),
          color: Colors.red.withOpacity(0.3)
      ),
      //color: Colors.red.withOpacity(0.3),
    );
  }

  Align _showTimeRanking() {
    return Align(
      alignment: Alignment.topLeft,
      child: FutureBuilder(
        future: _contentRanking(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot){
          if (snapshot.hasData) {
            return Text(
              snapshot.data,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'nano',
                  fontSize: 16,
                  height: 1.0
              ),
            );
          } else {
            return Text('');
          }
        },
      ),
    );
  }

}
