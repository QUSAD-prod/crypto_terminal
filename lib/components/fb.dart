import 'package:firebase_database/firebase_database.dart';

class FB {
  FirebaseDatabase database = FirebaseDatabase.instance;

  Future<Map?> tryGetTerminal(String id) async {
    return (await database.ref('terminals').child(id).get()).value as Map?;
  }
}
