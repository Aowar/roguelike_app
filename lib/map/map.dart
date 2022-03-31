import 'package:roguelike_app/libs.dart';

class AppMap{
  List<Room> rooms = [];

  AppMap(int wight, int height){
    print(wight);
    var max = Random();
    for(int i=0;i<wight;i++){
      rooms.add(Room(max.nextInt(100), height, wight));
    }
    rooms.first.type = 0;
    rooms.last.type = 1;
  }
}