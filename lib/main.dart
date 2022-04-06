import 'dart:async';

import 'package:roguelike_app/armor.dart';
import 'package:roguelike_app/libs.dart';
import 'package:roguelike_app/weapon.dart';
import 'dart:developer' as dev;
import 'hero.dart' as player;
import 'character.dart';

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
List<dynamic> wallsKeys = [];
List<dynamic> wallsPos = [];
List<dynamic> exitPos = [];
final List<dynamic> posKeys = [];
double posX = _playerWidth;
double posY = _playerHeight;
var _playerWidth;
var _playerHeight;
double _fullFieldWidth = _playerWidth*19;
double _fullFieldHeight = _playerHeight*19;
double _fieldWidth = _playerWidth*17;
double _fieldHeight = _playerHeight*17;
late Room room;
int posYPl=0;
int posXPl=0;
bool attackFlag = false;
late player.Hero _hero;

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
    room = Room(1, _fieldWidth ~/ _playerWidth, _fieldHeight ~/ _playerHeight);
    _hero = player.Hero(Weapon(2), Armour(2), 1, _playerHeight, _playerWidth);
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

  getCoordinates() {
    playerPoz = RectGetter.getRectFromKey(playerPozKey)!;
    posKeys.clear();
    exitPos.clear();
    posKeys.add(RectGetter.getRectFromKey(upperLeftWallPozKey)!);
    posKeys.add(RectGetter.getRectFromKey(upperRightWallPozKey)!);
    posKeys.add(RectGetter.getRectFromKey(lowerLeftWallPozKey)!);
    posKeys.add(RectGetter.getRectFromKey(lowerRightWallPozKey)!);
    posKeys.add(RectGetter.getRectFromKey(leftUpperWallPozKey)!);
    posKeys.add(RectGetter.getRectFromKey(leftLowerWallPozKey)!);
    posKeys.add(RectGetter.getRectFromKey(rightUpperWallPozKey)!);
    posKeys.add(RectGetter.getRectFromKey(rightLowerWallPozKey)!);
    exitPos.add(RectGetter.getRectFromKey(upperExit));
    exitPos.add(RectGetter.getRectFromKey(leftExit));
    exitPos.add(RectGetter.getRectFromKey(lowerExit));
    exitPos.add(RectGetter.getRectFromKey(leftExit));
  }

  getEnemyCoordinates() {
    enemyPos.clear();
    for(int i = 0; i < enemyKeys.length; i++) {
      if (RectGetter.getRectFromKey(enemyKeys[i]) != null){
        enemyPos.add(RectGetter.getRectFromKey(enemyKeys[i]));
      }
    }
  }

  getWallCoordinates() {
    wallsPos.clear();
    for(int i = 0; i < wallsKeys.length; i++) {
      if (RectGetter.getRectFromKey(wallsKeys[i]) != null){
        enemyPos.add(RectGetter.getRectFromKey(wallsKeys[i]));
      }
    }
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

  clearAllKeys() {
    enemyKeys.clear();
    wallsKeys.clear();
  }

  getAllCoordinates() {
    getCoordinates();
    getEnemyCoordinates();
    getWallCoordinates();
  }

  getNextLevel(Rect position, int direction) {
    if (exitPos.any((element) => element.overlaps(position))) {
      switch (direction) {
        case 1:
          posY = _playerHeight * 17;
          posYPl += 16;
          break;
        case 2:
          posX = _playerWidth;
          posXPl = 0;
          break;
        case 3:
          posY = _playerHeight;
          posYPl = 0;
          break;
        case 4:
          posX = _playerWidth * 17;
          posXPl += 16;
          break;
      }
      room = Room(Random().nextInt(101), _fieldWidth ~/ _playerWidth, _fieldHeight ~/ _playerHeight);
      enemyKeys.clear();
      enemyPos.clear();
      wallsKeys.clear();
      wallsPos.clear();
      exitPos.clear();
      posKeys.clear();
    }
  }

  goUpward() {
    setState(() {
      getAllCoordinates();
      Rect nextPos = Rect.fromLTRB(playerPoz.left, playerPoz.top - _stepY, playerPoz.right, playerPoz.bottom);
      if (!posKeys.any((element) => nextPos.overlaps(element)) && !enemyPos.any((element) => nextPos.overlaps(element)) && !wallsPos.any((element) => nextPos.overlaps(element))) {
        posY = posY - _stepY;
        posYPl > 0 ? posYPl-- : posYPl = posYPl;
      }
      getNextLevel(nextPos, 1);
      enemyMovement();
    });
    clearAllKeys();
  }

  goDownward() {
    getAllCoordinates();
    setState(() {
      getAllCoordinates();
      Rect nextPos = Rect.fromLTRB(playerPoz.left, playerPoz.top, playerPoz.right, playerPoz.bottom + _stepY);
      if (!posKeys.any((element) => nextPos.overlaps(element)) && !enemyPos.any((element) => nextPos.overlaps(element)) && !wallsPos.any((element) => nextPos.overlaps(element))) {
        posY = posY + _stepY;
        posYPl < room.interior.length ? posYPl++ : posYPl = posYPl;
      }
      enemyMovement();
      getNextLevel(nextPos, 3);
    });
    clearAllKeys();
  }

  goLeft() {
    getAllCoordinates();
    setState(() {
      getAllCoordinates();
      Rect nextPos = Rect.fromLTRB(playerPoz.left - _stepX, playerPoz.top, playerPoz.right, playerPoz.bottom);
      if (!posKeys.any((element) => nextPos.overlaps(element)) && !enemyPos.any((element) => nextPos.overlaps(element)) && !wallsPos.any((element) => nextPos.overlaps(element))) {
        posX = posX - _stepX;
        posXPl > 0 ? posXPl-- : posXPl = posXPl;
      }
      enemyMovement();
      getNextLevel(nextPos, 4);
    });
    clearAllKeys();
  }

  goRight() {
    getAllCoordinates();
    setState(() {
      getAllCoordinates();
      Rect nextPos = Rect.fromLTRB(playerPoz.left, playerPoz.top, playerPoz.right + _stepX, playerPoz.bottom);
      if (!posKeys.any((element) => nextPos.overlaps(element)) && !enemyPos.any((element) => nextPos.overlaps(element)) && !wallsPos.any((element) => nextPos.overlaps(element))) {
        posX = posX + _stepX;
        posXPl < room.interior[0].length ? posXPl++ : posXPl = posXPl;
      }
      enemyMovement();
      getNextLevel(nextPos, 2);
    });
    clearAllKeys();
  }

  prepareAttack() {
    setState(() {
      attackFlag = !attackFlag;
    });
  }

  attack(int direction) {
    setState(() {
      switch (direction) {
        case 1:
          _hero.attack(posYPl - 1, posXPl, room);
          _hero.attack(posYPl - 2, posXPl, room);
          break;
        case 2:
          _hero.attack(posYPl, posXPl + 1, room);
          _hero.attack(posYPl, posXPl + 2, room);
          break;
        case 3:
          _hero.attack(posYPl + 1, posXPl, room);
          _hero.attack(posYPl + 2, posXPl, room);
          break;
        case 4:
          _hero.attack(posYPl, posXPl - 1, room);
          _hero.attack(posYPl, posXPl - 2, room);
          break;
      }
    });
    enemyKeys.clear();
  }

  enemyMovement() {
    for (int i = 0; i < room.interior.length; i++){
      for (int j = 0; j < room.interior[i].length; j++) {
        if (room.interior[i][j] is Char) {
          room.search(posYPl,posXPl, i, j);
        }
      }
    }
  }

  getEnemy() {
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

  getWall() {
    var _wallKey = RectGetter.createGlobalKey();
    var rectGetter = RectGetter(
        key: _wallKey,
        child: SizedBox(
          width: _playerWidth,
          height: _playerHeight,
          child: Container(
            color: Colors.black,
          ),
        )
    );
    wallsKeys.add(_wallKey);
    return rectGetter;
  }
  double horizontalWallsLength = _playerWidth*8;
  double verticalWallsLength = _playerHeight*8;
  late Timer _timer;

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
                              generateWall(context, _playerHeight, _playerWidth*3, upperExit, Colors.black12),
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
                                generateWall(context, _playerHeight, _playerWidth*3, lowerExit, Colors.black12),
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
                              generateWall(context, _playerHeight*3, _playerWidth, leftExit, Colors.black12),
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
                              generateWall(context, _playerHeight*3, _playerWidth, rightExit, Colors.black12),
                              ///Generate right lower wall
                              generateWall(context, verticalWallsLength, _playerWidth, rightLowerWallPozKey, Colors.black),
                            ],
                          ),
                        ),
                        for (int i = 0; i < room.interior.length; i++)
                          for (int j = 0; j < room.interior[i].length; j++)
                            Positioned(
                                top: _playerHeight*(i+1),
                                left: _playerWidth*(j+1),
                                child: SizedBox(
                                  width: _playerWidth,
                                  height: _playerHeight,
                                  child: room.interior[i][j] is Char ? getEnemy() : (room.interior[i][j] == 0 ? Container() : (room.interior[i][j] == 1 ? getWall() : Container(color: Colors.amber))),
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
                                                color: attackFlag ? Colors.red : Colors.black,
                                                onPressed: () {attackFlag ? attack(1) : goUpward();},
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
                                                      color: attackFlag ? Colors.red : Colors.black,
                                                      onPressed: () {attackFlag ? attack(4) : goLeft();},
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: IconButton(
                                                      icon: Icon(Icons.keyboard_arrow_right_rounded),
                                                      color: attackFlag ? Colors.red : Colors.black,
                                                      onPressed: () {attackFlag ? attack(2) : goRight();},
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
                                                color: attackFlag ? Colors.red : Colors.black,
                                                onPressed: () {attackFlag ? attack(3) : goDownward();},
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            ),
                            Positioned(
                              top: 5,
                              right: 15,
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: IconButton(
                                  icon: Icon(Icons.arrow_downward_rounded),
                                  onPressed: prepareAttack,
                                ),
                              ),
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