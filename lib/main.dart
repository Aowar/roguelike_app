import 'package:roguelike_app/libs.dart';
import 'dart:ui';

var playerPozKey = RectGetter.createGlobalKey();
var upperLeftWallPozKey = RectGetter.createGlobalKey();
var upperRightWallPozKey = RectGetter.createGlobalKey();
var lowerLeftWallPozKey = RectGetter.createGlobalKey();
var lowerRightWallPozKey = RectGetter.createGlobalKey();
var rightUpperWallPozKey = RectGetter.createGlobalKey();
var rightLowerWallPozKey = RectGetter.createGlobalKey();
var leftUpperWallPozKey = RectGetter.createGlobalKey();
var leftLowerWallPozKey = RectGetter.createGlobalKey();
var upperExit = RectGetter.createGlobalKey();
var lowerExit = RectGetter.createGlobalKey();
var rightExit = RectGetter.createGlobalKey();
var leftExit = RectGetter.createGlobalKey();

final List<dynamic> posKeys = [];
var _size = window.physicalSize;
var _playerSize = (_size.width / 22).floorToDouble();

void main() {
  // AppMap((_size.height - _playerSize*2) ~/ _playerSize, (_size.height - _playerSize*2) ~/ _playerSize);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late Rect playerPoz;
  final double _step = _playerSize;

  gettingCoordinates() {
    playerPoz = RectGetter.getRectFromKey(playerPozKey)!;
    posKeys.clear();
    posKeys.add(RectGetter.getRectFromKey(upperLeftWallPozKey)!);
    posKeys.add(RectGetter.getRectFromKey(upperRightWallPozKey)!);
    posKeys.add(RectGetter.getRectFromKey(lowerLeftWallPozKey)!);
    posKeys.add(RectGetter.getRectFromKey(lowerRightWallPozKey)!);
    posKeys.add(RectGetter.getRectFromKey(leftUpperWallPozKey)!);
    posKeys.add(RectGetter.getRectFromKey(leftLowerWallPozKey)!);
    posKeys.add(RectGetter.getRectFromKey(rightUpperWallPozKey)!);
    posKeys.add(RectGetter.getRectFromKey(rightLowerWallPozKey)!);
  }

  generateWall(BuildContext context, double height, double width, var key, Color color) {
    return SizedBox(
        width: width,
        height: height,
        child: RectGetter(
          key: key,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: color
            ),
          ),
        )
    );
  }

  goUpward() {
    setState(() {
      gettingCoordinates();
      Rect nextPos = Rect.fromLTRB(playerPoz.left, playerPoz.top - _step, playerPoz.right, playerPoz.bottom);
      if (!posKeys.any((element) => nextPos.overlaps(element))) {
        posY = posY - _step;
      }
    });
  }

  goDownward() {
    setState(() {
      gettingCoordinates();
      Rect nextPos = Rect.fromLTRB(playerPoz.left, playerPoz.top, playerPoz.right, playerPoz.bottom + _step);
      if (!posKeys.any((element) => nextPos.overlaps(element))) {
        posY = posY + _step;
      }
    });
  }

  goLeft() {
    setState(() {
      gettingCoordinates();
      Rect nextPos = Rect.fromLTRB(playerPoz.left - _step, playerPoz.top, playerPoz.right, playerPoz.bottom);
      if (!posKeys.any((element) => nextPos.overlaps(element))) {
        posX = posX - _step;
      }
    });
  }

  goRight() {
    setState(() {
      gettingCoordinates();
      Rect nextPos = Rect.fromLTRB(playerPoz.left, playerPoz.top, playerPoz.right + _step, playerPoz.bottom);
      if (!posKeys.any((element) => nextPos.overlaps(element))) {
        posX = posX + _step;
      }
    });
  }

  double posX = _playerSize*3;
  double posY = _playerSize*3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
              Center(
                child: Container(
                    color: Colors.black12,
                    child: SizedBox(
                        width: _playerSize*20,
                        height: _playerSize*20,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              child: Row(
                                children: [
                                  //Generate upper left wall
                                  generateWall(context, _playerSize, _playerSize*9, upperLeftWallPozKey, Colors.black),
                                  //Generate upper left wall
                                  generateWall(context, _playerSize, _playerSize*3, upperExit, Colors.black12),
                                  //Generate upper right wall
                                  generateWall(context, _playerSize, _playerSize*9, upperRightWallPozKey, Colors.black),
                                ],
                              ),
                            ),
                            //Generate lower left wall
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: generateWall(context, _playerSize, _playerSize*6, lowerLeftWallPozKey, Colors.black),
                            ),
                            //Generate lower right wall
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: generateWall(context, _playerSize, _playerSize*6, lowerRightWallPozKey, Colors.black),
                            ),
                            //Generate left upper wall
                            Positioned(
                              top: 0,
                              left: 0,
                              child: generateWall(context, _playerSize*12, _playerSize, leftUpperWallPozKey, Colors.black),
                            ),
                            //Generate left lower wall
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: generateWall(context, _playerSize*12, _playerSize, leftLowerWallPozKey, Colors.black),
                            ),
                            //Generate right upper wall
                            Positioned(
                              top: 0,
                              right: 0,
                              child: generateWall(context, _playerSize*12, _playerSize, rightUpperWallPozKey, Colors.black),
                            ),
                            //Generate right lower wall
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: generateWall(context, _playerSize*12, _playerSize, rightLowerWallPozKey, Colors.black),
                            ),
                            Positioned(
                              left: posX,
                              top: posY,
                              child: SizedBox(
                                width: _playerSize,
                                height: _playerSize,
                                child: RectGetter(
                                    key: playerPozKey,
                                    child: GestureDetector(
                                      onTap: () {
                                        RectGetter.getRectFromKey(playerPozKey);
                                        RectGetter.getRectFromKey(upperLeftWallPozKey);
                                      },
                                      child: Container(
                                        color: Colors.green,
                                      ),
                                    )
                                ),
                              ),
                            ),
                          ],
                        )
                    )
                ),
              ),
          Center(
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        child: Stack(
                          children: [
                            Container(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: IconButton(
                                                icon: Icon(Icons.arrow_upward_rounded),
                                                onPressed: goUpward,
                                              ),
                                            ),
                                            Center(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: IconButton(
                                                      icon: Icon(Icons.keyboard_arrow_left_rounded),
                                                      onPressed: goLeft,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: IconButton(
                                                      icon: Icon(Icons.keyboard_arrow_right_rounded),
                                                      onPressed: goRight,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: IconButton(
                                                icon: Icon(Icons.arrow_downward_rounded),
                                                onPressed: goDownward,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            )
                          ],
                        ),
                      ),
                    )
                ),
              )
          )
        ],
      ),
    );
  }
}