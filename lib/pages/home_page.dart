import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terminal/components/fb.dart';
import 'package:terminal/components/ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String id = '';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    AppUi ui = AppUi(context: context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.07),
        child: Column(
          children: [
            const Spacer(
              flex: 107,
            ),
            Expanded(
              flex: 131,
              child: Center(
                child: Image.asset(
                  'assets/logo.png',
                ),
              ),
            ),
            const Spacer(
              flex: 149,
            ),
            Expanded(
              flex: 105,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    id == '' ? "Host id" : id,
                    style: GoogleFonts.inter(
                      fontSize: height * 0.023,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      color: id == ''
                          ? const Color(0xFF7C7C7C)
                          : const Color(0xFF222222),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(
              flex: 46,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Spacer(),
                    getButton('1', height, width),
                    SizedBox(width: width * 0.014),
                    getButton('2', height, width),
                    SizedBox(width: width * 0.014),
                    getButton('3', height, width),
                    const Spacer(),
                  ],
                ),
                SizedBox(height: width * 0.014),
                Row(
                  children: [
                    const Spacer(),
                    getButton('4', height, width),
                    SizedBox(width: width * 0.014),
                    getButton('5', height, width),
                    SizedBox(width: width * 0.014),
                    getButton('6', height, width),
                    const Spacer(),
                  ],
                ),
                SizedBox(height: width * 0.014),
                Row(
                  children: [
                    const Spacer(),
                    getButton('7', height, width),
                    SizedBox(width: width * 0.014),
                    getButton('8', height, width),
                    SizedBox(width: width * 0.014),
                    getButton('9', height, width),
                    const Spacer(),
                  ],
                ),
                SizedBox(height: width * 0.014),
                Row(
                  children: [
                    const Spacer(),
                    getButton('←', height, width),
                    const Spacer(),
                  ],
                ),
              ],
            ),
            const Spacer(
              flex: 75,
            ),
            Expanded(
              flex: 105,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0085FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      if (id != '') {
                        Map? temp = await FB().tryGetTerminal(id);
                        if (temp != null) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            Navigator.of(context).pushReplacementNamed(
                              '/main',
                              arguments: {
                                'data': temp,
                                'mainId': id,
                              },
                            );
                          }
                        } else {
                          ui.buildSnackBar(
                            message: 'Invalid id',
                            errorEnabled: true,
                          );
                        }
                      } else {
                        ui.buildSnackBar(
                          message: 'Empty field',
                          errorEnabled: true,
                        );
                      }
                    },
                    child: Center(
                      child: Text(
                        'Enter',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: height * 0.034,
                          height: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(
              flex: 160,
            ),
          ],
        ),
      ),
    );
  }

  Container getButton(String text, double height, double width) {
    return Container(
      height: width * 0.208 * 0.88,
      width: width * 0.208,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (text != '←') {
              setState(
                () {
                  id += text;
                },
              );
            } else {
              if (id.isNotEmpty) {
                setState(
                  () {
                    id = id.substring(0, id.length - 1);
                  },
                );
              }
            }
          },
          borderRadius: BorderRadius.circular(18),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: height * 0.034,
                height: 1.2,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF555555),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
