import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gank_app/all_page.dart';
import 'package:gank_app/girl_page.dart';
import 'package:gank_app/search_page.dart';

void main() => runApp(new MyHomePage());

bool _value = true;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MaterialPageRoute.debugEnableFadingRoutes = true;
    return new MaterialApp(
      title: '干货集中营',
      theme: _value
          ? new ThemeData(
              primarySwatch: Colors.brown, primaryColor: Colors.brown
//        platform: TargetPlatform.iOS
              )
          : new ThemeData(
              primarySwatch: Colors.pink, primaryColor: Colors.pink
            ),
      initialRoute: '/',
//    home: NoNetworkView(),
      routes: {
        '/': (context) => MyHomePage(),
        '/search': (context) => SearchPage()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  TabController tabController;
  int lastTime = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 9, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    MaterialPageRoute.debugEnableFadingRoutes = true;
    return MaterialApp(
      title: '干货集中营',
      theme: _value
          ? new ThemeData(
              primarySwatch: Colors.brown,
//          brightness: Brightness.light,
          platform: TargetPlatform.android
      )
          : new ThemeData(
        primarySwatch: Colors.pink,
//          brightness: Brightness.dark,
          platform: TargetPlatform.iOS
              ),
      home: new WillPopScope(
        child: new Scaffold(
          key: _globalKey,
          appBar: new AppBar(
            title: new Text('干货集中营'),
            leading: IconButton(
              onPressed: () {
                setState(() {
                  _globalKey.currentState.openDrawer();
                });
              },
              icon: Icon(Icons.menu),
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, SearchPage.realName);
                },
                icon: Icon(Icons.search),
              )
            ],
            bottom: TabBar(
              controller: tabController,
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: <Widget>[
                Tab(text: '全部'),
                Tab(text: '福利'),
                Tab(text: 'Android'),
                Tab(text: 'iOS'),
                Tab(text: '休息视频'),
                Tab(text: '前端'),
                Tab(text: '拓展资源'),
                Tab(text: 'App'),
                Tab(text: '瞎推荐'),
              ],
            ),
          ),
          body: TabBarView(controller: tabController, children: <Widget>[
            AllPage(type: 'all'),
            GirlPage(),
            AllPage(type: 'Android'),
            AllPage(type: 'iOS'),
            AllPage(type: '休息视频'),
            AllPage(type: '前端'),
            AllPage(type: '拓展资源'),
            AllPage(type: 'App'),
            AllPage(type: '瞎推荐'),
          ]),
          drawer: Container(
            color: Colors.white,
            height: double.infinity,
            width: /*MediaQuery.of(context).size.width*/ 300.0,
            child: Column(
              children: <Widget>[
                FlutterLogo(
                  size: 200.0,
                  colors: Theme.of(context).primaryColor,
                  style: FlutterLogoStyle.horizontal,
                ),
                Switch(
                    value: _value,
                    onChanged: (value) {
                      setState(() {
                        _value = value;
                      });
                    }),
              ],
            ),
          ),
        ),
        onWillPop: () {
          int newTime = DateTime.now().millisecondsSinceEpoch;
          int result = newTime - lastTime;
          lastTime = newTime;
          if (result > 2000) {
            _globalKey.currentState
                .showSnackBar(SnackBar(content: Text('再按一次退出系统！')));
          } else {
            SystemNavigator.pop();
          }
        },
      ),
    );
  }
}
