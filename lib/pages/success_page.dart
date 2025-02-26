import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({super.key});

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";

  bool printing = true;

  @override
  void initState() {
    super.initState();
    _bindingPrinter().then(
      (bool? isBind) async {
        SunmiPrinter.paperSize().then(
          (int size) {
            setState(
              () {
                paperSize = size;
              },
            );
          },
        );

        SunmiPrinter.printerVersion().then(
          (String version) {
            setState(
              () {
                printerVersion = version;
              },
            );
          },
        );

        SunmiPrinter.serialNumber().then(
          (String serial) {
            setState(
              () {
                serialNumber = serial;
              },
            );
          },
        );

        setState(
          () {
            printBinded = isBind!;
          },
        );

        await myPrint(
          (ModalRoute.of(context)!.settings.arguments as Map)['check_logo'],
          (ModalRoute.of(context)!.settings.arguments as Map)['amountAED'],
          (ModalRoute.of(context)!.settings.arguments as Map)['tips'],
          (ModalRoute.of(context)!.settings.arguments as Map)['payAddress'],
          (ModalRoute.of(context)!.settings.arguments as Map)['cryptoName'],
          false,
        ).whenComplete(
          () => setState(
            () => printing = false,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool success =
        (ModalRoute.of(context)!.settings.arguments as Map)['result'];
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.097),
        child: Column(
          children: [
            const Spacer(flex: 128),
            Expanded(
              flex: 140,
              child: Image.network(
                (ModalRoute.of(context)!.settings.arguments as Map)['logo'],
              ),
            ),
            const Spacer(flex: 128),
            Expanded(
              flex: 470,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    const Spacer(flex: 60),
                    Center(
                      child: Text(
                        success ? "Payment Confirmed" : "Failed",
                        style: GoogleFonts.inter(
                          fontSize: height * 0.03,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF222222),
                        ),
                      ),
                    ),
                    const Spacer(flex: 105),
                    Expanded(
                      flex: 200,
                      child: SvgPicture.asset(
                        success ? 'assets/access.svg' : 'assets/failed.svg',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    const Spacer(flex: 65),
                  ],
                ),
              ),
            ),
            const Spacer(flex: 28),
            Expanded(
              flex: 110,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    printing ? "Printing..." : "Printed.",
                    style: GoogleFonts.inter(
                      fontSize: height * 0.027,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF222222),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(flex: 110),
            Expanded(
              flex: 105,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0085FF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => Navigator.of(context).pushReplacementNamed(
                      '/main',
                      arguments: {
                        'data': (ModalRoute.of(context)!.settings.arguments
                            as Map)['mainData'],
                        'mainId': (ModalRoute.of(context)!.settings.arguments
                            as Map)['mainId'],
                      },
                    ),
                    child: Center(
                      child: Text(
                        'Home',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: height * 0.027,
                          height: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(flex: 60),
            Expanded(
              flex: 80,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Powered by ',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF151515),
                      fontSize: height * 0.024,
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
            const Spacer(flex: 90),
          ],
        ),
      ),
    );
  }

  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  Future<void> myPrint(
    String logoUrl,
    String amountInAED,
    int tips,
    String payAdress,
    String cryptoName,
    bool again,
  ) async {
    await SunmiPrinter.initPrinter();

    Uint8List byteLogo =
        (await NetworkAssetBundle(Uri.parse(logoUrl)).load(logoUrl))
            .buffer
            .asUint8List();

    const web3Logo =
        'https://firebasestorage.googleapis.com/v0/b/crypto-terminal-f09dd.appspot.com/o/logo_w3p.png?alt=media&token=7c517e53-97e4-41d4-9772-78b54c4439d5';

    Uint8List byteWeb3Logo =
        (await NetworkAssetBundle(Uri.parse(web3Logo)).load(web3Logo))
            .buffer
            .asUint8List();

    await SunmiPrinter.startTransactionPrint(true);
    await SunmiPrinter.lineWrap(2);
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printImage(byteLogo);
    await SunmiPrinter.lineWrap(2);
    await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);
    await SunmiPrinter.printText('Amount in AED: $amountInAED');
    await SunmiPrinter.printText(
      'Paid: ${((double.parse(amountInAED) / 3.5) * (1 + tips / 100)).toStringAsFixed(2)} $cryptoName',
    );
    await SunmiPrinter.printText('Network: ${cryptoName.split(' ')[1]}');
    await SunmiPrinter.printText('Tips: 2%');
    await SunmiPrinter.printText('Additional Tips: ${(tips - 2).toString()}%');
    await SunmiPrinter.lineWrap(2);
    await SunmiPrinter.printText('Paid to: $payAdress');
    await SunmiPrinter.lineWrap(2);
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printText(
      DateFormat("dd.MM.yyyy HH:mm").format(
        DateTime.now().toLocal(),
      ),
    );
    await SunmiPrinter.lineWrap(2);
    await SunmiPrinter.printText('Powered by:');
    await SunmiPrinter.printImage(byteWeb3Logo);
    await SunmiPrinter.lineWrap(5);

    await SunmiPrinter.exitTransactionPrint(true);
    await SunmiPrinter.cut();

    if (!again) {
      Timer(
        const Duration(seconds: 2),
        () async => await myPrint(
          logoUrl,
          amountInAED,
          tips,
          payAdress,
          cryptoName,
          true,
        ),
      );
    }
  }

  Future<Uint8List> readFileBytes(String path) async {
    ByteData fileData = await rootBundle.load(path);
    Uint8List fileUnit8List = fileData.buffer
        .asUint8List(fileData.offsetInBytes, fileData.lengthInBytes);
    return fileUnit8List;
  }

  Future<Uint8List> _getImageFromAsset(String iconPath) async {
    return await readFileBytes(iconPath);
  }
}
