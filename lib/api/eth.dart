import 'package:dio/dio.dart';
import 'package:terminal/api/types.dart';

class BlockchainEth implements BlockchainApi {
  static const endpoint = 'https://api.etherscan.io';
  static int lastBlock = 0;
  static Dio dio = Dio();

  final String apiKeyEth;

  const BlockchainEth(this.apiKeyEth);

  @override
  Future<Map> last(String address) async {
    dynamic response = await dio.get(
      '$endpoint/api?module=account&action=tokentx&address=$address&startblock=$lastBlock&endblock=99999999&contractaddress=0xdAC17F958D2ee523a2206206994597C13D831ec7&page=1&offset=0&sort=asc&apikey=$apiKeyEth',
    );
    return response.data;
  }

  @override
  Future<void> updateLastBlock() async {
    dynamic response = await dio.get(
      '$endpoint/api?module=block&action=getblocknobytime&timestamp=${DateTime.now().millisecondsSinceEpoch ~/ 1000}&closest=before&apikey=$apiKeyEth',
    );
    lastBlock = int.parse(response.data['result']);
  }
}
