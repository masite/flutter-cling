import 'package:flutter/material.dart';
import 'package:flutter_app/home/customviews/GradientButton.dart';
import 'package:flutter_app/home/customviews/TurnBox.dart';
import 'package:flutter_app/home/customviews/file/FileOperationRoute.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
      child: buildPage(),
    );
  }
  double _turns = .0;
  Widget buildPage() {

    //
//    return GradientButton(
//      colors: [Colors.orange, Colors.red],
//      height: 50.0,
//      child: Text("Submit"),
//      onPressed: (){
//        print("GradientButton");
//      },
//    );


//    return Column(
//      children: <Widget>[
//        TurnBox(
//          turns: _turns,
//          speed: 500,
//          child: Icon(Icons.refresh, size: 50,),
//        ),
//        TurnBox(
//          turns: _turns,
//          speed: 1000,
//          child: Icon(Icons.refresh, size: 150.0,),
//        ),
//        RaisedButton(
//          child: Text("顺时针旋转1/5圈"),
//          onPressed: () {
//            setState(() {
//              _turns += .2;
//            });
//          },
//        ),
//        RaisedButton(
//          child: Text("逆时针旋转1/5圈"),
//          onPressed: () {
//            setState(() {
//              _turns -= .2;
//            });
//          },
//        )
//      ],
//    );

    return FileOperationRoute();
  }

}
