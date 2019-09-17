import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/home/home.dart';
import 'package:flutter_app/home/remotelocal/playDetail.dart';
import 'package:flutter_plugin/flutter_plugin.dart';
import 'package:simple_permissions/simple_permissions.dart';

void main() {
  runApp(MyApp());
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '手机投屏神器',
      routes: {
        '/home': (context) => HomePage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class SplashPage extends StatefulWidget {
  SplashPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String _platformVersion = 'Unknown';
  Permission permission = Permission.ReadExternalStorage;

  List<dynamic> devices = [];

  @override
  void initState() {
    super.initState();
    init();

    checkPermission();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void init() async {
    //初始化 投屏监听，
    FlutterPlugin.search();
    FlutterPlugin.init((List<dynamic> data) {
      if (!mounted) {
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: Scaffold(
        body: Center(
          child: buildImage(),
        ),
      ),
    );
  }

  Image buildImage() {
    return Image.asset(
      "assets/images/logo.png",
      fit: BoxFit.contain,
      width: 80,
      height: 80,
    );
  }

  Widget buildCom() {
    return new Column(children: <Widget>[
      new Text('Running on: $_platformVersion\n'),
      new DropdownButton(
          items: _getDropDownItems(),
          value: permission,
          onChanged: onDropDownChanged),
      new RaisedButton(
          onPressed: checkPermission, child: new Text("Check permission")),
      new RaisedButton(
          onPressed: requestPermission, child: new Text("Request permission")),
      new RaisedButton(
          onPressed: getPermissionStatus,
          child: new Text("Get permission status")),
      new RaisedButton(
          onPressed: SimplePermissions.openSettings,
          child: new Text("Open settings"))
    ]);
  }

  _navigateToSecondPage(BuildContext context) async {
    await Navigator.pushNamed(context, '/home', arguments: 'Android进阶之光'); //1
  }

  onDropDownChanged(Permission permission) {
    setState(() => this.permission = permission);
    print(permission);
  }

  requestPermission() async {
    final res = await SimplePermissions.requestPermission(permission);
    if (res.toString() == PermissionStatus.authorized.toString()) {
      print("--------requestPermission ture-----------");
      _navigateToSecondPage(context);
    }
    print("permission request result is " + res.toString());
  }

  checkPermission() async {
    bool res = await SimplePermissions.checkPermission(permission);
    if (!res) {
      requestPermission();
    } else {
      new Timer(const Duration(milliseconds: 1500), () {
        _navigateToSecondPage(context);
      });
    }
    print("permission is " + res.toString());
  }

  getPermissionStatus() async {
    final res = await SimplePermissions.getPermissionStatus(permission);
    print("permission status is " + res.toString());
  }

  List<DropdownMenuItem<Permission>> _getDropDownItems() {
    List<DropdownMenuItem<Permission>> items = new List();
    Permission.values.forEach((permission) {
      var item = new DropdownMenuItem(
          child: new Text(getPermissionString(permission)), value: permission);
      items.add(item);
    });
    return items;
  }
}
