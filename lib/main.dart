import 'package:roguelike_app/bobject.dart';
import 'package:roguelike_app/libs.dart';
import 'dart:developer' as dev;
import 'dart:ui' as ui;

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
bool flag = false;
dynamic enemyKey;
List<dynamic> enemyKeys = [];
List<dynamic> enemyPos = [];

final List<dynamic> posKeys = [];
var _playerWidth;
var _playerHeight;
double _fullFieldWidth = _playerWidth*18;
double _fullFieldHeight = _playerHeight*18;
double _fieldWidth = _playerWidth*16;
double _fieldHeight = _playerHeight*16;
late Room _room;


void main() {
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
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatelessWidget {
  const _MyHomePage();

  @override
  Widget build(BuildContext context) {
    _playerWidth = (MediaQuery.of(context).size.width / 20).floorToDouble();
    _playerHeight = (MediaQuery.of(context).size.height / 30).floorToDouble();
    _room = Room(1, _fieldWidth ~/ _playerWidth, _fieldHeight ~/ _playerHeight);

    return const MyHomePage(title: "fds");
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

  gettingEnemyCoordinates() {
    enemyPos.clear();
    for(int i = 0; i < enemyKeys.length; i++) {
      if (RectGetter.getRectFromKey(enemyKeys[i]) != null){
        enemyPos.add(RectGetter.getRectFromKey(enemyKeys[i]));
      }
    }
    enemyKeys.clear();
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
      gettingEnemyCoordinates();
      Rect nextPos = Rect.fromLTRB(playerPoz.left, playerPoz.top - _stepY, playerPoz.right, playerPoz.bottom);
      if (!posKeys.any((element) => nextPos.overlaps(element)) && !enemyPos.any((element) => nextPos.overlaps(element))) {
        posY = posY - _stepY;
      }
    });
  }

  goDownward() {
    setState(() {
      gettingCoordinates();
      gettingEnemyCoordinates();
      Rect nextPos = Rect.fromLTRB(playerPoz.left, playerPoz.top, playerPoz.right, playerPoz.bottom + _stepY);
      if (!posKeys.any((element) => nextPos.overlaps(element)) && !enemyPos.any((element) => nextPos.overlaps(element))) {
        posY = posY + _stepY;
      }
    });
  }

  goLeft() {
    setState(() {
      gettingCoordinates();
      gettingEnemyCoordinates();
      Rect nextPos = Rect.fromLTRB(playerPoz.left - _stepX, playerPoz.top, playerPoz.right, playerPoz.bottom);
      if (!posKeys.any((element) => nextPos.overlaps(element)) && !enemyPos.any((element) => nextPos.overlaps(element))) {
        posX = posX - _stepX;
      }
    });
  }

  goRight() {
    setState(() {
      gettingCoordinates();
      gettingEnemyCoordinates();
      Rect nextPos = Rect.fromLTRB(playerPoz.left, playerPoz.top, playerPoz.right + _stepX, playerPoz.bottom);
      if (!posKeys.any((element) => nextPos.overlaps(element)) && !enemyPos.any((element) => nextPos.overlaps(element))) {
        posX = posX + _stepX;
      }
    });
  }

  spawnEnemy() {
    var _enemyKey = RectGetter.createGlobalKey();
    var rectGetter = RectGetter(
        key: _enemyKey,
        child: SizedBox(
          width: _playerWidth,
          height: _playerHeight,
          child: Container(
            color: Colors.red,
          ),
        )
    );
    enemyKeys.add(_enemyKey);
    return rectGetter;
  }

  double posX = _playerWidth*3;
  double posY = _playerHeight*3;
  double horizontalWallsLength = _playerWidth*8;
  double verticalWallsLength = _playerHeight*8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
              child: Container(
                  color: Colors.black12,
                  child: SizedBox(
                    width: _fullFieldWidth,
                    height: _fullFieldHeight,
                    child: Stack(
                      children: <Widget>[
                        /// Generate top side
                        Positioned(
                          left: 0,
                          child: Row(
                            children: [
                              ///Generate upper left wall
                              generateWall(context, _playerHeight, horizontalWallsLength, upperLeftWallPozKey, Colors.black),
                              ///Generate upper exit
                              generateWall(context, _playerHeight, _playerWidth*2, upperExit, Colors.black12),
                              ///Generate upper right wall
                              generateWall(context, _playerHeight, horizontalWallsLength, upperRightWallPozKey, Colors.black),
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
                                generateWall(context, _playerHeight, horizontalWallsLength, lowerLeftWallPozKey, Colors.black),
                                ///Generate lower exit
                                generateWall(context, _playerHeight, _playerWidth*2, lowerExit, Colors.black12),
                                ///Generate lower right wall
                                generateWall(context, _playerHeight, horizontalWallsLength, lowerRightWallPozKey, Colors.black),
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
                              generateWall(context, verticalWallsLength, _playerWidth, leftUpperWallPozKey, Colors.black),
                              ///Generate left exit
                              generateWall(context, _playerHeight*2, _playerWidth, leftExit, Colors.black12),
                              ///Generate left lower wall
                              generateWall(context, verticalWallsLength, _playerWidth, leftLowerWallPozKey, Colors.black),
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
                              generateWall(context, verticalWallsLength, _playerWidth, rightUpperWallPozKey, Colors.black),
                              ///Generate left exit
                              generateWall(context, _playerHeight*2, _playerWidth, rightExit, Colors.black12),
                              ///Generate right lower wall
                              generateWall(context, verticalWallsLength, _playerWidth, rightLowerWallPozKey, Colors.black),
                            ],
                          ),
                        ),
                        for (int i = 0; i < _room.interior.length; i++)
                          for (int j = 0; j < _room.interior[i].length; j++)
                            Positioned(
                                top: _playerHeight*(i+1),
                                left: _playerWidth*(j+1),
                                child: SizedBox(
                                    width: _playerWidth,
                                    height: _playerHeight,
                                    child: _room.interior[i][j] == 2 ? spawnEnemy() : Container(),
                                    // child: Container(
                                    //   decoration: BoxDecoration(
                                    //     border: Border.all(color: Colors.white),
                                    //     color: _room.interior[i][j] == 2 ? Colors.red : Colors.amber
                                    //   ),
                                    // )
                                )
                            ),
                        // getEnemyKeysLog(),
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