import 'dart:convert';

import 'package:congrega/features/lifecounter/model/PlayerPoints.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  
  group('From ', (){

    test('PlayerPoints set to JSON and viceversa', (){
      PlayerPoints lifePoints = new LifePoints(20);
      Set<PlayerPoints> pointSet = {lifePoints};

      String jsonVersion = jsonEncode(pointSet.toList());

      Set pointSetReturned = (jsonDecode(jsonVersion))
          .map((elem) => PlayerPoints.fromJson(elem))
          .toSet();

      expect(pointSetReturned, contains(lifePoints));

    });
    
  });

}