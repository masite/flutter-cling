import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/home/remotelocal/playDetail.dart';
import 'package:flutter_app/home/routeani/SlideRightRoute.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_plugin/flutter_plugin.dart';

class LocalImagePage extends StatefulWidget {
  @override
  _LocalImagePageState createState() => _LocalImagePageState();
}

class _LocalImagePageState extends State<LocalImagePage> {
  List<dynamic> localImages = [];
  List<dynamic> localImagesShow = [];

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("----------- 滑动到底部");
        updateImages();
      }
    });
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
        controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 20,
        ),
        itemCount: localImages.length,
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
  }

  getImageDate() async {
    List<dynamic> d = await FlutterPlugin.localImages;
    localImagesShow = d;
    updateImages();
  }

  void updateImages() async {
    int end = localImagesShow.length - localImages.length;
    if (end == 0) {
      return;
    }
    List<dynamic> list = localImagesShow.sublist(localImages.length,
        end < 10 ? localImages.length + end : localImages.length + 10);

    localImages.addAll(list);
    print(
        "---------list-----------${localImagesShow.length}-----${localImages.length}---${list.length}");
    setState(() {});
  }

  _navigateToPlayDetailPage(BuildContext context, int index) async {
    var argument = {
      'creator': localImages[index]["creator"],
      'title': localImages[index]["title"],
      'id': localImages[index]["id"],
      'refID': localImages[index]["refID"],
      'resources': localImages[index]["resources"][0],
    };

    Navigator.push(
        context,
        SlideRightRoute(
          page: PlayDetailPage(argument),
        ));
  }

  // 1. compress file and get a List<int>
  Future<List<int>> testCompressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 2300,
      minHeight: 1500,
      quality: 94,
      rotate: 90,
    );
    print(file.lengthSync());
    print(result.length);
    return result;
  }

  // 2. compress file and get file.
  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 88,
      rotate: 180,
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }

// 2. compress file and get file.
  Future<File> testCompressAndGetFile2(
      String oldPath, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      oldPath,
      targetPath,
      quality: 88,
      rotate: 0,
    );
    return result;
  }
}
