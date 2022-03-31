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
var _playerWidth = (_size.width / 30).floorToDouble();
var _playerHeight = (_size.height / 40).floorToDouble();


void main() {
  AppMap(_playerWidth*28 ~/ _playerHeight, _playerHeight*28 ~/ _playerHeight);
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
  final double _stepY = _playerHeight;
  final double _stepX = _playerWidth;

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
      Rect nextPos = Rect.fromLTRB(playerPoz.left, playerPoz.top - _stepY, playerPoz.right, playerPoz.bottom);
      if (!posKeys.any((element) => nextPos.overlaps(element))) {
        posY = posY - _stepY;
      }
    });
  }

  goDownward() {
    setState(() {
      gettingCoordinates();
      Rect nextPos = Rect.fromLTRB(playerPoz.left, playerPoz.top, playerPoz.right, playerPoz.bottom + _stepY);
      if (!posKeys.any((element) => nextPos.overlaps(element))) {
        posY = posY + _stepY;
      }
    });
  }

  goLeft() {
    setState(() {
      gettingCoordinates();
      Rect nextPos = Rect.fromLTRB(playerPoz.left - _stepX, playerPoz.top, playerPoz.right, playerPoz.bottom);
      if (!posKeys.any((element) => nextPos.overlaps(element))) {
        posX = posX - _stepX;
      }
    });
  }

  goRight() {
    setState(() {
      gettingCoordinates();
      Rect nextPos = Rect.fromLTRB(playerPoz.left, playerPoz.top, playerPoz.right + _stepX, playerPoz.bottom);
      if (!posKeys.any((element) => nextPos.overlaps(element))) {
        posX = posX + _stepX;
      }
    });
  }

  double posX = _playerWidth*3;
  double posY = _playerHeight*3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
              child: Container(
                  color: Colors.black12,
                  child: SizedBox(
                    width: _playerWidth*30,
                    height: _playerHeight*30,
                    child: Stack(
                      children: [
                        /// Generate top side
                        Positioned(
                          left: 0,
                          child: Row(
                            children: [
                              ///Generate upper left wall
                              generateWall(context, _playerHeight, _playerWidth*13, upperLeftWallPozKey, Colors.black),
                              ///Generate upper exit
                              generateWall(context, _playerHeight, _playerWidth*3, upperExit, Colors.black12),
                              ///Generate upper right wall
                              generateWall(context, _playerHeight, _playerWidth*13, upperRightWallPozKey, Colors.black),
                            ],
                          ),
                        ),
                        /// Generate bottom side
                        Positioned(
                            bottom: 0,
                            left: 0,
                            child: Row(
                              children: [
                                ///Generate lower left wall
                                generateWall(context, _playerHeight, _playerWidth*13, lowerLeftWallPozKey, Colors.black),
                                ///Generate lower exit
                                generateWall(context, _playerHeight, _playerWidth*3, lowerExit, Colors.black12),
                                ///Generate lower right wall
                                generateWall(context, _playerHeight, _playerWidth*13, lowerRightWallPozKey, Colors.black),
                              ],
                            )
                        ),
                        /// Generate left side
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Column(
                            children: [
                              ///Generate left upper wall
                              generateWall(context, _playerHeight*13, _playerWidth, leftUpperWallPozKey, Colors.black),
                              ///Generate left exit
                              generateWall(context, _playerHeight*3, _playerWidth, leftExit, Colors.black12),
                              ///Generate left lower wall
                              generateWall(context, _playerHeight*13, _playerWidth, leftLowerWallPozKey, Colors.black),
                            ],
                          ),
                        ),
                        /// Generate right side
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Column(
                            children: [
                              ///Generate right upper wall
                              generateWall(context, _playerHeight*13, _playerWidth, rightUpperWallPozKey, Colors.black),
                              ///Generate left exit
                              generateWall(context, _playerHeight*3, _playerWidth, rightExit, Colors.black12),
                              ///Generate right lower wall
                              generateWall(context, _playerHeight*14, _playerWidth, rightLowerWallPozKey, Colors.black),
                            ],
                          ),
                        ),
                        Positioned(
                          left: posX,
                          top: posY,
                          child: SizedBox(
                            width: _playerWidth,
                            height: _playerHeight,
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
                    ),
                  )
              )
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