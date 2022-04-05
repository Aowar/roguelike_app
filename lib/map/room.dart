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
        interior[wight % 2][height % 2] = new Chest(wight % 2, height % 2);
      }
      // else if (type == 3) {
      //   interior[wight % 2][height % 2] = new Char(level, atk, def, hp, x, y);
      // }
      // else if (type == 1) {
      //   interior[wight % 2][height % 2] = 5;
      // }
      else {
        int k = 0;
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
                switch(max.nextInt(3)){
                  case 0:
                    interior[i][j] = 0;
                    break;
                  case 1:
                    interior[i][j] = 1;
                    break;
                  case 2:
                    interior[i][j] = Char(1, 1, 1, 10, i, j);
                    break;
                }

                if(interior[i][j]==1 && (i+j)%2==0){
                  interior[i+1][j+1]=1;
                  interior[i+1][j]=1;
                  interior[i][j+1]=1;//стенки 4 блока
                }
                if (interior[i][j] is Char) {
                  mob++; // считаем крипов в комнате
                }
              }
            }
          }
        }
        interior[0][center - 1] = 0;
        interior[0][center] = 0;
        interior[0][center + 1] = 0;
        interior[interior.length - 1][center - 1] = 0;
        interior[interior.length - 1][center] = 0;
        interior[interior.length - 1][center + 1] = 0;
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
  search(int iP,jP,iM,jM) {
    if ((iP - iM).abs() <= 2 && (jP - jM).abs() <= 2) { //пора атаковать если в растоянии 2 блуков враг
      attack();
    } else {
      if (iM - iP > 2 && interior[iM - 1][jM] != 1 && interior.length!=iM) { //проверка куда бвигаться, свободен ли путь и мы не на краю карты (если бахнем стенки на границе помнаты можно 3 улсловие убрать)
        interior[iM - 1][jM] = 2; //сдвиг
        interior[iM][jM] = 0; //обнуление
      }
      else if (iM - iP < 2 && interior[iM + 1][jM] != 1 && iM!=0) { //по аналогии
        interior[iM + 1][jM] = 2;
        interior[iM][jM] = 0;
      }
      if (jM - jP > 2 && interior[iM][jM - 1] != 1 && interior[0].length!=jM) {//по аналогии
        interior[iM][jM - 1] = 2;
        interior[iM][jM] = 0;
      }
      else if (jM - jP < 2 && interior[iM][jM + 1] != 1 && jM!=0) {//по аналогии
        interior[iM][jM + 1] = 2;
        interior[iM][jM] = 0;
      }
    }
  }

  attack(){

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
