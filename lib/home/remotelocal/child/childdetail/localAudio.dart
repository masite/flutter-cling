import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/flutter_plugin.dart';

class LocalAudioPage extends StatefulWidget {
  @override
  _LocalAudioPageState createState() => _LocalAudioPageState();
}

class _LocalAudioPageState extends State<LocalAudioPage> {
  List<dynamic> localAudios = [];

  @override
  void initState() {
    super.initState();
    //获取本地文件--图片
    getAudioDate();
  }

  showLoadingDialog() {
    return localAudios.length == 0;
  }

  getBody() {
    if (showLoadingDialog()) {
      return getProgressDialog();
    } else {
      return buildImageView();
    }
  }

  getProgressDialog() {
    return new Center(child: new CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[Expanded(child: getBody())],
      ),
    );
  }

  Widget buildImageView() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 20,
        ),
        itemCount: localAudios.length,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              buildImage(index),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                child: Text(
                  localAudios.length == 0 ? "" : localAudios[index]["title"],
                  style: TextStyle(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildImage(int index) {
    return Expanded(child: Image.asset("assets/images/logo.png"));
  }

  getAudioDate() async {
    List<dynamic> d = await FlutterPlugin.localAudios;
    setState(() {
      localAudios = d;
      print("---------getImageDate-----------${localAudios.length}");
    });
  }
}
