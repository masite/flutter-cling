import 'package:flutter/material.dart';
import 'package:flutter_app/home/remotelocal/child/childdetail/localAudio.dart';
import 'package:flutter_app/home/remotelocal/child/childdetail/localImage.dart';
import 'package:flutter_app/home/remotelocal/child/childdetail/localVideo.dart';
import 'package:flutter_plugin/flutter_plugin.dart';

class LocalSourcePage extends StatefulWidget {
  @override
  _LocalSourcePageState createState() => _LocalSourcePageState();
}

class _LocalSourcePageState extends State<LocalSourcePage> {
  int position = 30;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    resetPosition(30);
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                    child: Text(
                      "图片",
                      style: TextStyle(
                          fontWeight: position == 30
                              ? FontWeight.bold
                              : FontWeight.normal),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    resetPosition(20);
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                    child: Text(
                      "视频",
                      style: TextStyle(
                          fontWeight: position == 20
                              ? FontWeight.bold
                              : FontWeight.normal),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    resetPosition(10);
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                    child: Text(
                      "音频",
                      style: TextStyle(
                          fontWeight: position == 10
                              ? FontWeight.bold
                              : FontWeight.normal),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: buildView())
      ],
    );
  }

  void resetPosition(int pos) {
    position = pos;
    print("-------------position $position ");
    FlutterPlugin.stopPlay();
    setState(() {});
  }

  Widget buildView() {
    if (position == 30) {
      return LocalImagePage();
    } else if (position == 20) {
      return LocalVideoPage();
    } else {
      return LocalAudioPage();
    }
  }
}
