import 'dart:math';

import 'weapon.dart';
import 'armor.dart';
import 'bobject.dart';
import 'hero.dart';

class Chest extends Bobject {
  late var item;

  Chest(x, y) : super(x, y);

  void OpenChest(Hero hero) {
    int gen = Random().nextInt(2);
    String type = "sword";
    if(gen == 1) {
      var wtype = Random().nextInt(2);
      if (wtype == 1) {
        type = "spear";
        item = Weapon(hero.GetLvl() + Random().nextInt(5) + 1, type);
      } else {
        item = Weapon(hero.GetLvl() + Random().nextInt(10) + 1, type);
      }
    }
    else {
      item = Armour(hero.GetLvl() + Random().nextInt(10) + 1);
    }
    hero.AddToInv(item);
  }
}