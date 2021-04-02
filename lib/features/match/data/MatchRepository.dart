import 'package:congrega/features/match/model/Match.dart';
import 'package:state_persistence/state_persistence.dart';

class MatchRepository {

  final JsonFileStorage storageData = JsonFileStorage(clearDataOnLoadError: false, filename: 'data.json', initialData: {});

  Future<void> newMatch() async {

  }

  Future<void> recoverMatch() async {}

  Future<void> updateMatch() async {

  }

  Future<void> endMatch() async {
    storageData.save({});
  }

  Future<Match> getCurrentMatch() {
    return Future.delayed(new Duration(seconds: 1), () => Match.empty);
  }


}