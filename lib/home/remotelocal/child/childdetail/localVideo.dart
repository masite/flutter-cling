import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/flutter_plugin.dart';

class LocalVideoPage extends StatefulWidget {
  @override
  _LocalVideoPageState createState() => _LocalVideoPageState();
}

class _LocalVideoPageState extends State<LocalVideoPage> {
  List<dynamic> localVideo = [];

  @override
  void initState() {
    super.initState();
    //获取本地文件--图片
    getVideoDate();
  }

  showLoadingDialog() {
    return localVideo.length == 0;
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
        itemCount: 20,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: (){
                var argument = {
                  'creator': localVideo[index]["creator"],
                  'title': localVideo[index]["title"],
                  'id': localVideo[index]["id"],
                  'refID': localVideo[index]["refID"],
                  'resources': localVideo[index]["resources"][0],
                };


                print("---------------${argument.toString()}");
                FlutterPlugin.playLocalSource(argument);
              },
            child: Column(
              children: <Widget>[
                buildImage(index),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                  child: Text(
                    localVideo.length == 0 ? "" : localVideo[index]["title"],
                    style: TextStyle(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildImage(int index) {
    return Expanded(child: Image.asset("assets/images/logo.png"));
  }

  getVideoDate() async {
    List<dynamic> d = await FlutterPlugin.localVideos;
    setState(() {
      localVideo = d;
      print("---------getImageDate-----------${localVideo.length}");
    });
  }
}
