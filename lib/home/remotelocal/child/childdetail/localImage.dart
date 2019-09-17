import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/home/remotelocal/playDetail.dart';
import 'package:flutter_app/home/routeani/SlideRightRoute.dart';
import 'package:flutter_plugin/flutter_plugin.dart';

class LocalImagePage extends StatefulWidget {
  @override
  _LocalImagePageState createState() => _LocalImagePageState();
}

class _LocalImagePageState extends State<LocalImagePage> {
  List<dynamic> localImages = [];

  @override
  void initState() {
    super.initState();
    //获取本地文件--图片
    getImageDate();
  }

  showLoadingDialog() {
    return localImages.length == 0;
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
              _navigateToPlayDetailPage(context,index);
//              FlutterPlugin.playLocalSource(argument);
            },
            child: Column(
              children: <Widget>[
                buildImage(index),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                  child: Text(
                    localImages.length == 0 ? "" : localImages[index]["title"],
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
    if (localImages.length > 0) {
      String path = localImages[index]["resources"][0]["value"];
      List<String> list = path.split("/storage");
      String localpath = "/storage" + list[1];

      String id = localImages[index]["id"];
      String title = localImages[index]["title"];
      String replace = localpath.replaceAll(id, title);

      return Expanded(
          child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 150,
            minWidth: 150
          ),
          child: Image.file(
            new File(localImages.length == 0 ? "" : replace),
            fit: BoxFit.fitWidth,
          ),
        ),
      ));
    } else {
      return Expanded(child: Image.asset("assets/images/logo.png"));
    }
  }

  getImageDate() async {
    List<dynamic> d = await FlutterPlugin.localImages;
    setState(() {
      localImages = d;
      print("---------getImageDate-----------${localImages.length}");
    });
  }

  _navigateToPlayDetailPage(BuildContext context,int index) async {

    var argument = {
      'creator': localImages[index]["creator"],
      'title': localImages[index]["title"],
      'id': localImages[index]["id"],
      'refID': localImages[index]["refID"],
      'resources': localImages[index]["resources"][0],
    };

    Navigator.push(context, SlideRightRoute(page: PlayDetailPage(argument),));

  }
}
