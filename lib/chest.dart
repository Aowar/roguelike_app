import 'dart:math';

import 'bobject.dart';
import 'hero.dart';

class Chest extends Bobject {
  var item;

  Chest(x, y) : super(x, y) {
    Random rng = new Random();
    int gen = rng.nextInt(2);
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