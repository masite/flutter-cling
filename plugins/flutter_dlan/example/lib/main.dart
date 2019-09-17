import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_dlan/flutter_dlan.dart';

void main() => runApp(MyApp());

class LifecycleEventHandler extends WidgetsBindingObserver {

  LifecycleEventHandler();

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    print('-------' + state.toString() + '-------');
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        await FlutterDlan.stop();
        break;
      case AppLifecycleState.suspending:
        break;
      case AppLifecycleState.resumed:
        await FlutterDlan.search();
        break;
    }
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<dynamic> a = [];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(LifecycleEventHandler());
    super.initState();
    FlutterDlan.init((List<dynamic> data) {
      setState(() {
        a = data;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

// Platform messages are asynchronous, so we initialize in an async method.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              MaterialButton(
                child: Text("search"),
                onPressed: () async {
                  await FlutterDlan.search();
                },
              ),
              MaterialButton(
                  child: Text("getList"),
                  onPressed: () async {
                    print(await FlutterDlan.devices);
                  }
              ),
            ]
              ..addAll(a.map<Widget>((item) {
                return ListTile(
                  title: Text(item["name"]),
                  onTap: () async {
                    await FlutterDlan.playUrl(item["uuid"],
                        "https://youku.kuyun-leshi.com/ppvod/01E2D5D49022A600A67DB3F0CE15EF92.m3u8");
                  },
                );
              })),
          ),
        ),
      ),
    );
  }
}
