import 'bobject.dart';

class Char extends Bobject{
  int level;
  int hp;
  int atk;
  int def;

  Char(this.level, this.atk, this.def, this.hp, x, y) : super(x, y);

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
}