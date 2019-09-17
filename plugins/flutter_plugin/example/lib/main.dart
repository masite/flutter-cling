import 'dart:async';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_plugin/flutter_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<dynamic> devices = [];
  List<dynamic> localImages = [];

  @override
  void initState() {
    super.initState();
    print("---------1-----------${localImages.length}");
    init();
  }

  void init() async {
    FlutterPlugin.init((List<dynamic> data) {
      if (!mounted) {
        return;
      }
      setState(() {
        print("--------------------");

      });
    });


  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        FlutterPlugin.search();
        List<dynamic> d = await FlutterPlugin.localImages;
        setState(() {
          localImages = d;
          print("---------onTap-----------${d.length}");
        });
      },
      child: Container(
        color: Colors.blue,
      ),
    );
  }
}
