import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final Map data =
        (ModalRoute.of(context)!.settings.arguments as Map)['data'];
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.07),
        child: Column(
          children: [
            const Spacer(flex: 95),
            Expanded(
              flex: 136,
              child: Image.network(
                data['logo'],
                fit: BoxFit.fitHeight,
              ),
            ),
            const Spacer(flex: 97),
            Expanded(
              flex: 784,
              child: SingleChildScrollView(
                child: Column(
                  children: getCryptoButtons(width, height, data),
                ),
              ),
            ),
            const Spacer(flex: 40),
            Expanded(
              flex: 105,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => Navigator.of(context).pushNamed(
                      '/history',
                      arguments: {
                        "data": data,
                        'id': (ModalRoute.of(context)!.settings.arguments
                            as Map)['mainId'],
                      },
                    ),
                    child: Center(
                      child: Text(
                        'History',
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
      ),
    );
  }

  List<Widget> getCryptoButtons(double width, double height, Map data) {
    List<dynamic> crypto = data['wallets'];
    List<Widget> cryptoButtons = [];
    bool isEven = crypto.length % 2 == 0;
    for (int i = 0; i < crypto.length; i += 2) {
      if (isEven) {
        cryptoButtons.addAll(
          [
            Row(
              children: [
                getCryptoButton(width, crypto, i, height, data),
                SizedBox(
                  width: 42 / 720 * width,
                ),
                getCryptoButton(width, crypto, i + 1, height, data),
              ],
            ),
            SizedBox(
              height: 42 / 720 * width,
            ),
          ],
        );
      } else {
        if (crypto.length - i >= 2) {
          cryptoButtons.addAll(
            [
              Row(
                children: [
                  getCryptoButton(width, crypto, i, height, data),
                  SizedBox(
                    width: 42 / 720 * width,
                  ),
                  getCryptoButton(width, crypto, i + 1, height, data),
                ],
              ),
              SizedBox(
                height: 42 / 720 * width,
              ),
            ],
          );
        } else {
          cryptoButtons.addAll(
            [
              Row(
                children: [
                  getCryptoButton(width, crypto, i, height, data),
                  const Spacer(),
                ],
              ),
            ],
          );
        }
      }
    }
    return cryptoButtons;
  }

  Container getCryptoButton(
    double width,
    List<dynamic> crypto,
    int i,
    double height,
    Map data,
  ) {
    return Container(
      width: 285 / 720 * width,
      height: 285 / 720 * width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => Navigator.of(context).pushNamed(
            '/pay1',
            arguments: {
              'data': crypto[i],
              'logo': data['logo'],
              'mainId':
                  (ModalRoute.of(context)!.settings.arguments as Map)['mainId'],
              'mainData': data,
            },
          ),
          child: Column(
            children: [
              const Spacer(flex: 31),
              Expanded(
                flex: 124,
                child: Row(
                  children: [
                    const Spacer(flex: 85),
                    Expanded(
                      flex: 130,
                      child: SvgPicture.asset(
                        getLogoPath(crypto[i]['name'])!,
                      ),
                    ),
                    const Spacer(flex: 70),
                  ],
                ),
              ),
              const Spacer(flex: 30),
              Expanded(
                flex: 41,
                child: Text(
                  crypto[i]['name'],
                  style: GoogleFonts.inter(
                    fontSize: 32 / 1440 * height,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF222222),
                  ),
                ),
              ),
              const Spacer(flex: 47),
            ],
          ),
        ),
      ),
    );
  }

  String? getLogoPath(String name) {
    switch (name) {
      case "USDT TRC-20":
        return "assets/TRC-20_icon.svg";
      case "USDT BEP-20":
        return "assets/BEP-20_icon.svg";
      case "USDT ERC-20":
        return "assets/ERC-20_icon.svg";
    }
    return null;
  }
}
