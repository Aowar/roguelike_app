import 'package:roguelike_app/room.dart';

import 'bobject.dart';

class Char extends Bobject{
  int level;
  late int maxhp;
  late int hp;
  late int atk;
  late int def;

  Char(this.level, x, y) : super(x, y) {
    atk = level * 8;
    maxhp = level * 50;
    hp = maxhp;
    def = level * 2;
  }

  void Hit(Char char) {
    int reduce = (100/(100 + char.GetDef())).round(); //формула снижения урона
    char.SetHP(char.GetHP() - atk * reduce); //урон по персу
  }

  int GetLvl() {
    return level;
  }

  int GetAtk() {
    return atk;
  }

  int GetDef() {
    return def;
  }

  int GetHP() {
    return hp;
  }

  void SetLvl(int level) {
    this.level = level;
  }

  void SetAtk(int atk) {
    this.atk = atk;
  }

  void SetDef(int def) {
    this.def = def;
  }

  void SetHP(int hp) {
    this.hp = hp;
  }

  bool CheckHP(Char char) {
    if (char.hp <= 0) {
      return true;
    }
    else {
      return false;
    }
  }

  void attack(int i, j, Room room){
    if(room.interior[i][j] is Char){
      Char char = room.interior[i][j];
      Hit(char);
      room.interior[i][j] = char;
      if(CheckHP(char)) {
        room.interior[i][j]=0;
      }
    }
  }
}