import 'package:flutter/material.dart';

class PlayDetailPage extends StatefulWidget {
  var argument;

  PlayDetailPage(this.argument);

  @override
  _PlayDetailPageState createState() => _PlayDetailPageState();
}

class _PlayDetailPageState extends State<PlayDetailPage> {
  var argument;

  @override
  void initState() {
    super.initState();
    argument = widget.argument;
  }

  @override
  Widget build(BuildContext context) {
    print("------>> $argument");

    return Scaffold(
      appBar: AppBar(
        title: Text("播放详情"),
      ),
      body: Center(
        child: ClipOval(
          child: SizedBox(
            width: 200.0,
            height: 200.0,
            child: Container(
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print("-----top");
                    },
                    child: ClipPath(
                      child: Align(
                        alignment: Alignment(-1, -1),
                        child: Container(
                          width: 200,
                          height: 100,
                          color: Colors.red,
                          child: Align(
                            alignment: Alignment(0, -0.65),
                            child: Image.asset(
                              "assets/images/yinliangda.png",
                              height: 20,
                            ),
                          ),
                        ),
                      ),
                      clipper: TopPath(),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("-----right");
                    },
                    child: ClipPath(
                      child: Align(
                        alignment: Alignment(1, -1),
                        child: Container(
                          width: 100,
                          height: 200,
                          color: Colors.orange,
                          child: Align(
                            alignment: Alignment(0.65, 0),
                            child: Image.asset(
                              "assets/images/xiayiqu.png",
                              width: 20,
                            ),
                          ),
                        ),
                      ),
                      clipper: RightPath(),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("----left");
                    },
                    child: ClipPath(
                      child: Align(
                        alignment: Alignment(-1, 1),
                        child: Container(
                          width: 100,
                          height: 200,
                          color: Colors.yellow,
                          child: Align(
                            alignment: Alignment(-0.65, 0),
                            child: Image.asset(
                              "assets/images/shangyiqu.png",
                              width: 20,
                            ),
                          ),
                        ),
                      ),
                      clipper: LeftPath(),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("------bottom点击了");
                    },
                    child: ClipPath(
                      child: Align(
                        alignment: Alignment(1, 1),
                        child: Container(
                          width: 200,
                          height: 100,
                          color: Colors.green,
                          child: Align(
                            alignment: Alignment(0, 0.65),
                            child: Image.asset(
                              "assets/images/yinliangxiao.png",
                              height: 20,
                            ),
                          ),
                        ),
                      ),
                      clipper: BottomPath(),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("---- 中间区域");
                    },
                    child: Center(
                      child: ClipOval(
                        child: SizedBox(
                          width: 110,
                          height: 110,
                          child: Align(
                            alignment: Alignment(0, 0),
                            child: Container(
                              color: Colors.white,
                              width: 110,
                              height: 110,
                              child: Image.asset("assets/images/playing.png"),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    print(" ---  ${size.width} --- ${size.height}");
    var path = Path()
      ..moveTo(200.0, 0.0)
      ..lineTo(100.0, 100.0)
      ..lineTo(200.0, 200.0)
      ..lineTo(0.0, 200.0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TopPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    print(" ---  ${size.width} --- ${size.height}");
    var path = Path()
      ..moveTo(0.0, 0.0)
      ..lineTo(100.0, 100.0)
      ..lineTo(200.0, 0.0)
      ..lineTo(0.0, 0.0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class LeftPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    print(" ---  ${size.width} --- ${size.height}");
    var path = Path()
      ..moveTo(200.0, 0.0)
      ..lineTo(100.0, 100.0)
      ..lineTo(0.0, 0.0)
      ..lineTo(0.0, 200.0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class RightPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    print(" ---  ${size.width} --- ${size.height}");
    var path = Path()
      ..moveTo(200.0, 0.0)
      ..lineTo(100.0, 100.0)
      ..lineTo(200.0, 200.0)
      ..lineTo(200.0, 0.0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
