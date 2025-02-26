import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Pay1Page extends StatefulWidget {
  const Pay1Page({super.key});

  @override
  State<Pay1Page> createState() => _Pay1PageState();
}

class _Pay1PageState extends State<Pay1Page> {
  String amount = '0';
  int tips = 2;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final Map data =
        (ModalRoute.of(context)!.settings.arguments as Map)['data'];
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.07),
        child: Column(
          children: [
            const Spacer(flex: 112),
            Expanded(
              flex: 415,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.07),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 4),
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.25),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Spacer(flex: 36),
                    Row(
                      children: [
                        Text(
                          'Amount to Pay: ',
                          style: getStyle(height),
                        ),
                        const Spacer(),
                        Text(
                          "$amount AED",
                          style: getStyle(height),
                        ),
                      ],
                    ),
                    const Spacer(flex: 33),
                    Container(
                      height: 1,
                      width: width,
                      color: const Color(0xFF9A9797),
                    ),
                    const Spacer(flex: 33),
                    Row(
                      children: [
                        Text(
                          'Total: ',
                          style: getStyle(height),
                        ),
                        const Spacer(),
                        Text(
                          "${((double.parse(amount) / 3.5) * (1 + tips / 100)).toStringAsFixed(2)} USDT",
                          style: getStyle(height),
                        ),
                      ],
                    ),
                    const Spacer(flex: 33),
                    Container(
                      height: 1,
                      width: width,
                      color: const Color(0xFF9A9797),
                    ),
                    const Spacer(flex: 33),
                    Row(
                      children: [
                        Text(
                          'Tips: ',
                          style: getStyle(height),
                        ),
                        const Spacer(),
                        Text(
                          '$tips%',
                          style: getStyle(height),
                        ),
                      ],
                    ),
                    const Spacer(flex: 26),
                    Expanded(
                      flex: 74,
                      child: Row(
                        children: [
                          tipsChangeButton(height, width, 5),
                          const Spacer(),
                          tipsChangeButton(height, width, 10),
                          const Spacer(),
                          tipsChangeButton(height, width, 15),
                          const Spacer(),
                          tipsChangeButton(height, width, 20),
                        ],
                      ),
                    ),
                    const Spacer(flex: 26),
                  ],
                ),
              ),
            ),
            const Spacer(flex: 74),
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
                    getButton('.', height, width),
                    SizedBox(width: width * 0.014),
                    getButton('0', height, width),
                    SizedBox(width: width * 0.014),
                    getButton('←', height, width),
                    const Spacer(),
                  ],
                ),
              ],
            ),
            const Spacer(flex: 26),
            Expanded(
              flex: 105,
              child: Container(
                width: width * 0.208 * 3 + width * 0.014 * 2,
                decoration: BoxDecoration(
                  color: const Color(0xFF0085FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => Navigator.of(context).pushNamed(
                      '/pay2',
                      arguments: {
                        'data': data,
                        'amountInAED': amount,
                        'tips': tips,
                        'logo': (ModalRoute.of(context)!.settings.arguments
                            as Map)['logo'],
                        'mainId': (ModalRoute.of(context)!.settings.arguments
                            as Map)['mainId'],
                        'mainData': (ModalRoute.of(context)!.settings.arguments
                            as Map)['mainData'],
                      },
                    ),
                    child: Center(
                      child: Text(
                        'Pay',
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
            const Spacer(flex: 42),
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
            const Spacer(flex: 59),
          ],
        ),
      ),
    );
  }

  Widget tipsChangeButton(double height, double width, int value) {
    return Container(
      width: width * 0.14,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.25),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(
            () {
              tips = value;
            },
          ),
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              "$value%",
              style: GoogleFonts.inter(
                color: const Color(0xFF555555),
                fontSize: height * 0.02,
                height: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle getStyle(double height) {
    return GoogleFonts.inter(
      color: const Color(0xFF222222),
      fontSize: height * 0.022,
      height: 1.2,
      fontWeight: FontWeight.w700,
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
            if (text != '←' && text != '.') {
              if (amount != '0' && amount != '0.0') {
                setState(
                  () {
                    amount += text;
                  },
                );
              } else if (amount == '0.0') {
                setState(
                  () {
                    amount = '0.$text';
                  },
                );
              } else {
                setState(
                  () {
                    amount = text;
                  },
                );
              }
            } else if (text == '.') {
              if (amount != '0') {
                setState(
                  () {
                    amount += text;
                  },
                );
              } else {
                setState(
                  () {
                    amount = '0${text}0';
                  },
                );
              }
            } else {
              if (amount.length > 1) {
                setState(
                  () {
                    amount = amount.substring(0, amount.length - 1);
                  },
                );
              } else if (amount.length == 1) {
                setState(
                  () {
                    amount = '0';
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
