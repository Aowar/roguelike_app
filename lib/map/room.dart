import 'package:roguelike_app/libs.dart';

class Room{
  int type = -1;
  int tp=-1;
  int mob=0;
  List<List<int>> interior = [];

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
    if (type != 0) {
      int center = height ~/ 2;
      var max = Random();
      List<int> hei = [];
      for (int i = 0; i < height; i++) {
        hei.add(0);
      }
      for (int i = 0; i < wight; i++) {
        interior.add(hei);
      }
      List<List<int>> sas = interior;
      //закидываю массив 0
      if(type == 4){
        interior[wight % 2][height % 2] = 4;
      } else if (type == 3) {
        interior[wight % 2][height % 2] = 3;
      } else if (type == 1) {
        interior[wight % 2][height % 2] = 5;
      } else {
        while(mob<5) {
          interior=sas;//обнуление комнаты
          for (int i = 0; i < wight; i++) {
            for (int j = 0; j < height; j++) {
              if (getNearby(i, j, interior.length-1, interior[0].length-1)) {
                interior[i][j] = max.nextInt(3);
                if(interior[i][j]==1 && (i+j)%2==0){
                  interior[i+1][j+1]=1;
                  interior[i+1][j]=1;
                  interior[i][j+1]=1;//стенки 4 блока
                }
                if (interior[i][j] == 2) {
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

  search(int iP,jP,iM,jM) {
    if ((iP - iM).abs() <= 2 && (jP - jM).abs() <= 2) {
      attack();
    } else {
      if (iM - iP > 2 && interior[iM - 1][jM] != 1 && interior.length!=iM) {
        interior[iM - 1][jM] = 2;
        interior[iM][jM] = 0; //функцию перемещения монста надо
      }
      else if (iM - iP < 2 && interior[iM + 1][jM] != 1 && iM!=0) {
        interior[iM + 1][jM] = 2;
        interior[iM][jM] = 0; //функцию перемещения монста надо
      }
      if (jM - jP > 2 && interior[iM][jM - 1] != 1 && interior[0].length!=jM) {
        interior[iM][jM - 1] = 2;
        interior[iM][jM] = 0; //функцию перемещения монста надо
      }
      else if (jM - jP < 2 && interior[iM][jM + 1] != 1 && jM!=0) {
        interior[iM][jM + 1] = 2;
        interior[iM][jM] = 0; //функцию перемещения монста надо
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
