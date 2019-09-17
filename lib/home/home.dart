import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/home/setting/setting.dart';
import 'package:flutter_app/home/remotelocal/remotesource.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  List tabs = ["网络", "本地"];




  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: buildBody(context),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(
                icon: Icon(Icons.business), title: Text('Business')),
          ],
          currentIndex: _selectedIndex,
          fixedColor: Colors.blue,
          onTap: _onItemTapped,
        ));
  }

  //配置body页面
 Widget buildBody(BuildContext context) {
    if(_selectedIndex == 0){
      return RemoteSourceChindPage();
    }else{
      return SettingPage();
    }
  }

  void _onItemTapped(int index) {
    print("----------$index");
    setState(() {
      _selectedIndex = index;
    });
  }




}
