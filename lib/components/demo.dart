import 'dart:async';

/// Run with `--dart-define=DEMO=true` to use local data instead of
/// Firebase and blockchain explorers.
const bool kDemoMode = bool.fromEnvironment('DEMO');

class Demo {
  static const Duration paymentDelay = Duration(seconds: 8);
  static const Duration printDelay = Duration(seconds: 3);

  static final Map terminal = {
    'logo': 'assets/logo.png',
    'check_logo': 'assets/logo.png',
    'wallets': [
      {
        'name': 'USDT TRC-20',
        'address': 'Tu5JTSGjuiDs7qgj8E1MK5iJ7BDmKJ5bNt',
        'api_key': '',
      },
      {
        'name': 'USDT BEP-20',
        'address': '0x64912c828b0a17210e24be1c22cd20e6f4a7177c',
        'api_key': '',
      },
      {
        'name': 'USDT ERC-20',
        'address': '0xfb8fc72d32d43fce64e326937ad42c2125ee77ae',
        'api_key': '',
      },
    ],
  };

  static final List<Map> _history = _initialHistory();
  static final StreamController<List> _changes =
      StreamController<List>.broadcast();

  static Stream<List> history() async* {
    yield List.of(_history);
    yield* _changes.stream;
  }

  static void addHistory(Map entry) {
    _history.add(entry);
    _changes.add(List.of(_history));
  }

  static List<Map> _initialHistory() {
    final DateTime now = DateTime.now();
    const List<(String, Duration)> payments = [
      ('1250', Duration(days: 4, hours: 3, minutes: 12)),
      ('89', Duration(days: 3, hours: 6, minutes: 40)),
      ('342.5', Duration(days: 2, hours: 1, minutes: 5)),
      ('64', Duration(days: 1, hours: 7, minutes: 31)),
      ('210', Duration(days: 1, hours: 2, minutes: 18)),
      ('45.75', Duration(hours: 5, minutes: 44)),
      ('520', Duration(hours: 2, minutes: 9)),
    ];
    return [
      for (final (amount, ago) in payments)
        {
          'amount': amount,
          'timestamp': now.subtract(ago).millisecondsSinceEpoch,
        },
    ];
  }
}
