import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:terminal/api/bsc.dart';
import 'package:terminal/api/eth.dart';
import 'package:terminal/api/trc.dart';
import 'package:terminal/api/types.dart';
import 'package:terminal/components/app_image.dart';
import 'package:terminal/components/demo.dart';
import 'package:terminal/components/fb.dart';

class Pay2Page extends StatefulWidget {
  const Pay2Page({super.key});

  @override
  State<Pay2Page> createState() => _Pay2PageState();
}

class _Pay2PageState extends State<Pay2Page> {
  double initWalletBalance = 0;
  Timer? timer;
  bool paid = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      if (!mounted) return;
      final Map args = ModalRoute.of(context)!.settings.arguments as Map;
      String address = args['data']['address'];
      String name = args['data']['name'];
      final String amountAED = args['amountInAED'];
      final int tips = args['tips'];

      if (kDemoMode) {
        timer = Timer(Demo.paymentDelay, () => onPaid(args));
        return;
      }

      late BlockchainApi api;

      if (name == 'USDT BEP-20') {
        api = BlockchainBsc(args['data']['api_key'] as String);
      }

      if (name == 'USDT ERC-20') {
        api = BlockchainEth(args['data']['api_key'] as String);
      }

      if (name == 'USDT TRC-20') {
        api = BlockchainTrc(args['data']['api_key'] as String);
        initWalletBalance = await (api as BlockchainTrc).updateLastBalance(
          address,
        );
      }

      await api.updateLastBlock();
      if (!mounted) return;

      timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        String amount = ((double.parse(amountAED) / 3.5) * (1 + tips / 100))
            .toStringAsFixed(2);

        if (name == 'USDT TRC-20') {
          double balanceWallet = await (api as BlockchainTrc).updateLastBalance(
            address,
          );

          if ((initWalletBalance + double.parse(amount)) <= balanceWallet) {
            await onPaid(args);
          }
          return;
        }

        var lastTransactions = (await api.last(address))['result'];
        if (lastTransactions.isNotEmpty) {
          int tokenDecimal = int.parse(lastTransactions[0]['tokenDecimal']);
          int value = int.parse(lastTransactions[0]['value']);

          String amountBlockchain = (value / pow(10, tokenDecimal))
              .toStringAsFixed(2);

          if (double.parse(amountBlockchain) >= double.parse(amount)) {
            await onPaid(args);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> onPaid(Map args) async {
    if (!mounted || paid) return;
    paid = true;
    timer?.cancel();

    await FB().addHistory(args['mainId'].toString(), args['amountInAED']);

    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/success',
      (route) => false,
      arguments: {
        'logo': args['mainData']['logo'],
        'check_logo': args['mainData']['check_logo'],
        'cryptoName': args['data']['name'],
        'payAddress': args['data']['address'],
        'amountAED': args['amountInAED'],
        'tips': args['tips'],
        'mainId': args['mainId'],
        'mainData': args['mainData'],
        'result': true,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map data =
        (ModalRoute.of(context)!.settings.arguments as Map)['data'];
    final String amount =
        (ModalRoute.of(context)!.settings.arguments as Map)['amountInAED'];
    final int tips =
        (ModalRoute.of(context)!.settings.arguments as Map)['tips'];
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.07),
        child: Column(
          children: [
            const Spacer(flex: 77),
            Expanded(
              flex: 136,
              child: appImage(
                (ModalRoute.of(context)!.settings.arguments as Map)['logo'],
                fit: BoxFit.fitHeight,
              ),
            ),
            const Spacer(flex: 15),
            Expanded(
              flex: 295,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                width: 295 / 1440 * height,
                child: data['qr'] != null
                    ? Image.network(data['qr'], fit: BoxFit.fitHeight)
                    : QrImageView(
                        data: data['address'],
                        padding: EdgeInsets.zero,
                      ),
              ),
            ),
            const Spacer(flex: 9),
            Expanded(
              flex: 15,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: const LinearProgressIndicator(
                  color: Color(0xFF357DE9),
                  backgroundColor: Color(0xFFCAD8ED),
                ),
              ),
            ),
            const Spacer(flex: 9),
            Expanded(
              flex: 62,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      data['address'],
                      style: GoogleFonts.inter(
                        fontSize: 25 / 1440 * height,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111111),
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(flex: 12),
            Expanded(
              flex: 543,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.07),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    const Spacer(flex: 36),
                    Row(
                      children: [
                        Text('Amount in AED: ', style: getStyle(height)),
                        const Spacer(),
                        Text("$amount AED", style: getStyle(height)),
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
                        Text('Tips: ', style: getStyle(height)),
                        const Spacer(),
                        Text('2%', style: getStyle(height)),
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
                        Text('Additional Tips: ', style: getStyle(height)),
                        const Spacer(),
                        Text('${tips - 2}%', style: getStyle(height)),
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
                        Text('Network: ', style: getStyle(height)),
                        const Spacer(),
                        Text(data['name'], style: getStyle(height)),
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
                        Text('Total to Pay: ', style: getStyle(height)),
                        const Spacer(),
                        Text(
                          "${((double.parse(amount) / 3.5) * (1 + tips / 100)).toStringAsFixed(2)} USDT",
                          style: getStyle(height),
                        ),
                      ],
                    ),
                    const Spacer(flex: 50),
                  ],
                ),
              ),
            ),
            const Spacer(flex: 22),
            Expanded(
              flex: 105,
              child: Row(
                children: [
                  Expanded(
                    flex: 280,
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
                              'Add Tips',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF373737),
                                fontSize: height * 0.024,
                                height: 1.2,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 23),
                  Expanded(
                    flex: 280,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () =>
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/main',
                                (route) => false,
                                arguments: {
                                  'data':
                                      (ModalRoute.of(
                                            context,
                                          )!.settings.arguments
                                          as Map)['mainData'],
                                  'mainId':
                                      (ModalRoute.of(
                                            context,
                                          )!.settings.arguments
                                          as Map)['mainId'],
                                },
                              ),
                          child: Center(
                            child: Text(
                              'Home',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF373737),
                                fontSize: height * 0.024,
                                height: 1.2,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 30),
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
                  Image.asset('assets/logo.png', fit: BoxFit.fitHeight),
                ],
              ),
            ),
            const Spacer(flex: 69),
          ],
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
}
