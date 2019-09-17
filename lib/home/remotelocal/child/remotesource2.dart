import 'package:flutter/material.dart';
import 'package:flutter_app/home/model/SourceBean.dart';

class RemoteSourcePage2 extends StatefulWidget {
  @override
  _RemoteSourcePage2State createState() => _RemoteSourcePage2State();
}

class _RemoteSourcePage2State extends State<RemoteSourcePage2> {
  List<SourceBean> _list = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SourceBean sourceBean = SourceBean();
    sourceBean.imgSource = "assets/images/icon_cling_history.png";
    sourceBean.title = "投屏历史";

    SourceBean sourceBean2 = SourceBean();
    sourceBean2.imgSource = "assets/images/icon_main_add_url.png";
    sourceBean2.title = "添加常用网址";
    _list.add(sourceBean);
    _list.add(sourceBean2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(int.parse("0xffffffff")),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: Stack(
                    children: <Widget>[
                      Image.asset(
                        "assets/images/main_header.png",
                        width: MediaQuery.of(context).size.width,
                      ),
                      Positioned(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        
                        child: GestureDetector(
                          onTap: (){
                            print("----------------------------");
                          },
                          child: Container(
                            color: Color(int.parse("0x000000")),
                          ),
                        ),
                        bottom: 0,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            sliver: SliverGrid.count(
              mainAxisSpacing: 30,
              crossAxisSpacing: 34,
              crossAxisCount: 4,
              childAspectRatio: 0.7,
              children: _list.map((product) {
                return _buildItemGrid(product);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverPersistentHeader(
      pinned: false,
      floating: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 280.0,
        maxHeight: 280.0,
        child: Image.asset(
          "assets/images/main_header.png",
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }

  Widget _buildItemGrid(SourceBean product) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(product.imgSource),
          Text(
            product.title,
            style: TextStyle(),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class HeaderWidget extends StatelessWidget {
  final String text;

  HeaderWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
      child: Image.asset(
        "assets/images/main_header.png",
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}