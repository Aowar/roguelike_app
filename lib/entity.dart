import 'dart:math';

class Bobject {
  int x;
  int y;

  Bobject(this.x, this.y);
}

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

class Hero extends Char {
  Weapon weapon;
  Armour armour;
  var inventory = [];

  Hero(this.weapon, this.armour, level, atk, def, hp, x, y) : super(level, atk, def, hp, x, y);

  void SetWeapon(Weapon weapon) {
    this.atk = atk + weapon.GetWeaponAtk() - this.weapon.GetWeaponAtk(); // надели новую пушку
    inventory.remove(weapon);
    inventory.add(this.weapon);
    this.weapon = weapon;
  }

  void SetArmour(Armour armour) {
    this.def = def + armour.GetArmourDef() - this.armour.GetArmourDef(); // надели новую тушку
    inventory.remove(armour);
    inventory.add(this.armour);
    this.armour = armour;
  }

  void AddToInv(var item) {
    inventory.add(item);
  }
}

//class Enemy extends Char {}

class Weapon {
  int atk;
  //int level;

  Weapon(this.atk) {
    //Random rng = new Random();
    //this.atk = rng.nextInt(10 * level) + level;
  }

  int GetWeaponAtk() {
    return atk;
  }
}

class Armour {
  int def;
  //int level;

  Armour(this.def) {
    //Random rng = new Random();
    //this.def = rng.nextInt(10 * level) + level;
  }

  int GetArmourDef() {
    return def;
  }
}

class Chest extends Bobject {
  var item;

  Chest(x, y) : super(x, y) {
    Random rng = new Random();
    int gen = rng.nextInt(1);
    if(gen == 1) {
      ///item = new Weapon(число * лвл);
    }
    else {
      ///item = new Armour(число * лвл);
    }
  }

  void OpenChest(Hero hero) {
    hero.AddToInv(item);
  }
}