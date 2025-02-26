import 'package:dio/dio.dart';
import 'package:terminal/api/types.dart';

class BlockchainBsc implements BlockchainApi {
  static const endpoint = 'https://api.bscscan.com';
  static String lastBlock = '0';
  static final Dio dio = Dio();

  final String apiKeyBsc;

  const BlockchainBsc(this.apiKeyBsc);

  @override
  Future<Map> last(String address) async {
    dynamic response = await dio.get(
      '$endpoint/api?module=account&action=tokentx&address=$address&startblock=$lastBlock&endblock=99999999&contractaddress=0x55d398326f99059fF775485246999027B3197955&page=1&offset=0&sort=asc&apikey=$apiKeyBsc',
    );
    return response.data;
  }

  @override
  Future<void> updateLastBlock() async {
    dynamic response = await dio.get(
      '$endpoint/api?module=block&action=getblocknobytime&timestamp=${DateTime.now().millisecondsSinceEpoch ~/ 1000}&closest=before&apikey=$apiKeyBsc',
    );
    lastBlock = response.data['result'];
  }
}
