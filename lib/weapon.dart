class Weapon {
  int atk;
  String type;
  //int level;

  Weapon(this.atk, this.type) {
    //Random rng = new Random();
    //this.atk = rng.nextInt(10 * level) + level;
  }

  int GetWeaponAtk() {
    return atk;
  }

  String GetWeaponType() {
    return type;
  }
}