import 'package:flutter/material.dart';
import 'package:flutter_app/home/remotelocal/child/localsource.dart';
import 'package:flutter_app/home/remotelocal/child/remotesource2.dart';
import 'package:flutter_plugin/flutter_plugin.dart';

class RemoteSourceChindPage extends StatefulWidget {
  @override
  _RemoteSourceChindPageState createState() => _RemoteSourceChindPageState();
}

class _RemoteSourceChindPageState extends State<RemoteSourceChindPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController; //需要定义一个Controller
  List tabs = ["网络", "本地"];

  List<dynamic> devices = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  void init() async {
    //初始化 投屏监听，
    FlutterPlugin.search();
    FlutterPlugin.init((List<dynamic> data) {
      //防止界面销毁，造成空指针问题
      if (!mounted) {
        return;
      }
      setState(() {
        devices = data;
      });
    });
    await getDevices();
  }

  Future getDevices() async {
    devices = await FlutterPlugin.devices;
    setState(() {
      print("----------- ${devices.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          //顶部
          Container(
            height: 64,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(0, 26, 0, 3),
            color: Color(int.parse("0xffFCB902")),
            child: Stack(
              children: <Widget>[
                TabBar(
                  tabs: tabs
                      .map((e) => Tab(
                            text: e,
                          ))
                      .toList(),
                  labelStyle: TextStyle(
                    color: Color(int.parse("0xff333333")),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  labelColor: Color(int.parse("0xff333333")),
                  unselectedLabelStyle: TextStyle(
                    color: Color(int.parse("0xff333333")),
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                  unselectedLabelColor: Color(int.parse("0xff333333")),
                  controller: _tabController,
                  indicatorColor: Color(int.parse("0xff000000")),
                  indicatorSize: TabBarIndicatorSize.label,
                  isScrollable: true,
                ),
                buildPositionedDevice(context)
              ],
            ),
          ),
          //中间
          Expanded(
            child: Container(
              color: Color(int.parse("0xffAFEEEE")),
              child: TabBarView(
                children: [
                  RemoteSourcePage2(),
                  LocalSourcePage(),
                ],
                controller: _tabController,
              ),
            ),
          )
        ],
      ),
    );
  }

  //构建 设备选择
  Positioned buildPositionedDevice(BuildContext context) {
    return Positioned(
      child: GestureDetector(
        onTap: () {
          print("---------------");
          getDevices();
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return _shareWidget(context);
              });
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
          constraints: BoxConstraints(minHeight: 30),
          decoration: BoxDecoration(
            color: Color(int.parse("0x4FFFFFFF")),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Row(
              children: <Widget>[
                Text("当前未链接设备"),
                Image.asset(
                  "assets/images/icon_to_cling.png",
                  width: 20,
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
      right: 20,
    );
  }

  Widget _shareWidget(BuildContext context) {
    return new Container(
      height: 400.0,
      child: Column(
        children: <Widget>[
          Expanded(
              child: Container(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: GestureDetector(
                    onTap: () {
                      print("------device---- ${devices[index]["uuid"]} --");
                      FlutterPlugin.connectDevice();
                      devices[index]["isSelected"] = true;
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              devices[index]["name"],
                              style:
                              TextStyle(color: devices[index]["isSelected"]?Colors.grey:Colors.blue),
                            ),
                          ),
                          Divider(
                            color: Color(int.parse("0xff999999")),
                            height: 1,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: devices.length,
            ),
          )),
          Divider(
            color: Color(int.parse("0xffE6E6E6")),
            height: 1,
          ),
          Container(
            height: 50,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Center(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                    child: Text(
                      '取  消',
                      style: TextStyle(fontSize: 18.0, color: Colors.blueGrey),
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
