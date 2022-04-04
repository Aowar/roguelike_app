import 'armor.dart';
import 'character.dart';
import 'map/weapon.dart';

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