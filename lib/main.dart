import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

void main() {
  //Speed of animation has been slowed for demoing purposes
  timeDilation = 3.0;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transitions Tutorial',
      theme: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(builders: {
        TargetPlatform.iOS: ZoomSlideUpTransitionsBuilder(),
        TargetPlatform.android: RotationFadeTransitionBuilder(),

        //Example of using default animations
        //TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        //TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      })),
      home: MyHomePage(title: 'Transitions Tutorial'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  final rnd = Random();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String randomIntString;

  @override
  void initState() {
    randomIntString = widget.rnd.nextInt(10000).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(widget.title + " " + randomIntString),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF282a57), Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // ignore: deprecated_member_use
                  RaisedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              MyHomePage(title: "New Page"),
                        )),
                    child: Text("New Page"),
                  ),
                  Text(
                    "Random Number: " + randomIntString,
                    style: TextStyle(color: Colors.white),
                  )
                ])));
  }
}

class RotationFadeTransitionBuilder extends PageTransitionsBuilder {
  const RotationFadeTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return _RotationFadeTransitionBuilder(
        routeAnimation: animation, child: child);
  }
}

class _RotationFadeTransitionBuilder extends StatelessWidget {
  _RotationFadeTransitionBuilder({
    Key key,
    @required Animation<double> routeAnimation,
    @required this.child,
  })  : _turnsAnimation = routeAnimation.drive(_linearToEaseOut),
        _opacityAnimation = routeAnimation.drive(_easeInTween),
        super(key: key);

  static final Animatable<double> _linearToEaseOut =
      CurveTween(curve: Curves.linearToEaseOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);

  final Animation<double> _turnsAnimation;
  final Animation<double> _opacityAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _turnsAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: child,
      ),
    );
  }
}

class ZoomSlideUpTransitionsBuilder extends PageTransitionsBuilder {
  const ZoomSlideUpTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return _ZoomSlideUpTransitionsBuilder(
        routeAnimation: animation, child: child);
  }
}

class _ZoomSlideUpTransitionsBuilder extends StatelessWidget {
  _ZoomSlideUpTransitionsBuilder({
    Key key,
    @required Animation<double> routeAnimation,
    @required this.child,
  })  : _scaleAnimation = CurvedAnimation(
          parent: routeAnimation,
          curve: Curves.linear,
        ).drive(_scaleTween),
        _slideAnimation = CurvedAnimation(
          parent: routeAnimation,
          curve: Curves.linear,
        ).drive(_kBottomUpTween),
        super(key: key);

  final Animation<Offset> _slideAnimation;
  final Animation<double> _scaleAnimation;

  static final Animatable<double> _scaleTween =
      Tween<double>(begin: 0.0, end: 1);
  static final Animatable<Offset> _kBottomUpTween = Tween<Offset>(
    begin: const Offset(0.0, 1.0),
    end: const Offset(0.0, 0.0),
  );

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: child,
      ),
    );
  }
}
