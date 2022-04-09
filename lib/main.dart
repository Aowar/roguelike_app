import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:roguelike_app/armor.dart';
import 'package:roguelike_app/libs.dart';
import 'package:roguelike_app/weapon.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'hero.dart' as player;
import 'character.dart';

final audioPlayer = AudioPlayer();
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
var chestKey = RectGetter.createGlobalKey();
late Rect? chestPos;

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
int enemies = 0;
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
  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
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
    _hero = player.Hero(Weapon(2, "sword"), Armour(2), 1, _playerHeight, _playerWidth);
    room = Room(Random().nextInt(101), _fieldWidth ~/ _playerWidth, _fieldHeight ~/ _playerHeight, _hero.level);
    audioPlayer.stop();
    final _audioCache = AudioCache(fixedPlayer: audioPlayer);
    _audioCache.play("Suction.mp3");
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
    exitPos.add(RectGetter.getRectFromKey(rightExit));
    exitPos.add(RectGetter.getRectFromKey(lowerExit));
    exitPos.add(RectGetter.getRectFromKey(leftExit));
  }

  getEnemyCoordinates() {
    enemyPos.clear();
    for(int i = 0; i < enemyKeys.length; i++) {
      if (RectGetter.getRectFromKey(enemyKeys[i]) != null){
        enemyPos.add(RectGetter.getRectFromKey(enemyKeys[i]));
        enemies++;
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

  getChestCoordinates() {
    chestPos = RectGetter.getRectFromKey(chestKey);
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
    if (room.type == 4) {
      getChestCoordinates();
    }
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
      if(enemyKeys.isEmpty) {
        _hero.hp = _hero.maxhp;
      }
      room = Room(Random().nextInt(101), _fieldWidth ~/ _playerWidth, _fieldHeight ~/ _playerHeight, _hero.level);
      enemyKeys.clear();
      enemyPos.clear();
      wallsKeys.clear();
      wallsPos.clear();
      exitPos.clear();
      posKeys.clear();
      enemies = 0;
      audioPlayer.stop();
      // final _audioCache = AudioCache(fixedPlayer: audioPlayer);
      // _audioCache.play("wooo.mp3");
    }
  }

  restartLevel() {
    room = Room(Random().nextInt(101), _fieldWidth ~/ _playerWidth, _fieldHeight ~/ _playerHeight, _hero.level);
    enemyKeys.clear();
    enemyPos.clear();
    wallsKeys.clear();
    wallsPos.clear();
    exitPos.clear();
    posKeys.clear();
    enemies = 0;
    audioPlayer.stop();
    // final _audioCache = AudioCache(fixedPlayer: audioPlayer);
    // _audioCache.play("Suction.mp3");
  }

  goUpward() {
    setState(() {
      if(_hero.hp <= 0)
      {
        playerDead();
      }
      getAllCoordinates();
      Rect nextPos = Rect.fromLTRB(playerPoz.left, playerPoz.top - _stepY, playerPoz.right, playerPoz.bottom);
      if (!posKeys.any((element) => nextPos.overlaps(element)) && !enemyPos.any((element) => nextPos.overlaps(element)) && !wallsPos.any((element) => nextPos.overlaps(element))) {
        posY = posY - _stepY;
        posYPl > 0 ? posYPl-- : posYPl = posYPl;
        if (room.type == 4 && chestPos != null) {
          if (nextPos.overlaps(chestPos!)){
            room.interior[posXPl][posYPl].OpenChest(_hero);
            room.interior[posXPl][posYPl] = 0;
          }
        }
      }
      enemyMovement();
      getNextLevel(nextPos, 1);
    });
    clearAllKeys();
  }

  goDownward() {
    setState(() {
      getAllCoordinates();
      Rect nextPos = Rect.fromLTRB(playerPoz.left, playerPoz.top, playerPoz.right, playerPoz.bottom + _stepY);
      if (!posKeys.any((element) => nextPos.overlaps(element)) && !enemyPos.any((element) => nextPos.overlaps(element)) && !wallsPos.any((element) => nextPos.overlaps(element))) {
        posY = posY + _stepY;
        posYPl < room.interior.length ? posYPl++ : posYPl = posYPl;
        if (room.type == 4 && chestPos != null) {
          if (nextPos.overlaps(chestPos!)){
            room.interior[posXPl][posYPl].OpenChest(_hero);
            room.interior[posXPl][posYPl] = 0;
          }
        }
      }
      enemyMovement();
      getNextLevel(nextPos, 3);
    });
    clearAllKeys();
  }

  goLeft() {
    setState(() {
      getAllCoordinates();
      Rect nextPos = Rect.fromLTRB(playerPoz.left - _stepX, playerPoz.top, playerPoz.right, playerPoz.bottom);
      if (!posKeys.any((element) => nextPos.overlaps(element)) && !enemyPos.any((element) => nextPos.overlaps(element)) && !wallsPos.any((element) => nextPos.overlaps(element))) {
        posX = posX - _stepX;
        posXPl > 0 ? posXPl-- : posXPl = posXPl;
        if (room.type == 4 && chestPos != null) {
          if (nextPos.overlaps(chestPos!)){
            room.interior[posXPl][posYPl].OpenChest(_hero);
            room.interior[posXPl][posYPl] = 0;
          }
        }
      }
      enemyMovement();
      getNextLevel(nextPos, 4);
    });
    clearAllKeys();
  }

  goRight() {
    setState(() {
      getAllCoordinates();
      Rect nextPos = Rect.fromLTRB(playerPoz.left, playerPoz.top, playerPoz.right + _stepX, playerPoz.bottom);
      if (!posKeys.any((element) => nextPos.overlaps(element)) && !enemyPos.any((element) => nextPos.overlaps(element)) && !wallsPos.any((element) => nextPos.overlaps(element))) {
        posX = posX + _stepX;
        posXPl < room.interior[0].length ? posXPl++ : posXPl = posXPl;
        if (room.type == 4 && chestPos != null) {
          if (nextPos.overlaps(chestPos!)){
            room.interior[posXPl][posYPl].OpenChest(_hero);
            room.interior[posXPl][posYPl] = 0;
          }
        }
      }
      getNextLevel(nextPos, 2);
      enemyMovement();
    });
    clearAllKeys();
  }

  prepareAttack() {
    setState(() {
      attackFlag = !attackFlag;
    });
  }

  playerAttack(int direction) {
    int _enemies = enemies;
    setState(() {
      switch (direction) {
        case 1:
          if(_hero.weapon.GetWeaponType()=="sword") {
            _hero.attack(posYPl - 1, posXPl, room);
          } else if(_hero.weapon.GetWeaponType()=="spear"){
            _hero.attack(posYPl - 1, posXPl, room);
            _hero.attack(posYPl - 2, posXPl, room);
          }
          break;
        case 2:
          if(_hero.weapon.GetWeaponType()=="sword") {
            _hero.attack(posYPl, posXPl + 1, room);
          } else if(_hero.weapon.GetWeaponType()=="spear"){
            _hero.attack(posYPl, posXPl + 1, room);
            _hero.attack(posYPl, posXPl + 2, room);
          }
          break;
        case 3:
          if(_hero.weapon.GetWeaponType()=="sword") {
            _hero.attack(posYPl + 1, posXPl, room);
          } else if(_hero.weapon.GetWeaponType()=="spear"){
            _hero.attack(posYPl + 1, posXPl, room);
            _hero.attack(posYPl + 2, posXPl, room);
          }
          break;
        case 4:
          if(_hero.weapon.GetWeaponType()=="sword") {
            _hero.attack(posYPl, posXPl - 1, room);
          } else if(_hero.weapon.GetWeaponType()=="spear"){
            _hero.attack(posYPl, posXPl - 1, room);
            _hero.attack(posYPl, posXPl - 2, room);
          }
          break;
      }
      enemyMovement();
      // if (_enemies > enemies) {
      //   audioPlayer.stop();
      //   final _audioCache = AudioCache(fixedPlayer: audioPlayer);
      //   _audioCache.play(genEnemyDeathSound());
      // }
    });
    enemyKeys.clear();
  }

  enemyMovement() {
    for (int i = 0; i < room.interior.length; i++){
      for (int j = 0; j < room.interior[i].length; j++) {
        if (room.interior[i][j] is Char) {
          room.search(posYPl,posXPl, i, j, _hero);
        }
      }
    }
  }

  String genEnemyDeathSound() {
    int _random = Random.secure().nextInt(100);
    if (_random >= 0 && _random < 25) {
      return "fuck-you1.mp3";
    } else if (_random >= 25 && _random < 50) {
      return "Take_it_boy.mp3";
    } else if (_random >= 50 && _random < 75) {
      return "spank.mp3";
    } else {
      return "You_like_that.mp3";
    }
  }

  getEnemy(int i, int j) {
    var _enemyKey = RectGetter.createGlobalKey();
    var rectGetter = RectGetter(
        key: _enemyKey,
        child: SizedBox(
          width: _playerWidth,
          height: _playerHeight,
          child: Container(
            color: Colors.red,
              // decoration: const BoxDecoration(
              //   image: DecorationImage(
              //     fit: BoxFit.fill,
              //     image: AssetImage("assets/van_darkkhom_fuck_you.png"),
              //   ),
              // ),
              child: Center(
                child: Text(room.interior[i][j].hp.toString(),
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white
                    )
                ),
              )
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

  getChest() {
    var rectGetter = RectGetter(
        key: chestKey,
        child: SizedBox(
          width: _playerWidth,
          height: _playerHeight,
          child: Container(
            color: Colors.amber,
          ),
        )
    );
    return rectGetter;
  }

  getItem(int i) {
    return SizedBox(
        width: 80,
        height: 80,
        child: GestureDetector(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all()
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if(_hero.inventory[i] is Weapon) ...[
                  Text(_hero.inventory[i].type.toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text("Attack: " + _hero.inventory[i].atk.toString(),
                    style: const TextStyle(fontSize: 14),
                  )
                ] else ...[
                  Text("Armor" + _hero.inventory[i].def.toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
                ]
              ],
            ),
          ),
          onTap: () {
            setState(() {
              if(_hero.inventory[i] is Weapon) {
                _hero.SetWeapon(_hero.inventory[i]);
              } else {
                _hero.SetArmour(_hero.inventory[i]);
              }
            });
          },
        )
    );
  }

  playerDead() {
    audioPlayer.stop();
    // final _audioCache = AudioCache(fixedPlayer: audioPlayer);
    // _audioCache.play("rip_ears.mp3");
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text("You died",
            style: TextStyle(
              fontSize: 22,
              color: Colors.red,
            ),
          ),
          // const Image(
          //   image: AssetImage("assets/17-178465_gachibass-gachi-gasm.png"),
          //   fit: BoxFit.fill,
          // ),
          Text("You killed: " + _hero.kills.toString(),
            style: const TextStyle(
              fontSize: 20,
              color: Colors.red,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Press ",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                ),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      audioPlayer.stop();
                      _hero = _hero = player.Hero(Weapon(2, "sword"), Armour(2), 1, _playerHeight, _playerWidth);
                      restartLevel();
                      posX = _playerWidth;
                      posY = _playerHeight;
                      posXPl = 0;
                      posYPl = 0;
                      attackFlag = false;
                    });
                  },
                  icon: const Icon(Icons.refresh_sharp, color: Colors.red)
              ),
              const Text(" to restart",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double horizontalWallsLength = _playerWidth*8;
  double verticalWallsLength = _playerHeight*8;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _hero.hp <= 0 ? playerDead() : Scaffold(
        body: Stack(
          children: [
            // Align(
            //   alignment: Alignment.topCenter,
            //   child: SizedBox(
            //     width: _fullFieldWidth,
            //     height: _fullFieldHeight,
            //     child: Image(
            //       image: const AssetImage("assets/maxresdefault.jpg"),
            //       color: Colors.black.withOpacity(0.4),
            //       fit: BoxFit.fill,
            //       colorBlendMode: BlendMode.dstATop,
            //     ),
            //   ),
            // ),
            Column(
              children: [
                SizedBox(
                    child: Container(
                        color: Colors.black12,
                        child: SizedBox(
                          width: _fullFieldWidth,
                          height: _fullFieldHeight,
                          child: Stack(
                            children: [
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
                                        child: room.interior[i][j] is Char ? getEnemy(i, j) : (room.interior[i][j] == 0 ? Container() : (room.interior[i][j] == 1 ? getWall() : getChest())),
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
                                          // decoration: const BoxDecoration(
                                          //   image: DecorationImage(
                                          //     fit: BoxFit.fill,
                                          //     image: AssetImage("assets/billy-herrington_5e28bb54852d5.png"),
                                          //   ),
                                          // ),
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
                      padding: const EdgeInsets.only(top: 20),
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
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: IconButton(
                                                      icon: const Icon(Icons.arrow_upward_rounded),
                                                      color: attackFlag ? Colors.red : Colors.black,
                                                      onPressed: () {attackFlag ? playerAttack(1) : goUpward();},
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        SizedBox(
                                                          width: 50,
                                                          height: 50,
                                                          child: IconButton(
                                                            icon: const Icon(Icons.keyboard_arrow_left_rounded),
                                                            color: attackFlag ? Colors.red : Colors.black,
                                                            onPressed: () {attackFlag ? playerAttack(4) : goLeft();},
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 50,
                                                          height: 50,
                                                          child: IconButton(
                                                            icon: const Icon(Icons.local_fire_department),
                                                            color: attackFlag ? Colors.red : Colors.black,
                                                            onPressed: prepareAttack,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 50,
                                                          height: 50,
                                                          child: IconButton(
                                                            icon: const Icon(Icons.keyboard_arrow_right_rounded),
                                                            color: attackFlag ? Colors.red : Colors.black,
                                                            onPressed: () {attackFlag ? playerAttack(2) : goRight();},
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: IconButton(
                                                      icon: const Icon(Icons.arrow_downward_rounded),
                                                      color: attackFlag ? Colors.red : Colors.black,
                                                      onPressed: () {attackFlag ? playerAttack(3) : goDownward();},
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
                                    left: MediaQuery.of(context).size.width / 25,
                                    child: SizedBox(
                                        width: 65,
                                        height: 55,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.black)
                                            ),
                                            child: Center(
                                              child: Text("hp: " + _hero.hp.toString(),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14
                                                ),
                                              ),
                                            )
                                        )
                                    ),
                                  ),
                                  Positioned(
                                    left: MediaQuery.of(context).size.width / 25,
                                    bottom: 0,
                                    child: SizedBox(
                                        width: 65,
                                        height: 55,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.black)
                                            ),
                                            child: Center(
                                              child: Text("xp: " + _hero.exp.toString(),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14
                                                ),
                                              ),
                                            )
                                        )
                                    ),
                                  ),
                                  Positioned(
                                    right: MediaQuery.of(context).size.width / 25,
                                    child: SizedBox(
                                        width: 65,
                                        height: 55,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.black)
                                            ),
                                            child: Center(
                                              child: Text("lvl: " + _hero.level.toString(),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14
                                                ),
                                              ),
                                            )
                                        )
                                    ),
                                  ),
                                  Positioned(
                                    right: MediaQuery.of(context).size.width / 25,
                                    bottom: 0,
                                    child: SizedBox(
                                        width: 65,
                                        height: 55,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.black)
                                            ),
                                            child: Center(
                                              child: Text(_hero.weapon.type,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14
                                                ),
                                              ),
                                            )
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                      ),
                    )
                ),
              ],
            ),
            SlidingUpPanel(
              header: Padding(
                padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 2.2, 0, 0, 0),
                child: const Text("inventory",
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
              ),
              slideDirection: SlideDirection.UP,
              minHeight: 30,
              maxHeight: MediaQuery.of(context).size.height,
              panel: Stack(
                children: [
                  Positioned(
                    top: 30,
                    left: 30,
                    child: Text("Player attack: " + _hero.atk.toString() + "\nPlayer defence: " + _hero.def.toString(),
                      style: const TextStyle(
                          fontSize: 20
                      ),
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if(_hero.inventory.isNotEmpty) ...[
                          for(int i = 0; i < _hero.inventory.length; i++)
                            getItem(i)
                        ] else ...[
                          const Center(
                            child: Text("Inventory is empty",
                              style: TextStyle(
                                  fontSize: 22
                              ),
                            ),
                          )
                        ]
                      ],
                    ),
                  )
                ],
              )
            )
          ],
        )
    );
  }
}