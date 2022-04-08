import 'package:audioplayers/audioplayers.dart';
import 'package:roguelike_app/main.dart';
import 'package:roguelike_app/room.dart';
import 'dart:developer' as dev;
import 'armor.dart';
import 'character.dart';
import 'weapon.dart';

class Hero extends Char {
  Weapon weapon;
  Armour armour;
  int kills = 0;
  int exp = 0;
  late int expneeded;
  var inventory = [];

  Hero(this.weapon, this.armour, level, x, y) : super(level, x, y) {
    maxhp = level*50;
    hp = maxhp;
    expneeded = level * 100;
  }

  void Hit(Char char) {
    super.Hit(char);
    GiveXP(char);

  }

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

  void LvlUp() {
    if(exp >= expneeded) {
      exp = exp - expneeded;
      level++;
      maxhp = level * 50;
      hp = maxhp;
      atk = level * 8 + weapon.GetWeaponAtk();
      expneeded = level * 100;
    }
  }

  void GiveXP(Char char) {
    if(CheckHP(char)) {
      kills++;
      exp = exp + (expneeded/10).round();
      hp += ((maxhp-hp)/2).round();
      if(hp > maxhp) {
        hp = maxhp;
      }
      LvlUp();
    }
  }
}