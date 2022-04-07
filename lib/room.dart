import 'dart:developer' as dev;

import 'package:roguelike_app/libs.dart';

import 'package:roguelike_app/chest.dart';
import 'package:roguelike_app/character.dart';
import 'package:roguelike_app/hero.dart';
import 'package:roguelike_app/bobject.dart';
import 'package:roguelike_app/armor.dart';

class Room{
  int type = -1;
  int tp=-1;
  int mob=0;
  List<List<dynamic>> interior = [];

  Room(type, int height, int wight){
    if(type<=75){
      this.type = 2; //мобы
    }
    if(type<=95&&type>=75){
      this.type = 3;//ультра мобы
    }
    if(type<=100&&type>=95){
      this.type = 4;//рундук
    }
    getInterior(height, wight);
  }


  //0 - пустота
  //1 - стенка
  //2 - крип-крипочек
  //3 - ультракрип
  //4 - рундук (сундук для рун)
  //5 - босс
  getInterior(int height, int wight) {
    int mob=0;
    if (type != 0) {
      int center = height ~/ 2;
      var max = Random();
      for (int i = 0; i < wight; i++) {
        interior.add(List.filled(height, 0));
      }
      if(type == 4){
        interior[wight ~/ 2][height ~/ 2] = Chest(wight / 2, height / 2);
      }
      else {
        int k = 3;
        while(mob<5) {
          mob=0;
          for (int i = 0; i < wight; i++) {
            for (int j = 0; j < height; j++) {
              interior[i][j]=0;
            }
          }
          for (int i = 0; i < wight; i++) {
            for (int j = 0; j < height; j++) {
              if (getNearby(i, j, interior.length-1, interior[0].length-1)) {
                switch(max.nextInt(k)){
                  case 0:
                    interior[i][j] = 0;
                    break;
                  case 1:
                    interior[i][j] = 1;
                    break;
                  case 2:
                    if(max.nextInt(10)==9) {
                      interior[i][j] = Char(1, i, j);
                    }
                    break;
                }

                if(interior[i][j]==1 && (i+j)%2==0){
                  interior[i+1][j+1]=1;
                  interior[i+1][j]=1;
                  interior[i][j+1]=1;//стенки 4 блока
                }
                if (interior[i][j] is Char) {
                  mob++; // считаем крипов в комнате
                  // if(mob==5) k--;
                }
              }
            }
          }
        }
        ///верх
        interior[0].fillRange(0, interior[0].length - 1, 0);
        ///низ
        interior[interior.length - 1].fillRange(0, interior[0].length - 1, 0);
        ///справа
        for (var element in interior) {element[interior[0].length - 1] = 0;}
        ///слева
        for (var element in interior) {element[0] = 0;}
      }
    }
  }

  getNearby(int i, j, maxI, maxJ){
    if(i==0||j==0||i==maxI||j==maxJ) return false;
    if(interior[i+1][j]!=0||interior[i+1][j-1]!=0||interior[i+1][j+1]!=0||interior[i][j-1]!=0||interior[i][j+1]!=0||interior[i-1][j-1]!=0||interior[i-1][j]!=0||interior[i-1][j+1]!=0){
      return false;
    } else {
      return true;
    }
  }

  //принимает координаты плеера и монстра
  ///iP - координата x игрока (возможно y)
  ///jP - координата y игрока (возможно x)
  ///iM - координата x моба (возможно y)
  ///jM - координата y моба (возможно x)

  search(int iP,jP,iM,jM, Char hero) {
    if ((iP - iM).abs()+(jP - jM).abs()<2) { //пора атаковать если в растоянии 2 блуков враг
      interior[iM][jM].Hit(hero);
      // attack();
    } else if((iM - iP).abs()<5 && (jM - jP).abs()<5 ){
      if (iM-1>=0 && iM-iP> 0 && interior[iM - 1][jM] == 0 ) { //проверка куда бвигаться, свободен ли путь и мы не на краю карты (если бахнем стенки на границе помнаты можно 3 улсловие убрать)
        interior[iM - 1][jM] = interior[iM].elementAt(jM); //сдвиг
        interior[iM][jM] = 0; //обнуление
      }
      else if (iM+1<=interior.length-1 && iM - iP < 0 && interior[iM + 1][jM] == 0 ) { //по аналогии
        interior[iM + 1][jM] = interior[iM].elementAt(jM);
        interior[iM][jM] = 0;
        if ((iP - (iM + 1)).abs()+(jP - jM).abs()<2) { //пора атаковать если в растоянии 2 блуков враг
          num a = interior[iM + 1].elementAt(jM).atk;
          hero.hp += a.toInt();
        }
      }
      else if (jM-1 >=0 && jM - jP > 0 && interior[iM][jM - 1] == 0 ) {//по аналогии
        interior[iM][jM - 1] = interior[iM].elementAt(jM);
        interior[iM][jM] = 0;
      }
      else if (jM+1 <=interior[0].length-1 && jM - jP < 0 && interior[iM][jM + 1]==0) {//по аналогии
        interior[iM][jM + 1] = interior[iM].elementAt(jM);
        interior[iM][jM] = 0;
        if ((iP - iM).abs()+(jP - (jM + 1)).abs()<2) { //пора атаковать если в растоянии 2 блуков враг
          num a = interior[iM].elementAt(jM + 1).atk;
          hero.hp += a.toInt();
        }
      }
    }
  }

  @override
  String toString() {
    return 'Room{type: $type, tp: $tp}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Room &&
              runtimeType == other.runtimeType &&
              type == other.type &&
              tp == other.tp;

  @override
  int get hashCode => type.hashCode ^ tp.hashCode;
}
