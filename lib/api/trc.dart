import 'dart:math';

import 'package:dio/dio.dart';
import 'package:terminal/api/types.dart';

class BlockchainTrc implements BlockchainApi {
  static const endpoint = 'https://apilist.tronscanapi.com';
  static int lastBlock = 0;
  static final Dio dio = Dio();

  final String apiKeyTrc;

  const BlockchainTrc(this.apiKeyTrc);

  // Map mapper(Map transactions) {
  //   return {
  //     'result': transactions['data'].map((key, value) => ({
  //           'tokenDecimal': value['tokenInfo']['tokenDecimal'],
  //           'amount': value['amount']
  //         }))
  //   };
  // }

  @override
  Future<Map> last(String address) async {
    return {};
  }

  Future<double> updateLastBalance(String address) async {
    dynamic response = await dio.get(
      '$endpoint/api/account/tokens?address=$address&start=0&limit=20&token=&hidden=0&show=0&sortType=0',
      options: Options(headers: {'TRON-PRO-API-KEY': apiKeyTrc}),
    );
    return double.parse(response.data['data'][1]['balance']) /
        pow(10, response.data['data'][1]['tokenDecimal']);
  }

  @override
  Future<void> updateLastBlock() async {}
}
