import 'package:firebase_database/firebase_database.dart';
import 'package:terminal/components/demo.dart';

class FB {
  FirebaseDatabase get database => FirebaseDatabase.instance;

  Future<Map?> tryGetTerminal(String id) async {
    if (kDemoMode) return Demo.terminal;
    return (await database.ref('terminals').child(id).get()).value as Map?;
  }

  Stream<List> history(String id) {
    if (kDemoMode) return Demo.history();
    return database
        .ref('terminals')
        .child(id)
        .child('history')
        .onValue
        .map((event) => (event.snapshot.value as List?) ?? []);
  }

  Future<void> addHistory(String id, String amount) async {
    final Map entry = {
      'amount': amount,
      'timestamp': DateTime.now().toLocal().millisecondsSinceEpoch,
    };
    if (kDemoMode) {
      Demo.addHistory(entry);
      return;
    }

    DatabaseReference ref = database
        .ref('terminals')
        .child(id)
        .child('history');
    List? data1 = (await ref.get()).value as List?;
    List? data2 = [];
    if (data1 != null) {
      data2.addAll(data1);
    }
    data2.add(entry);
    await ref.set(data2);
  }
}
