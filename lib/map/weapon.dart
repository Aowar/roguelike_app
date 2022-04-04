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