import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List history = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        DatabaseReference databaseReference = FirebaseDatabase.instance
            .ref()
            .child('terminals')
            .child(
              (ModalRoute.of(context)!.settings.arguments as Map)['id'],
            )
            .child('history');

        databaseReference.onValue.listen(
          (event) {
            setState(
              () {
                if (event.snapshot.value == null) {
                  history = [];
                } else {
                  history = event.snapshot.value as List;
                }
                debugPrint('DEBUG!!!!!!!!!: $history');
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map data =
        (ModalRoute.of(context)!.settings.arguments as Map)['data'];
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          const Spacer(flex: 95),
          Expanded(
            flex: 136,
            child: Image.network(
              data['logo'],
              fit: BoxFit.fitHeight,
            ),
          ),
          Expanded(
            flex: 33,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFD8E6F0),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 8),
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 848,
            child: history.isEmpty
                ? Center(
                    child: Text(
                      'History is empty',
                      style: GoogleFonts.inter(
                        fontSize: height * 0.025,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF222222),
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: getHistory(width, height),
                    ),
                  ),
          ),
          Expanded(
            flex: 40,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFD8E6F0),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, -8),
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 105,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.07),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => Navigator.of(context).pop(),
                    child: Center(
                      child: Text(
                        'Back',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF373737),
                          fontSize: height * 0.023,
                          height: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(flex: 69),
          Expanded(
            flex: 45,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Powered by ',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF151515),
                    fontSize: height * 0.014,
                    height: 1.2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.fitHeight,
                )
              ],
            ),
          ),
          const Spacer(flex: 69),
        ],
      ),
    );
  }

  List<Widget> getHistory(double width, double height) {
    List<Widget> historyList = [];
    for (int i = history.length - 1; i >= 0; i--) {
      historyList.add(
        Container(
          width: 620 / 720 * width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          margin: const EdgeInsets.only(top: 18),
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
            vertical: height * 0.02,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${history[i]['amount']} AED',
                  style: GoogleFonts.inter(
                    fontSize: height * 0.02,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF222222),
                  ),
                ),
              ),
              Text(
                DateFormat("dd.MM.yyyy\nHH:mm").format(
                  DateTime.fromMillisecondsSinceEpoch(
                    history[i]['timestamp'],
                  ),
                ),
                style: GoogleFonts.inter(
                  fontSize: height * 0.02,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF222222),
                ),
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ),
      );
    }
    return historyList;
  }
}
